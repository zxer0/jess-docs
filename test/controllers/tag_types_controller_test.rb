require 'test_helper'

class TagTypesControllerTest < ActionController::TestCase
  setup do
    @tag_type = tag_types(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tag_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tag_type" do
    assert_difference('TagType.count') do
      post :create, tag_type: {  }
    end

    assert_redirected_to tag_type_path(assigns(:tag_type))
  end

  test "should show tag_type" do
    get :show, id: @tag_type
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @tag_type
    assert_response :success
  end

  test "should update tag_type" do
    patch :update, id: @tag_type, tag_type: {  }
    assert_redirected_to tag_type_path(assigns(:tag_type))
  end

  test "should destroy tag_type" do
    assert_difference('TagType.count', -1) do
      delete :destroy, id: @tag_type
    end

    assert_redirected_to tag_types_path
  end
end
