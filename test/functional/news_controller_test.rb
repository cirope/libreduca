require 'test_helper'

class NewsControllerTest < ActionController::TestCase

  setup do
    institution = Fabricate(:institution)
    @news = Fabricate(:news, institution_id: institution.id)
    @user = Fabricate(:user, password: '123456', roles: [:normal])
    @job = Fabricate(
      :job, user_id: @user.id, institution_id: institution.id, job: 'janitor'
    )
    @request.host = "#{institution.identification}.lvh.me"

    sign_in @user
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:news)
    assert_select '#unexpected_error', false
    assert_template "news/index"
  end

  test "should get new" do
    get :new
    assert_response :success
    assert_not_nil assigns(:news)
    assert_select '#unexpected_error', false
    assert_template "news/new"
  end

  test "should create news" do
    assert_difference('News.count') do
      post :create, news: Fabricate.attributes_for(:news)
    end

    assert_redirected_to news_url(assigns(:news))
  end

  test "should show news" do
    get :show, id: @news
    assert_response :success
    assert_not_nil assigns(:news)
    assert_select '#unexpected_error', false
    assert_template "news/show"
  end

  test "should get edit" do
    get :edit, id: @news
    assert_response :success
    assert_not_nil assigns(:news)
    assert_select '#unexpected_error', false
    assert_template "news/edit"
  end

  test "should update news" do
    put :update, id: @news, 
      news: Fabricate.attributes_for(:news, title: 'new value')

    assert_redirected_to news_url(assigns(:news))
  end

  test "should destroy news" do
    assert_difference('News.count', -1) do
      delete :destroy, id: @news
    end

    assert_redirected_to news_index_path
  end
end
