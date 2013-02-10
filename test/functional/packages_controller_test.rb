require 'test_helper'

class PackagesControllerTest < ActionController::TestCase
  setup do
    @package = packages(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:packages)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create package" do
    assert_difference('Package.count') do
      post :create, package: { description: @package.description, image_content_type: @package.image_content_type, image_file_name: @package.image_file_name, image_file_size: @package.image_file_size, image_update_at: @package.image_update_at, name: @package.name, price: @package.price }
    end

    assert_redirected_to package_path(assigns(:package))
  end

  test "should show package" do
    get :show, id: @package
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @package
    assert_response :success
  end

  test "should update package" do
    put :update, id: @package, package: { description: @package.description, image_content_type: @package.image_content_type, image_file_name: @package.image_file_name, image_file_size: @package.image_file_size, image_update_at: @package.image_update_at, name: @package.name, price: @package.price }
    assert_redirected_to package_path(assigns(:package))
  end

  test "should destroy package" do
    assert_difference('Package.count', -1) do
      delete :destroy, id: @package
    end

    assert_redirected_to packages_path
  end
end
