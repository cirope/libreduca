# encoding: utf-8

require 'test_helper'

class ForumsTest < ActionDispatch::IntegrationTest
  test 'should create a new forum in institution' do
    institution = Fabricate(:institution)
    forum = Fabricate.build(:forum, owner_id: institution.id, owner_type: 'Institution')

    login_into_institution institution: institution, as: 'janitor'

    visit new_institution_forum_path(institution)

    fill_in Forum.human_attribute_name('name'), with: forum.name
    fill_in Forum.human_attribute_name('topic'), with: forum.topic
    fill_in Forum.human_attribute_name('info'), with: forum.info

    assert_difference ['institution.forums.count', 'ActionMailer::Base.deliveries.size'] do
      find('.btn.btn-primary').click
    end
  end

  test 'should create a new forum in teach' do
    teach = Fabricate(:teach)
    institution = teach.institution
    forum = Fabricate.build(:forum, owner_id: teach.id, owner_type: 'Teach')

    login_into_institution institution: institution, as: 'janitor'

    visit new_teach_forum_path(teach)

    fill_in Forum.human_attribute_name('name'), with: forum.name
    fill_in Forum.human_attribute_name('topic'), with: forum.topic
    fill_in Forum.human_attribute_name('info'), with: forum.info

    assert_difference ['teach.forums.count', 'ActionMailer::Base.deliveries.size'] do
      find('.btn.btn-primary').click
    end
  end


  test 'should create a comment in institution as teacher' do
    institution = Fabricate(:institution)
    forum = Fabricate(:forum, owner_id: institution.id, owner_type: 'Institution')
    comment = Fabricate.build(
      :comment, commentable_id: forum.id, commentable_type: 'Forum', user_id: nil
    )

    login_into_institution institution: institution, as: 'teacher'

    visit institution_forum_path(institution, forum)

    assert_difference ['forum.comments.count', 'ActionMailer::Base.deliveries.size'] do
      assert page.has_no_css?('blockquote[id]')

      within '#new_comment' do
        fill_in 'comment_comment', with: comment.comment

        find('.btn').click
      end

      assert page.has_css?('blockquote[id]')
    end
  end

  test 'should create a comment in institution as student' do
    institution = Fabricate(:institution)
    forum = Fabricate(:forum, owner_id: institution.id, owner_type: 'Institution')
    comment = Fabricate.build(
      :comment, commentable_id: forum.id, commentable_type: 'Forum', user_id: nil
    )

    login_into_institution institution: institution, as: 'student'

    visit institution_forum_path(institution, forum)

    # No send email if is a student
    assert_no_difference 'ActionMailer::Base.deliveries.size' do
      assert_difference 'forum.comments.count' do
        assert page.has_no_css?('blockquote[id]')

        within '#new_comment' do
          fill_in 'comment_comment', with: comment.comment

          find('.btn').click
        end

        assert page.has_css?('blockquote[id]')
      end
    end
  end

  test 'should create a comment in teach' do
    teach = Fabricate(:teach)
    institution = teach.institution
    forum = Fabricate(:forum, owner_id: teach.id, owner_type: 'Teach')
    comment = Fabricate.build(
      :comment, commentable_id: forum.id, commentable_type: 'Forum', user_id: nil
    )
    user = Fabricate(:user, password: '123456', roles: [:normal])

    login_into_institution user: user, institution: institution

    teach.tap  do |t|
      Fabricate :enrollment, teach_id: t.id, enrollable_id: user.id, job: 'student'
    end

    visit teach_forum_path(teach, forum)

    assert_no_difference 'ActionMailer::Base.deliveries.size' do
      assert_difference 'forum.comments.count' do
        assert page.has_no_css?('blockquote[id]')

        within '#new_comment' do
          fill_in 'comment_comment', with: comment.comment

          find('.btn').click
        end

        assert page.has_css?('blockquote[id]')
      end
    end
  end
end
