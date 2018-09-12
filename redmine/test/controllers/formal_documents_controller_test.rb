require 'test_helper'

class FormalDocumentsControllerTest < ActionController::TestCase
  setup do
    @formal_document = formal_documents(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:formal_documents)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create formal_document" do
    assert_difference('FormalDocument.count') do
      post :create, formal_document: { author_id: @formal_document.author_id, content_html: @formal_document.content_html, created_user: @formal_document.created_user, deleted_user: @formal_document.deleted_user, filename: @formal_document.filename, is_deleted: @formal_document.is_deleted, is_signatured: @formal_document.is_signatured, issue_id: @formal_document.issue_id, journal_id: @formal_document.journal_id }
    end

    assert_redirected_to formal_document_path(assigns(:formal_document))
  end

  test "should show formal_document" do
    get :show, id: @formal_document
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @formal_document
    assert_response :success
  end

  test "should update formal_document" do
    patch :update, id: @formal_document, formal_document: { author_id: @formal_document.author_id, content_html: @formal_document.content_html, created_user: @formal_document.created_user, deleted_user: @formal_document.deleted_user, filename: @formal_document.filename, is_deleted: @formal_document.is_deleted, is_signatured: @formal_document.is_signatured, issue_id: @formal_document.issue_id, journal_id: @formal_document.journal_id }
    assert_redirected_to formal_document_path(assigns(:formal_document))
  end

  test "should destroy formal_document" do
    assert_difference('FormalDocument.count', -1) do
      delete :destroy, id: @formal_document
    end

    assert_redirected_to formal_documents_path
  end
end
