class FantasyCsvImportsController < ApplicationController
  before_action :set_fantasy_csv_import, only: [:show, :edit, :update, :destroy]

  # GET /fantasy_csv_imports
  # GET /fantasy_csv_imports.json
  def index
    @fantasy_csv_imports = FantasyCsvImport.order_by(:_id => 'desc')
  end

  # GET /fantasy_csv_imports/1
  # GET /fantasy_csv_imports/1.json
  def show
  end

  # GET /fantasy_csv_imports/new
  def new
    @fantasy_csv_import = FantasyCsvImport.new
  end

  # GET /fantasy_csv_imports/1/edit
  def edit
  end

  # POST /fantasy_csv_imports
  # POST /fantasy_csv_imports.json
  def create
    @fantasy_csv_import = FantasyCsvImport.new(fantasy_csv_import_params)

    respond_to do |format|
      if @fantasy_csv_import.save
        format.html { redirect_to @fantasy_csv_import, notice: 'Fantasy csv import was successfully created.' }
        format.json { render :show, status: :created, location: @fantasy_csv_import }
      else
        format.html { render :new }
        format.json { render json: @fantasy_csv_import.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /fantasy_csv_imports/1
  # PATCH/PUT /fantasy_csv_imports/1.json
  def update
    respond_to do |format|
      if @fantasy_csv_import.update(fantasy_csv_import_params)
        format.html { redirect_to @fantasy_csv_import, notice: 'Fantasy csv import was successfully updated.' }
        format.json { render :show, status: :ok, location: @fantasy_csv_import }
      else
        format.html { render :edit }
        format.json { render json: @fantasy_csv_import.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fantasy_csv_imports/1
  # DELETE /fantasy_csv_imports/1.json
  def destroy
    @fantasy_csv_import.destroy
    respond_to do |format|
      format.html { redirect_to fantasy_csv_imports_url, notice: 'Fantasy csv import was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_fantasy_csv_import
      @fantasy_csv_import = FantasyCsvImport.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def fantasy_csv_import_params
      params[:fantasy_csv_import]
    end
end
