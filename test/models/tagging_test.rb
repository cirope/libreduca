require 'test_helper'

class TaggingTest < ActiveSupport::TestCase
  def setup
    @tagging = Fabricate(:tagging)
  end

  test 'create' do
    assert_difference 'Tagging.count' do
      @tagging = Tagging.create do |tagging|
        Fabricate.attributes_for(:tagging).each do |attr,value|
          tagging.send "#{attr}=", value
        end
      end
    end
  end

  test 'update' do
    tag = Fabricate(:tag)

    assert_difference 'PaperTrail::Version.count' do
      assert_no_difference 'Tagging.count' do
        assert @tagging.update(tag_id: tag.id)
      end
    end

    assert_equal tag.id, @tagging.reload.tag_id
  end

  test 'destroy' do
    assert_difference 'PaperTrail::Version.count' do
      assert_difference('Tagging.count', -1) { @tagging.destroy }
    end
  end

  test 'validates unique attributes' do
    new_tagging = Fabricate(:tagging, taggable_id: @tagging.taggable_id,
      taggable_type: @tagging.taggable_type)
    @tagging.tag_id = new_tagging.tag_id

    assert @tagging.invalid?
    assert_equal 1, @tagging.errors.size
    assert_equal [error_message_from_model(@tagging, :tag_id, :taken)],
      @tagging.errors[:tag_id]
  end
end
