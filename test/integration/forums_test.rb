# encoding: utf-8

require 'test_helper'

class ForumsTest < ActionDispatch::IntegrationTest
  test 'should create a new forum' do
    login
    
    school = Fabricate(:school)
    forum = Fabricate.build(:forum, owner_id: school.id, owner_type: 'School')
    
    visit new_school_forum_path(school)
    
    fill_in Forum.human_attribute_name('name'), with: forum.name
    fill_in Forum.human_attribute_name('topic'), with: forum.topic
    fill_in Forum.human_attribute_name('info'), with: forum.info

    assert_difference 'school.forums.count' do
      find('.btn.btn-primary').click
    end
  end
  
  test 'should create a comment' do
    login
    
    school = Fabricate(:school)
    forum = Fabricate(:forum, owner_id: school.id, owner_type: 'School')
    comment = Fabricate.build(:comment, forum_id: forum.id, user_id: nil)
    
    visit school_forum_path(school, forum)
    
    assert_difference 'forum.comments.count' do
      within '#new_comment' do
        fill_in 'comment_comment', with: comment.comment

        find('.btn').click
      end

      assert page.has_no_css?('#new_comment')
    end
  end
end
