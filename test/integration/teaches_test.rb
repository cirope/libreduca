# encoding: utf-8

require 'test_helper'

class TeachesTest < ActionDispatch::IntegrationTest
  test 'should create a new teach' do
    login

    course = Fabricate(:course)
    teach = Fabricate.build(:teach, course_id: course.id)

    visit new_course_teach_path(course)

    find('#teach_start').click

    within '.ui-datepicker-calendar' do
      find('a.ui-state-default.ui-state-highlight').click
    end

    synchronize { find('.ui-datepicker-calendar').visible? }

    find('#teach_finish').click

    synchronize { find('.ui-datepicker-calendar').visible? }

    find('.ui-datepicker-header a.ui-datepicker-next').click

    within '.ui-datepicker-calendar' do
      first(:css, 'a.ui-state-default').click
    end

    fill_in find('#teach_description')[:id], with: teach.description

    user = Fabricate(:user, lastname: 'in_filtered_index').tap do |u|
      Fabricate(:job, user_id: u.id, institution_id: course.institution.id)
    end

    click_link Teach.human_attribute_name('enrollments', count: 0)

    assert page.has_css?('#enrollments_container fieldset:nth-child(1)')

    within '#enrollments_container fieldset' do
      fill_in find('input[name$="[auto_enrollable_name]"]')[:id], with: user.name
    end

    find('.ui-autocomplete li.ui-menu-item a').click

    assert page.has_no_css?('#enrollments_container fieldset:nth-child(2)')

    click_link I18n.t('view.teaches.new_enrollment')

    assert page.has_css?('#enrollments_container fieldset:nth-child(2)')

    # Must be removed before the next search, forcing the new "creation"
    page.execute_script("$('.ui-autocomplete').html('')")

    user = Fabricate(:user, lastname: 'in_filtered_index').tap do |u|
      Fabricate(:job, user_id: u.id, institution_id: course.institution.id)
    end

    within '#enrollments_container fieldset:nth-child(2)' do
      fill_in find('input[name$="[auto_enrollable_name]"]')[:id], with: user.name
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

    assert page.has_css?('#enrollments_container fieldset')

    within '#enrollments_container fieldset' do
      click_link '✘' # Destroy link
    end

    assert page.has_no_css?('#enrollments_container fieldset')
  end

  test 'should hide and mark for destruction an enrollment' do
    login

    teach = Fabricate(:teach) { enrollments { [Fabricate(:enrollment)] } }

    visit edit_teach_path(teach)

    click_link Teach.human_attribute_name('enrollments', count: 0)

    assert page.has_css?('#enrollments_container fieldset:nth-child(1)')

    within '#enrollments_container fieldset:nth-child(1)' do
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
      Fabricate :enrollment, teach_id: t.id, enrollable_id: user.id, job: 'student'
    end

    visit edit_teach_path(teach)

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

        Fabricate :enrollment, teach_id: t.id, enrollable_id: user.id, job: 'student'
      end
    end

    visit edit_teach_path(teach)

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
      Fabricate :enrollment, teach_id: t.id, enrollable_id: user.id, job: 'student'
    end

    2.times { Fabricate(:score, user_id: user.id, teach_id: teach.id) }

    visit teach_path(teach)

    click_link Teach.human_attribute_name('scores', count: 0)

    assert page.has_css?("a[href=\"#email_modal_#{user.id}\"]")

    first(:css, "a[href=\"#email_modal_#{user.id}\"]").click

    synchronize { find("#email_modal_#{user.id}").visible? }
    sleep 0.5 # For you Néstor... =) There is a bug in capybara and animations

    assert_difference 'ActionMailer::Base.deliveries.size' do
      assert page.has_no_css?('.modal .alert-success')

      find("#email_modal_#{user.id}").click_link I18n.t('label.send')

      assert page.has_css?('.modal .alert-success')
    end
  end

  test 'should send email summary' do
    login

    course = Fabricate(:course)
    teach = Fabricate(:teach, course_id: course.id)

    2.times do
      Fabricate(:user).tap do |u|
        Fabricate(
          :job, job: 'student', user_id: u.id, institution_id: course.institution.id
        )

        Fabricate :enrollment, teach_id: teach.id, enrollable_id: u.id, job: 'student'

        2.times { Fabricate(:score, user_id: u.id, teach_id: teach.id) }
      end
    end

    visit teach_path(teach)

    find('a[href="#email_modal"]').click

    synchronize { find('#email_modal').visible? }
    sleep 0.5 # For you Néstor... =) There is a bug in capybara and animations

    assert_difference 'ActionMailer::Base.deliveries.size', 2 do
      assert page.has_no_css?('.modal .alert-success')

      find('#email_modal').click_link I18n.t('label.send')

      assert page.has_css?('.modal .alert-success')
    end
  end

  test 'should show teach surveys' do
    institution = Fabricate(:institution)
    user = Fabricate(:user, password: '123456', roles: [:normal])
    login_into_institution institution: institution, user: user, as: 'teacher'

    course = Fabricate(:course) do
      grade_id { Fabricate(:grade, institution_id: institution.id).id }
    end
    teach = Fabricate(:teach, course_id: course.id)

    Fabricate(
      :enrollment, enrollable_id: user.id, teach_id: teach.id
    )

    Fabricate(:content, teach_id: teach.id).tap do |content|
      Fabricate(:survey, content_id: content.id).tap do |survey|
        Fabricate(:question, survey_id: survey.id).tap do |question|
          Fabricate(:answer, question_id: question.id).tap do |answer|
            5.times do
              reply = Fabricate(
                :reply, answer_id: answer.id, question_id: question.id
              )

              Fabricate(:job, user_id: reply.user_id, institution_id: institution.id)
              Fabricate(
                :enrollment,
                teach_id: teach.id,
                enrollable_id: reply.user_id
              )
            end
          end
        end
      end
    end

    visit teach_path(teach)

    assert page.has_no_css?('#surveys_container table.table')
    assert page.has_css?('a[href="#surveys_container"]')

    find('a[href="#surveys_container"]').click

    assert page.has_css?('#surveys_container table.table')
  end

  test 'should show historic teaches index' do
    login_into_institution as: 'student'

    grade = Fabricate(:grade, institution_id: @test_institution.id)
    course = Fabricate(:course, grade_id: grade.id)
    teach = Fabricate(:teach, course_id: course.id)

    Fabricate(
      :enrollment, enrollable_id: @test_user.id, teach_id: teach.id, job: 'student'
    )

    visit user_teaches_path(@test_user)

    assert_page_has_no_errors!

    assert page.has_css?('table.table')
  end
end
