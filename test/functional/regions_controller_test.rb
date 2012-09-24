require 'test_helper'

class RegionsControllerTest < ActionController::TestCase
  setup do
    @region = Fabricate(:region)
    
    sign_in Fabricate(:user)
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:regions)
    assert_select '#unexpected_error', false
    assert_template 'regions/index'
  end
  
  test 'should get filtered index' do
    3.times do
      Fabricate(:region) do
        name { "in_filtered_index #{sequence(:region_name)}" }
      end
    end
    
    get :index, q: 'filtered_index'
    assert_response :success
    assert_not_nil assigns(:regions)
    assert_equal 3, assigns(:regions).size
    assert assigns(:regions).all? { |r| r.to_s =~ /filtered_index/ }
    assert_not_equal assigns(:regions).size, Region.count
    assert_select '#unexpected_error', false
    assert_template 'regions/index'
  end

  test 'should get new' do
    get :new
    assert_response :success
    assert_not_nil assigns(:region)
    assert_select '#unexpected_error', false
    assert_template 'regions/new'
  end

  test 'should create region' do
    assert_difference('Region.count') do
      post :create, region: Fabricate.attributes_for(:region)
    end

    assert_redirected_to region_url(assigns(:region))
  end
  
  test 'should create region and district' do
    assert_difference ['Region.count', 'District.count'] do
      post :create, region: Fabricate.attributes_for(:region).merge(
        districts_attributes: {
          new_1: Fabricate.attributes_for(:district, region_id: nil)
        }
      )
    end

    assert_redirected_to region_url(assigns(:region))
  end

  test 'should show region' do
    get :show, id: @region
    assert_response :success
    assert_not_nil assigns(:region)
    assert_select '#unexpected_error', false
    assert_template 'regions/show'
  end

  test 'should get edit' do
    get :edit, id: @region
    assert_response :success
    assert_not_nil assigns(:region)
    assert_select '#unexpected_error', false
    assert_template 'regions/edit'
  end

  test 'should update region' do
    assert_no_difference 'Region.count' do
      put :update, id: @region,
        region: Fabricate.attributes_for(:region, name: 'Upd')
    end
    
    assert_redirected_to region_url(assigns(:region))
    assert_equal 'Upd', @region.reload.name
  end

  test 'should destroy region' do
    assert_difference('Region.count', -1) do
      delete :destroy, id: @region
    end

    assert_redirected_to regions_url
  end
end
