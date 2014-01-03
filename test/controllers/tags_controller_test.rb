require 'test_helper'

class TagsControllerTest < ActionController::TestCase
  setup do
    @tag = Fabricate(:tag)
    @institution = Fabricate(:institution)
    @user = Fabricate(:user, password: '123456', roles: [:normal])
    @job = Fabricate(
      :job, user_id: @user.id, institution_id: @institution.id, job: 'janitor'
    )
    @request.host = "#{@institution.identification}.lvh.me"

    sign_in @user
  end

  test 'should get filtered index' do
    3.times { |name|
      Fabricate(:tag, name: "in_filtered_index_#{name}", institution_id: @institution.id)
    }

    get :index, q: 'filtered_index', type: @tag.tagger_type
    assert_response :success
    assert_not_nil assigns(:tags)
    assert_equal 3, assigns(:tags).size
    assert assigns(:tags).all? { |t| t.to_s =~ /filtered_index/ }
    assert_not_equal assigns(:tags).size, Tag.count
    assert_template 'tags/index'
  end

  test 'should get filtered index in json' do
    3.times { |name|
      Fabricate(:tag, name: "in_filtered_index_#{name}", institution_id: @institution.id)
    }

    get :index, q: 'filtered_index', type: @tag.tagger_type, format: 'json'
    assert_response :success

    tags = ActiveSupport::JSON.decode(@response.body)

    assert_equal 3, tags.size
    assert tags.all? { |t| t['label'].match /filtered_index/i }

    get :index, q: 'no_tag', type: @tag.tagger_type, format: 'json'
    assert_response :success

    tags = ActiveSupport::JSON.decode(@response.body)

    assert_equal 0, tags.size
  end
end
