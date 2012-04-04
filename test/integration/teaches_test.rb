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
    
    wait_until { !find('.ui-datepicker-calendar').visible? }
    
    find('#teach_finish').click
    
    wait_until { find('.ui-datepicker-calendar').visible? }
    
    find('.ui-datepicker-header a.ui-datepicker-next').click
    
    within '.ui-datepicker-calendar' do
      find('a.ui-state-default').click
    end
    
    user = Fabricate(:user, lastname: 'in_filtered_index').tap do |u|
      Fabricate(:job, user_id: u.id, school_id: course.school.id)
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
      Fabricate(:job, user_id: u.id, school_id: course.school.id)
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
      click_link '✔' # Destroy link
    end
    
    assert page.has_no_css?('.enrollment')
  end
  
  test 'should hide and mark for destruction an enrollment' do
    login
    
    teach = Fabricate(:teach) { enrollments! count: 1 }
    
    visit edit_course_teach_path(teach.course, teach)
    
    click_link Teach.human_attribute_name('enrollments', count: 0)
    
    assert page.has_css?('.enrollment')
    
    within '.enrollment' do
      click_link '✔' # Destroy link
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
      Fabricate :job, job: 'student', user_id: u.id, school_id: course.school.id
    end
    
    teach = Fabricate(:teach, course_id: course.id).tap do |t|
      Fabricate :enrollment, teach_id: t.id, user_id: user.id, job: 'student'
    end
    
    visit edit_course_teach_path(course, teach)
    
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
end