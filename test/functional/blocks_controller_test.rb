require 'test_helper'

class BlocksControllerTest < ActionController::TestCase
  setup do
    institution = Fabricate(:institution)
    @user = Fabricate(:user, password: '123456', roles: [:janitor])
    job = Fabricate(
      :job, user_id: @user.id, institution_id: institution.id, job: 'janitor'
    )

    @page_block = Fabricate(:page, institution_id: institution.id)
    @block = Fabricate(:block, content: Faker::Lorem.sentence,
      blockable_id: @page_block.id, blockable_type: @page_block.class.name)

    @blockable = @page_block.blocks

    @request.host = "#{institution.identification}.lvh.me"

    sign_in @user
  end

  test 'should get new' do
    xhr :get, :new, page_id: @page_block.to_param
    assert_response :success
    assert_not_nil assigns(:block)
    assert_select '#unexpected_error', false
    assert_template 'blocks/new'
  end

  test 'should create a block' do
    assert_difference "@blockable.count" do
      xhr :post, :create, page_id: @page_block.to_param,
        block: Fabricate.attributes_for(:block).slice(
          *Block.accessible_attributes
        )
    end

    assert_response :success
    assert_template 'blocks/create'
  end

  test 'should not create a block' do
    assert_no_difference('@blockable.count') do
      xhr :post, :create, page_id: @page_block.to_param,
        block: Fabricate.attributes_for(:block).slice(
          *Block.accessible_attributes
        ).merge(content: '')
    end

    assert_response :success
    assert_template 'blocks/new'
  end

  test 'should get edit' do
    xhr :get, :edit, page_id: @page_block.to_param, id: @block.id
    assert_response :success
    assert_not_nil assigns(:block)
    assert_select '#unexpected_error', false
    assert_template 'blocks/edit'
  end

  test 'should update a block' do
    assert_no_difference '@blockable.count' do
      xhr :put, :update, page_id: @page_block.to_param, id: @block.id,
        block: Fabricate.attributes_for(:block, content: 'Upd').slice(
          *Block.accessible_attributes
        )
    end

    assert_equal 'Upd', @block.reload.content
    assert_template 'blocks/update'
  end

  test 'should destroy a block' do
    assert_difference('@blockable.count', -1) do
      xhr :delete, :destroy, page_id: @page_block.to_param, id: @block.id
    end
  end

  test 'should sort blocks' do
    blocks = [@block]
    2.times do
      blocks << Fabricate(
        :block,
        blockable_id: @block.blockable_id,
        blockable_type: @block.blockable_type
      )
    end

    assert blocks.all? { |b| b.position == 0 }

    post :sort, page_id: @page_block.to_param, block: blocks.map(&:id)

    assert_response :success
    assert_equal([1, 2, 3], blocks.map { |b| b.reload.position })
  end
end
