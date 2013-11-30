require 'test_helper'

class TagTest < ActiveSupport::TestCase
  def setup
    @tag = Fabricate(:tag)
  end

  test 'create' do
    assert_difference 'Tag.count' do
      Tag.create do |tag|
        Fabricate.attributes_for(:tag).each do |attr, value|
          tag.send "#{attr}=", value
        end
      end
    end
  end

  test 'update' do
    assert_difference 'PaperTrail::Version.count' do
      assert_no_difference 'Tag.count' do
        assert @tag.update_attributes(name: 'Updated')
      end
    end

    assert_equal 'Updated', @tag.reload.name
  end

  test 'validates blank attributes' do
    @tag.name = ''
    @tag.category = ''
    @tag.tagger_type = nil

    assert @tag.invalid?
    assert_equal 3, @tag.errors.size
    assert_equal [error_message_from_model(@tag, :name, :blank)],
      @tag.errors[:name]
    assert_equal [error_message_from_model(@tag, :category, :blank)],
      @tag.errors[:category]
    assert_equal [error_message_from_model(@tag, :tagger_type, :blank)],
      @tag.errors[:tagger_type]
  end

  test 'validates unique attributes' do
    new_tag = Fabricate(:tag, institution_id: @tag.institution.id)
    @tag.name = new_tag.name

    assert @tag.invalid?
    assert_equal 1, @tag.errors.size
    assert_equal [error_message_from_model(@tag, :name, :taken)],
      @tag.errors[:name]
  end

  test 'validates included attributes' do
    @tag.category = 'no_category'

    assert @tag.invalid?
    assert_equal 1, @tag.errors.size
    assert_equal [error_message_from_model(@tag, :category, :inclusion)],
      @tag.errors[:category]
  end

  test 'validates length of _long_ attributes' do
    @tag.name = 'abcde' * 52

    assert @tag.invalid?
    assert_equal 1, @tag.errors.count
    assert_equal [
      error_message_from_model(@tag, :name, :too_long, count: 255)
    ], @tag.errors[:name]
  end
end
