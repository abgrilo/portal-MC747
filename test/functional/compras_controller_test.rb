require 'test_helper'

class ComprasControllerTest < ActionController::TestCase
  setup do
    @compra = compras(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:compras)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create compra" do
    assert_difference('Compra.count') do
      post :create, :compra => @compra.attributes
    end

    assert_redirected_to compra_path(assigns(:compra))
  end

  test "should show compra" do
    get :show, :id => @compra.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @compra.to_param
    assert_response :success
  end

  test "should update compra" do
    put :update, :id => @compra.to_param, :compra => @compra.attributes
    assert_redirected_to compra_path(assigns(:compra))
  end

  test "should destroy compra" do
    assert_difference('Compra.count', -1) do
      delete :destroy, :id => @compra.to_param
    end

    assert_redirected_to compras_path
  end
end
