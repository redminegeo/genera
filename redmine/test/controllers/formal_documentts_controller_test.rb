require 'test_helper'

class FormalDocumenttsControllerTest < ActionController::TestCase
  setup do
    @formal_documentt = formal_documentts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:formal_documentts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create formal_documentt" do
    assert_difference('FormalDocumentt.count') do
      post :create, formal_documentt: { author_id: @formal_documentt.author_id, container_id: @formal_documentt.container_id, container_type: @formal_documentt.container_type, created_user: @formal_documentt.created_user, disk_directory: @formal_documentt.disk_directory, filename: @formal_documentt.filename, filesize: @formal_documentt.filesize, is_signatured: @formal_documentt.is_signatured }
    end

    assert_redirected_to formal_documentt_path(assigns(:formal_documentt))
  end

  test "should show formal_documentt" do
    get :show, id: @formal_documentt
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @formal_documentt
    assert_response :success
  end

  test "should update formal_documentt" do
    patch :update, id: @formal_documentt, formal_documentt: { author_id: @formal_documentt.author_id, container_id: @formal_documentt.container_id, container_type: @formal_documentt.container_type, created_user: @formal_documentt.created_user, disk_directory: @formal_documentt.disk_directory, filename: @formal_documentt.filename, filesize: @formal_documentt.filesize, is_signatured: @formal_documentt.is_signatured }
    assert_redirected_to formal_documentt_path(assigns(:formal_documentt))
  end

  test "should destroy formal_documentt" do
    assert_difference('FormalDocumentt.count', -1) do
      delete :destroy, id: @formal_documentt
    end

    assert_redirected_to formal_documentts_path
  end
end
