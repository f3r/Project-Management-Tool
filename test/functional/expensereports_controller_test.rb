require 'test_helper'

class ExpensereportsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:expensereports)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create expensereport" do
    assert_difference('Expensereport.count') do
      post :create, :expensereport => { }
    end

    assert_redirected_to expensereport_path(assigns(:expensereport))
  end

  test "should show expensereport" do
    get :show, :id => expensereports(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => expensereports(:one).to_param
    assert_response :success
  end

  test "should update expensereport" do
    put :update, :id => expensereports(:one).to_param, :expensereport => { }
    assert_redirected_to expensereport_path(assigns(:expensereport))
  end

  test "should destroy expensereport" do
    assert_difference('Expensereport.count', -1) do
      delete :destroy, :id => expensereports(:one).to_param
    end

    assert_redirected_to expensereports_path
  end
end
