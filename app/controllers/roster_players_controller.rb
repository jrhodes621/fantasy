class RosterPlayersController < ApplicationController
  before_action :set_roster_player, only: [:show, :edit, :update, :destroy]

  # GET /roster_players
  # GET /roster_players.json
  def index
    @roster_players = RosterPlayer.all
  end

  # GET /roster_players/1
  # GET /roster_players/1.json
  def show
  end

  # GET /roster_players/new
  def new
    @roster_player = RosterPlayer.new
  end

  # GET /roster_players/1/edit
  def edit
  end

  # POST /roster_players
  # POST /roster_players.json
  def create
    @roster_player = RosterPlayer.new(roster_player_params)

    respond_to do |format|
      if @roster_player.save
        format.html { redirect_to @roster_player, notice: 'Roster player was successfully created.' }
        format.json { render :show, status: :created, location: @roster_player }
      else
        format.html { render :new }
        format.json { render json: @roster_player.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /roster_players/1
  # PATCH/PUT /roster_players/1.json
  def update
    respond_to do |format|
      if @roster_player.update(roster_player_params)
        format.html { redirect_to @roster_player, notice: 'Roster player was successfully updated.' }
        format.json { render :show, status: :ok, location: @roster_player }
      else
        format.html { render :edit }
        format.json { render json: @roster_player.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /roster_players/1
  # DELETE /roster_players/1.json
  def destroy
    @roster_player.destroy
    respond_to do |format|
      format.html { redirect_to roster_players_url, notice: 'Roster player was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_roster_player
      @roster_player = RosterPlayer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def roster_player_params
      params[:roster_player]
    end
end
