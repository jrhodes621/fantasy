class CsvImporterController < ApplicationController

  def index
  end

  def create_csv
    scraper = CsvScraper.new
    scraper.url = params[:url]
    scraper.do_it
    redirect_to :back, notice: "Success!"

  end

end
