require 'test_helper'

class RosterPlayersControllerTest < ActionController::TestCase
  setup do
    @roster_player = roster_players(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:roster_players)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create roster_player" do
    assert_difference('RosterPlayer.count') do
      post :create, roster_player: {  }
    end

    assert_redirected_to roster_player_path(assigns(:roster_player))
  end

  test "should show roster_player" do
    get :show, id: @roster_player
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @roster_player
    assert_response :success
  end

  test "should update roster_player" do
    patch :update, id: @roster_player, roster_player: {  }
    assert_redirected_to roster_player_path(assigns(:roster_player))
  end

  test "should destroy roster_player" do
    assert_difference('RosterPlayer.count', -1) do
      delete :destroy, id: @roster_player
    end

    assert_redirected_to roster_players_path
  end
end
