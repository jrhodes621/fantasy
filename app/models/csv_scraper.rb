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

      or_multiplier = 1
      case opponent_rank
      when 25..35
        or_multiplier = 1.1
      when 20..25
        or_multiplier = 1.05
      when 10..20
        or_multipler = 1
      when 0..10
        or_multiplier =0.8
      end
      projected = or_multiplier*ppg

      if(ppg >4.0)
        projected += ppg*0.2
      end
      if(home)
        projected += ppg*0.2
      end
      #last 10 could go here
      #if skater playing backup

      top10= nil
      actual = nil

      {
        :id => id,
        :name => name,
        :position => position,
        :salary => salary,
        :team => team,
        :ppg => ppg,
        :opponent_rank => opponent_rank,
        :projected => projected,
        :top10 => top10,
        :home => home,
        :goalie => goalie,
        :center => center,
        :defence => defense,
        :wing => wing,
        :homeXgoalie => homeXgoalie,
        :homeXcenter => homeXcenter,
        :homeXdefense => homeXdefense,
        :homeXwing => homeXwing,
        :ppgXgoalie => ppgXgoalie,
        :ppgXcenter => ppgXcenter,
        :ppgXdefense => ppgXdefense,
        :ppgXwing => ppgXwing,
        :homeXppg => homeXppg,
        :homeXor => homeXor,
        :ppgXof => ppgXor
      }
    end

    fantasy_csv_import = FantasyCsvImport.create!({
      :file_name => output_file_name,
      :fantasy_site => "DraftKings",
      :players_array => parray
    })

    #queue a job for rake task
  end

end
