require 'test_helper'

class ProfilesControllerTest < ActionController::TestCase
  setup do
    @profile = profiles(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:profiles)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create profile" do
    assert_difference('Profile.count') do
      post :create, profile: { about_me: @profile.about_me, first_name: @profile.first_name, gender: @profile.gender, i_dont_like: @profile.i_dont_like, i_like: @profile.i_like, last_name: @profile.last_name, married: @profile.married, restrictions: @profile.restrictions, soons: @profile.soons, username: @profile.username }
    end

    assert_redirected_to profile_path(assigns(:profile))
  end

  test "should show profile" do
    get :show, id: @profile
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @profile
    assert_response :success
  end

  test "should update profile" do
    put :update, id: @profile, profile: { about_me: @profile.about_me, first_name: @profile.first_name, gender: @profile.gender, i_dont_like: @profile.i_dont_like, i_like: @profile.i_like, last_name: @profile.last_name, married: @profile.married, restrictions: @profile.restrictions, soons: @profile.soons, username: @profile.username }
    assert_redirected_to profile_path(assigns(:profile))
  end

  test "should destroy profile" do
    assert_difference('Profile.count', -1) do
      delete :destroy, id: @profile
    end

    assert_redirected_to profiles_path
  end
end
