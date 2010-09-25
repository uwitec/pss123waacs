# Scaffolding generated by Casein v.2.0.6

require 'test_helper'

class CaseinInventoriesControllerTest < ActionController::TestCase
  
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:inventories)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create inventory" do
    assert_difference('Inventory.count') do
      post :create, :inventory => { }
    end

    assert_redirected_to inventory_path(assigns(:inventory))
  end

  test "should show inventory" do
    get :show, :id => inventories(:one).id
    assert_response :success
  end

  test "should update inventory" do
    put :update, :id => inventories(:one).id, :inventory => { }
    assert_redirected_to inventory_path(assigns(:inventory))
  end

  test "should destroy inventory" do
    assert_difference('Inventory.count', -1) do
      delete :destroy, :id => inventories(:one).id
    end

    assert_redirected_to inventories_path
  end
end
