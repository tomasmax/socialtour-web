require 'test_helper'

class RoutesInfosControllerTest < ActionController::TestCase
  setup do
    @routes_info = routes_infos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:routes_infos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create routes_info" do
    assert_difference('RoutesInfo.count') do
      post :create, routes_info: { accumulated_down_slope: @routes_info.accumulated_down_slope, accumulated_up_slope: @routes_info.accumulated_up_slope, difficulty: @routes_info.difficulty, e_bound: @routes_info.e_bound, is_circular: @routes_info.is_circular, lenght: @routes_info.lenght, max_down_slope: @routes_info.max_down_slope, max_elevation: @routes_info.max_elevation, min_elevation: @routes_info.min_elevation, n_bound: @routes_info.n_bound, poi: @routes_info.poi, s_bound: @routes_info.s_bound, w_bound: @routes_info.w_bound }
    end

    assert_redirected_to routes_info_path(assigns(:routes_info))
  end

  test "should show routes_info" do
    get :show, id: @routes_info
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @routes_info
    assert_response :success
  end

  test "should update routes_info" do
    put :update, id: @routes_info, routes_info: { accumulated_down_slope: @routes_info.accumulated_down_slope, accumulated_up_slope: @routes_info.accumulated_up_slope, difficulty: @routes_info.difficulty, e_bound: @routes_info.e_bound, is_circular: @routes_info.is_circular, lenght: @routes_info.lenght, max_down_slope: @routes_info.max_down_slope, max_elevation: @routes_info.max_elevation, min_elevation: @routes_info.min_elevation, n_bound: @routes_info.n_bound, poi: @routes_info.poi, s_bound: @routes_info.s_bound, w_bound: @routes_info.w_bound }
    assert_redirected_to routes_info_path(assigns(:routes_info))
  end

  test "should destroy routes_info" do
    assert_difference('RoutesInfo.count', -1) do
      delete :destroy, id: @routes_info
    end

    assert_redirected_to routes_infos_path
  end
end
