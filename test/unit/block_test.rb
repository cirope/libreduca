require 'test_helper'

class BlockTest < ActiveSupport::TestCase
  def setup
    @block = Fabricate(:block)
  end

  test 'create' do
    blockable = @block.blockable

    assert_difference 'Block.count' do
      blockable.blocks.build(
        Fabricate.attributes_for(:block, 
          blockable_id: blockable.id, blockable_type: blockable, 
          position: @block.position+1 ).slice(
            *Block.accessible_attributes
          )
      )

      assert blockable.save
    end
  end

  test 'update' do
    assert_difference 'Version.count' do
      assert_no_difference 'Block.count' do
        assert @block.update_attributes(content: 'Updated')
      end
    end

    assert_equal 'Updated', @block.reload.content
  end

  test 'destroy' do
    assert_difference 'Version.count' do
      assert_difference('Block.count', -1) { @block.destroy }
    end
  end

  test 'validates blank attributes' do
    @block.content = ''

    assert @block.invalid?
    assert_equal 1, @block.errors.size
    assert_equal [error_message_from_model(@block, :content, :blank)],
      @block.errors[:content]
  end
end
