require 'test_helper'

class PoisControllerTest < ActionController::TestCase
  setup do
    @poi = pois(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:pois)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create poi" do
    assert_difference('Poi.count') do
      post :create, poi: { address: @poi.address, description: @poi.description, description_eu: @poi.description_eu, latitude: @poi.latitude, longitude: @poi.longitude, minube_id: @poi.minube_id, minube_url: @poi.minube_url, name: @poi.name, name_eu: @poi.name_eu, picture_nomral: @poi.picture_nomral, picture_thumbnail: @poi.picture_thumbnail, rating: @poi.rating, ratings_count: @poi.ratings_count, slug: @poi.slug, telephone: @poi.telephone, timetable: @poi.timetable, website: @poi.website }
    end

    assert_redirected_to poi_path(assigns(:poi))
  end

  test "should show poi" do
    get :show, id: @poi
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @poi
    assert_response :success
  end

  test "should update poi" do
    put :update, id: @poi, poi: { address: @poi.address, description: @poi.description, description_eu: @poi.description_eu, latitude: @poi.latitude, longitude: @poi.longitude, minube_id: @poi.minube_id, minube_url: @poi.minube_url, name: @poi.name, name_eu: @poi.name_eu, picture_nomral: @poi.picture_nomral, picture_thumbnail: @poi.picture_thumbnail, rating: @poi.rating, ratings_count: @poi.ratings_count, slug: @poi.slug, telephone: @poi.telephone, timetable: @poi.timetable, website: @poi.website }
    assert_redirected_to poi_path(assigns(:poi))
  end

  test "should destroy poi" do
    assert_difference('Poi.count', -1) do
      delete :destroy, id: @poi
    end

    assert_redirected_to pois_path
  end
end
