require 'test_helper'

class FantasyCsvImportsControllerTest < ActionController::TestCase
  setup do
    @fantasy_csv_import = fantasy_csv_imports(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:fantasy_csv_imports)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create fantasy_csv_import" do
    assert_difference('FantasyCsvImport.count') do
      post :create, fantasy_csv_import: {  }
    end

    assert_redirected_to fantasy_csv_import_path(assigns(:fantasy_csv_import))
  end

  test "should show fantasy_csv_import" do
    get :show, id: @fantasy_csv_import
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @fantasy_csv_import
    assert_response :success
  end

  test "should update fantasy_csv_import" do
    patch :update, id: @fantasy_csv_import, fantasy_csv_import: {  }
    assert_redirected_to fantasy_csv_import_path(assigns(:fantasy_csv_import))
  end

  test "should destroy fantasy_csv_import" do
    assert_difference('FantasyCsvImport.count', -1) do
      delete :destroy, id: @fantasy_csv_import
    end

    assert_redirected_to fantasy_csv_imports_path
  end
end
