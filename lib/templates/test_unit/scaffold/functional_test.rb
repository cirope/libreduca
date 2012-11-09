require 'test_helper'

<% module_namespacing do -%>
class <%= controller_class_name %>ControllerTest < ActionController::TestCase

  setup do
    @<%= singular_table_name %> = Fabricate(:<%= singular_table_name %>)
    @user = Fabricate(:user)
    sign_in @user
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:<%= table_name %>)
    assert_select '#unexpected_error', false
    assert_template "<%= table_name %>/index"
  end

  test "should get new" do
    get :new
    assert_response :success
    assert_not_nil assigns(:<%= singular_table_name %>)
    assert_select '#unexpected_error', false
    assert_template "<%= table_name %>/new"
  end

  test "should create <%= singular_table_name %>" do
    assert_difference('<%= class_name %>.count') do
      post :create, <%= singular_table_name %>: Fabricate.attributes_for(:<%= singular_table_name %>)
    end

    assert_redirected_to <%= singular_table_name %>_url(assigns(:<%= singular_table_name %>))
  end

  test "should show <%= singular_table_name %>" do
    get :show, id: <%= "@#{singular_table_name}" %>
    assert_response :success
    assert_not_nil assigns(:<%= singular_table_name %>)
    assert_select '#unexpected_error', false
    assert_template "<%= table_name %>/show"
  end

  test "should get edit" do
    get :edit, id: <%= "@#{singular_table_name}" %>
    assert_response :success
    assert_not_nil assigns(:<%= singular_table_name %>)
    assert_select '#unexpected_error', false
    assert_template "<%= table_name %>/edit"
  end

  test "should update <%= singular_table_name %>" do
    put :update, id: @<%= singular_table_name %>, 
      <%= "#{singular_table_name}: Fabricate.attributes_for(:#{singular_table_name}, attr: 'value')" %>
    assert_redirected_to <%= singular_table_name %>_url(assigns(:<%= singular_table_name %>))
  end

  test "should destroy <%= singular_table_name %>" do
    assert_difference('<%= class_name %>.count', -1) do
      delete :destroy, id: <%= "@#{singular_table_name}" %>
    end

    assert_redirected_to <%= index_helper %>_path
  end
end
<% end -%>
