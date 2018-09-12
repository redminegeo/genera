require 'test_helper'

class AsignedsControllerTest < ActionController::TestCase
  setup do
    @asigned = asigneds(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:asigneds)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create asigned" do
    assert_difference('Asigned.count') do
      post :create, asigned: { issue_id: @asigned.issue_id, user_id: @asigned.user_id }
    end

    assert_redirected_to asigned_path(assigns(:asigned))
  end

  test "should show asigned" do
    get :show, id: @asigned
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @asigned
    assert_response :success
  end

  test "should update asigned" do
    patch :update, id: @asigned, asigned: { issue_id: @asigned.issue_id, user_id: @asigned.user_id }
    assert_redirected_to asigned_path(assigns(:asigned))
  end

  test "should destroy asigned" do
    assert_difference('Asigned.count', -1) do
      delete :destroy, id: @asigned
    end

    assert_redirected_to asigneds_path
  end
end
