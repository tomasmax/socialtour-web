require 'test_helper'

class LikesControllerTest < ActionController::TestCase
  setup do
    @like = likes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:likes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create like" do
    assert_difference('Like.count') do
      post :create, like: { category: @like.category, created_time: @like.created_time, facebook_id: @like.facebook_id, name: @like.name }
    end

    assert_redirected_to like_path(assigns(:like))
  end

  test "should show like" do
    get :show, id: @like
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @like
    assert_response :success
  end

  test "should update like" do
    put :update, id: @like, like: { category: @like.category, created_time: @like.created_time, facebook_id: @like.facebook_id, name: @like.name }
    assert_redirected_to like_path(assigns(:like))
  end

  test "should destroy like" do
    assert_difference('Like.count', -1) do
      delete :destroy, id: @like
    end

    assert_redirected_to likes_path
  end
end
