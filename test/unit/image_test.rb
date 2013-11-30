require 'test_helper'

class ImageTest < ActiveSupport::TestCase
  setup do
    @image = Fabricate(:image)
  end

  test 'create' do
    assert_difference 'Image.count' do
      @image = Image.create do |image|
        Fabricate.attributes_for(:image).each do |attr, value|
          image.send "#{attr}=", value
        end
      end
    end

    assert_equal 'image/gif', @image.content_type
    assert @image.file_size > 0
  end

  test 'update' do
    assert_difference 'PaperTrail::Version.count' do
      assert_no_difference 'Image.count' do
        assert @image.update_attributes(name: 'Updated')
      end
    end

    assert_equal 'Updated', @image.reload.name
  end

  test 'destroy' do
    assert_difference 'PaperTrail::Version.count' do
      assert_difference('Image.count', -1) { @image.destroy }
    end
  end

  test 'validates blank attributes' do
    @image.name = ''
    @image.remove_file!
    @image.institution = nil

    assert @image.invalid?
    assert_equal 3, @image.errors.size
    assert_equal [error_message_from_model(@image, :name, :blank)],
      @image.errors[:name]
    assert_equal [error_message_from_model(@image, :file, :blank)],
      @image.errors[:file]
    assert_equal [error_message_from_model(@image, :institution, :blank)],
      @image.errors[:institution]
  end

  test 'validates length of attributes' do
    @image.name = 'abcde' * 52

    assert @image.invalid?
    assert_equal 1, @image.errors.count
    assert_equal [
      error_message_from_model(@image, :name, :too_long, count: 255)
    ], @image.errors[:name]
  end

  test 'markdown string' do
    assert_match /\A!\[.+\]\(.+\)\z/, @image.to_md
    assert_not_equal @image.to_md, @image.to_md(:thumb)
  end

  test 'html tag' do
    assert_match /\A<img/, @image.to_html
    assert_not_equal @image.to_html, @image.to_html(:thumb)
  end

  test 'dimensions' do
    assert_equal [1, 1], @image.dimensions
  end
end
