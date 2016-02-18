require 'test_helper'

class SpecTypesControllerTest < ActionController::TestCase
  setup do
    @spec_type = spec_types(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:spec_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create spec_type" do
    assert_difference('SpecType.count') do
      post :create, spec_type: {  }
    end

    assert_redirected_to spec_type_path(assigns(:spec_type))
  end

  test "should show spec_type" do
    get :show, id: @spec_type
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @spec_type
    assert_response :success
  end

  test "should update spec_type" do
    patch :update, id: @spec_type, spec_type: {  }
    assert_redirected_to spec_type_path(assigns(:spec_type))
  end

  test "should destroy spec_type" do
    assert_difference('SpecType.count', -1) do
      delete :destroy, id: @spec_type
    end

    assert_redirected_to spec_types_path
  end
end
