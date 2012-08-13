# encoding: utf-8

require 'test_helper'

class TeachesTest < ActionDispatch::IntegrationTest
  test 'should create a new teach' do
    login
    
    course = Fabricate(:course)
    
    visit new_course_teach_path(course)
    
    find('#teach_start').click
    
    within '.ui-datepicker-calendar' do
      find('a.ui-state-default.ui-state-highlight').click
    end
    
    wait_until { find('.ui-datepicker-calendar').visible? }
    
    find('#teach_finish').click
    
    wait_until { find('.ui-datepicker-calendar').visible? }
    
    find('.ui-datepicker-header a.ui-datepicker-next').click
    
    within '.ui-datepicker-calendar' do
      find('a.ui-state-default').click
    end
    
    user = Fabricate(:user, lastname: 'in_filtered_index').tap do |u|
      Fabricate(:job, user_id: u.id, institution_id: course.institution.id)
    end
    
    click_link Teach.human_attribute_name('enrollments', count: 0)
    
    within '.enrollment' do
      fill_in find('input[name$="[auto_user_name]"]')[:id], with: user.name
    end
      
    find('.ui-autocomplete li.ui-menu-item a').click
    
    assert page.has_no_css?('.enrollment:nth-child(2)')
    
    click_link I18n.t('view.teaches.new_enrollment')
    
    assert page.has_css?('.enrollment:nth-child(2)')
    
    # Must be removed before the next search, forcing the new "creation"
    page.execute_script("$('.ui-autocomplete').remove()")
    
    user = Fabricate(:user, lastname: 'in_filtered_index').tap do |u|
      Fabricate(:job, user_id: u.id, institution_id: course.institution.id)
    end
    
    within '.enrollment:nth-child(2)' do
      fill_in find('input[name$="[auto_user_name]"]')[:id], with: user.name
    end
    
    find('.ui-autocomplete li.ui-menu-item a').click
    
    assert_difference 'Teach.count' do
      assert_difference 'Enrollment.count', 2 do
        find('.btn.btn-primary').click
      end
    end
  end
  
  test 'should delete all enrollment inputs' do
    login
    
    course = Fabricate(:course)
    
    visit new_course_teach_path(course)
    
    click_link Teach.human_attribute_name('enrollments', count: 0)
    
    assert page.has_css?('.enrollment')
    
    within '.enrollment' do
      click_link '✘' # Destroy link
    end
    
    assert page.has_no_css?('.enrollment')
  end
  
  test 'should hide and mark for destruction an enrollment' do
    login
    
    teach = Fabricate(:teach) { enrollments { [Fabricate(:enrollment)] } }
    
    visit edit_course_teach_path(teach.course, teach)
    
    click_link Teach.human_attribute_name('enrollments', count: 0)
    
    assert page.has_css?('.enrollment')
    
    within '.enrollment' do
      click_link '✘' # Destroy link
    end
    
    assert_no_difference 'Teach.count' do
      assert_difference 'Enrollment.count', -1 do
        find('.btn.btn-primary').click
      end
    end
  end
  
  test 'should add a score' do
    login
    
    course = Fabricate(:course)
    
    user = Fabricate(:user).tap do |u|
      Fabricate :job, job: 'student', user_id: u.id, institution_id: course.institution.id
    end
    
    teach = Fabricate(:teach, course_id: course.id).tap do |t|
      Fabricate :enrollment, teach_id: t.id, user_id: user.id, job: 'student'
    end
    
    visit edit_course_teach_path(course, teach)

    click_link I18n.t('view.teaches.enter_scores')

    assert page.has_css?('.score')
    
    within '.score' do
      score_attributes = Fabricate.attributes_for(
        :score, teach_id: teach.id, user_id: user.id
      )
      
      fill_in find('input[name$="[score]"]')[:id],
        with: score_attributes['score']
      fill_in find('input[name$="[multiplier]"]')[:id],
        with: score_attributes['multiplier']
      fill_in find('input[name$="[description]"]')[:id],
        with: score_attributes['description']
    end
    
    assert_no_difference 'Teach.count' do
      assert_difference 'Score.count' do
        find('.btn.btn-primary').click
      end
    end
  end
  
  test 'should complete fields with global values' do
    login
    
    course = Fabricate(:course)
    
    teach = Fabricate(:teach, course_id: course.id).tap do |t|
      5.times do
        user = Fabricate(:user).tap do |u|
          Fabricate(
            :job, job: 'student', user_id: u.id, institution_id: course.institution.id
          )
        end
        
        Fabricate :enrollment, teach_id: t.id, user_id: user.id, job: 'student'
      end
    end
    
    visit edit_course_teach_path(course, teach)

    click_link I18n.t('view.teaches.enter_scores')
    
    fill_in 'global_multiplier', with: '30'
    fill_in 'global_description', with: 'Test'
    
    assert all('input.multiplier').all? { |m| m.value == '30' }
    assert all('input.description').all? { |d| d.value == 'Test' }
  end
  
  test 'send enrollment email' do
    login
    
    course = Fabricate(:course)
    
    user = Fabricate(:user).tap do |u|
      Fabricate :job, job: 'student', user_id: u.id, institution_id: course.institution.id
    end
    
    teach = Fabricate(:teach, course_id: course.id).tap do |t|
      Fabricate :enrollment, teach_id: t.id, user_id: user.id, job: 'student'
    end
    
    2.times { Fabricate(:score, user_id: user.id, teach_id: teach.id) }
    
    visit course_teach_path(course, teach)
    
    click_link '✉'
    
    wait_until { find('.modal').visible? }
    sleep 0.5 # For you Néstor... =) There is a bug in capybara and animations
    
    assert_difference 'ActionMailer::Base.deliveries.size' do
      assert page.has_no_css?('.modal .alert-success')
      
      click_link I18n.t('label.send')
      
      assert page.has_css?('.modal .alert-success')
    end
  end
  
  test 'send email summary' do
    login
    
    course = Fabricate(:course)
    teach = Fabricate(:teach, course_id: course.id)
    
    2.times do
      Fabricate(:user).tap do |u|
        Fabricate(
          :job, job: 'student', user_id: u.id, institution_id: course.institution.id
        )
        
        Fabricate :enrollment, teach_id: teach.id, user_id: u.id, job: 'student'
        
        2.times { Fabricate(:score, user_id: u.id, teach_id: teach.id) }
      end
    end
    
    visit course_teach_path(course, teach)
    
    find('a[href="#email_modal"]').click
    
    wait_until { find('.modal').visible? }
    sleep 0.5 # For you Néstor... =) There is a bug in capybara and animations
    
    assert_difference 'ActionMailer::Base.deliveries.size', 2 do
      assert page.has_no_css?('.modal .alert-success')
      
      click_link I18n.t('label.send')
      
      assert page.has_css?('.modal .alert-success')
    end
  end
end
