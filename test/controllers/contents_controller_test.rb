require 'test_helper'

class ContentsControllerTest < ActionController::TestCase
  setup do
    @content = Fabricate(:content)
    @teach = @content.teach

    sign_in Fabricate(:user)
  end

  test 'should get index' do
    get :index, teach_id: @teach.to_param
    assert_response :success
    assert_not_nil assigns(:contents)
    assert_template 'contents/index'
  end

  test 'should get filtered index' do
    3.times do
      Fabricate(:content, teach_id: @teach.id) do
        title { "in_filtered_index #{sequence(:content_name)}" }
      end
    end

    get :index, teach_id: @teach.to_param, q: 'filtered_index'
    assert_response :success
    assert_not_nil assigns(:contents)
    assert_equal 3, assigns(:contents).size
    assert assigns(:contents).all? { |c| c.to_s =~ /filtered_index/ }
    assert_not_equal assigns(:contents).size, @teach.contents.count
    assert_template 'contents/index'
  end

  test 'should get new' do
    get :new, teach_id: @teach.to_param
    assert_response :success
    assert_not_nil assigns(:content)
    assert_template 'contents/new'
  end

  test 'should create content' do
    assert_difference('Content.count') do
      assert_difference ['Document.count', 'Homework.count'], 2 do
        post :create, teach_id: @teach.to_param,
          content: Fabricate.attributes_for(:content).merge(
            documents_attributes: 2.times.map {
              Fabricate.attributes_for(:document, owner_id: nil, owner_type: nil)
            }
          ).merge(
            homeworks_attributes: 2.times.map {
              Fabricate.attributes_for(:homework, content_id: nil)
            }
          )
      end
    end

    assert_redirected_to teach_content_url(@teach, assigns(:content))
  end

  test 'should show content' do
    get :show, teach_id: @teach.to_param, id: @content
    assert_response :success
    assert_not_nil assigns(:content)
    assert_template 'contents/show'
  end

  test 'should get edit' do
    get :edit, teach_id: @teach.to_param, id: @content
    assert_response :success
    assert_not_nil assigns(:content)
    assert_template 'contents/edit'
  end

  test 'should update content' do
    assert_no_difference 'Content.count' do
      patch :update, teach_id: @teach.to_param, id: @content,
        content: Fabricate.attributes_for(:content, title: 'Upd')
    end

    assert_redirected_to teach_content_url(@teach, assigns(:content))
    assert_equal 'Upd', @content.reload.title
  end

  test 'should destroy content' do
    assert_difference('Content.count', -1) do
      delete :destroy, teach_id: @teach.to_param, id: @content
    end

    assert_redirected_to teach_contents_url(@teach)
  end
end
