require 'test_helper'

class DocumentTest < ActiveSupport::TestCase
  setup do
    @document = Fabricate(:document)
    @owner = @document.owner
  end

  test 'create' do
    counts = ['Document.count', "PaperTrail::Version.where(item_type: 'Document').count"]

    assert_difference counts do
      @document = @owner.documents.create(
        Fabricate.attributes_for(:document)
      )
    end
  end

  test 'update' do
    assert_difference 'PaperTrail::Version.count' do
      assert_no_difference 'Document.count' do
        assert @document.update(name: 'Updated')
      end
    end

    assert_equal 'Updated', @document.reload.name
  end

  test 'destroy' do
    assert_difference 'PaperTrail::Version.count' do
      assert_difference('Document.count', -1) { @document.destroy }
    end
  end

  test 'validates blank attributes' do
    @document.name = ''
    @document.remove_file!

    assert @document.invalid?
    assert_equal 2, @document.errors.size
    assert_equal [error_message_from_model(@document, :name, :blank)],
      @document.errors[:name]
    assert_equal [error_message_from_model(@document, :file, :blank)],
      @document.errors[:file]
  end

  test 'validates length of _long_ attributes' do
    @document.name = 'abcde' * 52

    assert @document.invalid?
    assert_equal 1, @document.errors.count
    assert_equal [
      error_message_from_model(@document, :name, :too_long, count: 255)
    ], @document.errors[:name]
  end
end
