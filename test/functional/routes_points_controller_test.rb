require 'test_helper'

class RoutesPointsControllerTest < ActionController::TestCase
  setup do
    @routes_point = routes_points(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:routes_points)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create routes_point" do
    assert_difference('RoutesPoint.count') do
      post :create, routes_point: { elevation: @routes_point.elevation, latitude: @routes_point.latitude, longitude: @routes_point.longitude }
    end

    assert_redirected_to routes_point_path(assigns(:routes_point))
  end

  test "should show routes_point" do
    get :show, id: @routes_point
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @routes_point
    assert_response :success
  end

  test "should update routes_point" do
    put :update, id: @routes_point, routes_point: { elevation: @routes_point.elevation, latitude: @routes_point.latitude, longitude: @routes_point.longitude }
    assert_redirected_to routes_point_path(assigns(:routes_point))
  end

  test "should destroy routes_point" do
    assert_difference('RoutesPoint.count', -1) do
      delete :destroy, id: @routes_point
    end

    assert_redirected_to routes_points_path
  end
end
