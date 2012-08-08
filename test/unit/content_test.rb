require 'test_helper'

class ContentTest < ActiveSupport::TestCase
  def setup
    @content = Fabricate(:content)
    @teach = @content.teach
  end
  
  test 'create' do
    counts = [
      'Content.count',
      "Version.where(item_type: 'Content').count",
      '@teach.contents.count'
    ]

    assert_difference counts do
      @content = @teach.contents.create(
        Fabricate.attributes_for(:content).slice(
          *Content.accessible_attributes
        )
      )
    end
  end
  
  test 'update' do
    assert_difference 'Version.count' do
      assert_no_difference 'Content.count' do
        assert @content.update_attributes(title: 'Updated')
      end
    end
    
    assert_equal 'Updated', @content.reload.title
  end
  
  test 'destroy' do
    assert_difference 'Version.count' do
      assert_difference('Content.count', -1) { @content.destroy }
    end
  end
  
  test 'validates blank attributes' do
    @content.title = ''
    @content.teach_id = nil
    
    assert @content.invalid?
    assert_equal 2, @content.errors.size
    assert_equal [error_message_from_model(@content, :title, :blank)],
      @content.errors[:title]
    assert_equal [error_message_from_model(@content, :teach_id, :blank)],
      @content.errors[:teach_id]
  end
  
  test 'validates length of _long_ attributes' do
    @content.title = 'abcde' * 52
    
    assert @content.invalid?
    assert_equal 1, @content.errors.count
    assert_equal [
      error_message_from_model(@content, :title, :too_long, count: 255)
    ], @content.errors[:title]
  end
  
  test 'magick search' do
    5.times do
      Fabricate(:content) {
        title { "magick_title #{sequence(:content_name)}" }
      }
    end
    
    contents = Content.magick_search('magick')
    
    assert_equal 5, contents.count
    assert contents.all? { |s| s.to_s =~ /magick/ }
    
    contents = Content.magick_search('noplace')
    
    assert contents.empty?
  end
end
