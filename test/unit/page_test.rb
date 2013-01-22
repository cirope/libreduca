require 'test_helper'

class PageTest < ActiveSupport::TestCase
  def setup
    @page = Fabricate(:page)
    @block = Fabricate(:block)
  end

  test 'create' do
    assert_difference 'Page.count' do
      @page = Page.create do |page|
        Fabricate.attributes_for(:page).each do |attr, value|
          page.send "#{attr}=", value
        end
      end
    end
  end

  test 'update' do
    assert_difference 'Version.count' do
      assert_no_difference 'Page.count' do
        assert @block.update_attributes(content: 'Updated')
      end
    end

    assert_equal 'Updated', @block.reload.content
  end

  test 'destroy' do
    assert_difference 'Version.count' do
      assert_difference('Page.count', -1) { @page.destroy }
    end
  end

  test 'validates blank attributes' do
    @block = @page.blocks.build(content: '')

    assert @block.invalid?
    assert_equal 1, @block.errors.size
    assert_equal [error_message_from_model(@block, :content, :blank)],
      @block.errors[:content]
  end

  test 'validates unique attributes' do
    new_page = Fabricate(:page)
    @page.institution_id = new_page.institution_id

    assert @page.invalid?
    assert_equal 1, @page.errors.size
    assert_equal [error_message_from_model(@page, :institution_id, :taken)],
      @page.errors[:institution_id]
  end
end
