require 'test_helper'

class CountriesControllerTest < ActionController::TestCase
  setup do
    @country = countries(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:countries)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create country" do
    assert_difference('Country.count') do
      post :create, country: { blog_count: @country.blog_count, full_count: @country.full_count, hotel_count: @country.hotel_count, latitude: @country.latitude, longitude: @country.longitude, minube_id: @country.minube_id, name: @country.name, pois_count: @country.pois_count, restaurant_count: @country.restaurant_count, see_count: @country.see_count }
    end

    assert_redirected_to country_path(assigns(:country))
  end

  test "should show country" do
    get :show, id: @country
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @country
    assert_response :success
  end

  test "should update country" do
    put :update, id: @country, country: { blog_count: @country.blog_count, full_count: @country.full_count, hotel_count: @country.hotel_count, latitude: @country.latitude, longitude: @country.longitude, minube_id: @country.minube_id, name: @country.name, pois_count: @country.pois_count, restaurant_count: @country.restaurant_count, see_count: @country.see_count }
    assert_redirected_to country_path(assigns(:country))
  end

  test "should destroy country" do
    assert_difference('Country.count', -1) do
      delete :destroy, id: @country
    end

    assert_redirected_to countries_path
  end
end
