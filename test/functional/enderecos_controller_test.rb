require 'test_helper'

class EnderecosControllerTest < ActionController::TestCase
  setup do
    @endereco = enderecos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:enderecos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create endereco" do
    assert_difference('Endereco.count') do
      post :create, :endereco => @endereco.attributes
    end

    assert_redirected_to endereco_path(assigns(:endereco))
  end

  test "should show endereco" do
    get :show, :id => @endereco.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @endereco.to_param
    assert_response :success
  end

  test "should update endereco" do
    put :update, :id => @endereco.to_param, :endereco => @endereco.attributes
    assert_redirected_to endereco_path(assigns(:endereco))
  end

  test "should destroy endereco" do
    assert_difference('Endereco.count', -1) do
      delete :destroy, :id => @endereco.to_param
    end

    assert_redirected_to enderecos_path
  end
end
