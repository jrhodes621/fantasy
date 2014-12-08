require 'csv'

class CsvScraper

  attr_accessor :url

  def initialize
  end

  def output_file_name
    "db/csv/nhl/" + DateTime.now.to_s + ".csv"
  end

  def headers
    %w[projected top10 actual
name draftkings_id position salary team opponent-rank ppg home goalie center defense wing
homeXgoalie homeXcenter homeXdefense homeXwing
ppgXgoalie ppgXcenter ppgXdefense ppgXwing
homeXppg homeXor ppgXor]
  end

  def do_it
    json = RestClient.get(self.url)
    result = JSON.parse(json)
    players = result['playerList']
    parray = players.map do |x|
      name = x['fn'] + " " + x['ln']
      id = x['pid']
      position = x['pn']
      salary = x['s']
      team = x["htabbr"].upcase
      opponent_rank = x['or']
      ppg = x['ppg'].to_f
      home = x["tid"] == x['htid'] ? 1 : 0
      goalie = position ==  "G" ? 1 : 0
      center = position ==  "C" ? 1 : 0
      defense = position == "D" ? 1 : 0
      wing = ((position ==  "RW") or (position == "LW")) ? 1 : 0

      homeXgoalie =home * goalie
      homeXcenter =home * center
      homeXdefense = home *defense
      homeXwing = home * wing

      ppgXgoalie = ppg * goalie
      ppgXcenter = ppg * center
      ppgXdefense =ppg * defense
      ppgXwing = ppg * wing

      homeXppg = home * ppg
      homeXor = home * opponent_rank
      ppgXor = ppg * opponent_rank

      projected = nil
      top10= nil
      actual = nil

      [projected, top10, actual,
       name, id, position, salary, team, opponent_rank, ppg, home, goalie, center, defense, wing,
       homeXgoalie, homeXcenter, homeXdefense, homeXwing,
       ppgXgoalie, ppgXcenter, ppgXdefense, ppgXwing,
       homeXppg, homeXor, ppgXor]
    end

    CSV.open(output_file_name, "wb") do |csv|
      csv << headers
      parray.each do |row|
        csv << row
      end
    end
    binding.pry
    FantasyCsvImport.create!({
      :file_name => output_file_name,
      :fantasy_site => "DraftKings"
    })

    #queue a job for rake task
  end

end
