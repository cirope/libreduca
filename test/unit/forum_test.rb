require 'test_helper'

class ForumTest < ActiveSupport::TestCase
  def setup
    @forum = Fabricate(:forum)
    @owner = @forum.owner
  end
  
  test 'create' do
    assert_difference 'Forum.count' do
      @forum = @owner.forums.build(
        Fabricate.attributes_for(:forum).slice(*Forum.accessible_attributes)
      )
      @forum.user = Fabricate(:user)

      assert @forum.save
    end
  end
  
  test 'update' do
    user = Fabricate(:user)

    assert_difference 'Version.count' do
      assert_no_difference 'Forum.count' do
        assert @forum.update_attributes(
          { name: 'Updated', user_id: user.id }, without_protection: true
        )
      end
    end
    
    assert_equal 'Updated', @forum.reload.name
    # Readonly attribute...
    assert_not_equal user.id, @forum.reload.user_id
  end
  
  test 'destroy' do
    assert_difference 'Version.count' do
      assert_difference('Forum.count', -1) { @forum.destroy }
    end
  end
  
  test 'validates blank attributes' do
    @forum.name = ''
    @forum.topic = ''
    @forum.user_id = nil
    @forum.owner_id = nil
    
    assert @forum.invalid?
    assert_equal 4, @forum.errors.size
    assert_equal [error_message_from_model(@forum, :name, :blank)],
      @forum.errors[:name]
    assert_equal [error_message_from_model(@forum, :topic, :blank)],
      @forum.errors[:topic]
    assert_equal [error_message_from_model(@forum, :user_id, :blank)],
      @forum.errors[:user_id]
    assert_equal [error_message_from_model(@forum, :owner_id, :blank)],
      @forum.errors[:owner_id]
  end
 
  test 'validates length of _long_ attributes' do
    @forum.name = 'abcde' * 52
    
    assert @forum.invalid?
    assert_equal 1, @forum.errors.count
    assert_equal [
      error_message_from_model(@forum, :name, :too_long, count: 255)
    ], @forum.errors[:name]
  end

  test 'magick search' do
    5.times do
      Fabricate(:forum) { name { "magick_name #{sequence(:forum_name)}" } }
    end
    
    forums = Forum.magick_search('magick')
    
    assert_equal 5, forums.count
    assert forums.all? { |s| s.to_s =~ /magick/ }
    
    forums = Forum.magick_search('noplace')
    
    assert forums.empty?
  end
end
