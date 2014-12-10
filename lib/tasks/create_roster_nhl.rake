require 'csv'
require 'digest/sha1'


desc "Create Rosters for NHL"
task :create_rosters_nhl => [:environment] do

  min_points = 0
  the_rosters = []
  the_matched_rosters = []
  the_players = Hash.new
  the_goalies = Hash.new
  the_defencemen = Hash.new
  size = 30
  depth = 50

  #build the file name dynamically
  path = Rails.root + "db/csv/nhl/"
  file = "2014-12-09T23:02:38-05:00.csv"
  id_position = 0 #12
  name_position = 2 #1
  position_position = 1 # 0
  team_position = 4 #3
  salary_position = 3 #2
  opponent_rank_position = 5
  points_position = 6 #6
  expected_points_position = 8

  starting_goalies = ["James Reimer","Jimmy Howard","Ben Scrivens","Frederik Andersen"]
  players = []
  injured_players = ["Justin Abdelkader","Leo Komarov","Boyd Gordon","Sheldon Souray"]

  fantasy_csv_import = FantasyCsvImport.last

  fantasy_csv_import.players_array.each do |player|
    fantasy_player = FantasyPlayer.where(:id => player[:id]).first

    if(!fantasy_player)
      Player.create!({
        :name => player[:name],
        :position => player[:position]
      }).tap do |p|
        p.fantasy_player.create!({
            :fantasy_site => "Draft Kings",
            :external_id => player[:id]
        })
      end
    end
  end

  all_centers = fantasy_csv_import.players_array.select { |player| player[:position] == "C" && player[:projected].to_f > 2 && player[:salary].to_f > 2500}.sort_by { |v| v[:projected] }
    .reject { |player| injured_players.include?(player[:name]) }
    .reverse
  all_wingers = fantasy_csv_import.players_array.select { |player| ((player[:position] == "RW" || player[:position] == "LW")) && player[:projected].to_f > 2 && player[:salary].to_f > 2500}.sort_by { |v| v[:projected] }
    .reject { |player| injured_players.include?(player[:name]) }
    .reverse
  all_defencemen = fantasy_csv_import.players_array.select { |player| player[:position] == "D" && player[:projected].to_f > 2 && player[:salary].to_f > 2500}.sort_by { |v| v[:projected] }
    .reject { |player| injured_players.include?(player[:name]) }
    .reverse
  all_goalies = fantasy_csv_import.players_array.select { |player| player[:position] == "G" && starting_goalies.include?(player[:name])  && player[:projected].to_f > 2 && player[:salary].to_f > 2500}.sort_by { |v| v[:projected] }
    .reject { |player| injured_players.include?(player[:name]) }
    .reverse
  #players_by_id = Hash[players.map{|x| [x[:id], x]}

  #hold centers

  #all wingers
  #all defencemen

  #hold wingers
  #all centers drop 10
  #all defencemen drop 10

  #hold defencemen
  #all centers drop 10
  #all defencement after 10


  puts "1"

  centers = all_centers
  wingers = all_wingers
  defencemen = all_defencemen
  goalies = all_goalies

  center_combos = centers.combination(3).to_a.reject{ |player| player.map { |x|  x[:salary].to_f}.reduce(:+)  > 18000 }
    .sort_by {|player| player.map { |x|  x[:projected].to_f }.reduce(:+) }.reverse
    .take(depth)
  winger_combos = wingers.combination(3).to_a.reject{ |player| player.map { |x|  x[:salary].to_f}.reduce(:+)  > 18000 }
    .sort_by {|player| player.map { |x|  x[:projected].to_f }.reduce(:+) }.reverse
    .take(depth)
  defencemen_combos = defencemen.combination(2).to_a
    .reject{ |player| player.map { |x|  x[:salary].to_f}.reduce(:+)  > 12500 }
    .sort_by {|player| player.map { |x|  x[:projected].to_f }.reduce(:+) }.reverse
    .take(depth)

  goalies_combos = goalies.combination(1).to_a

  selected_rosters = process_rosters center_combos, winger_combos, defencemen_combos, goalies_combos, min_points

  if selected_rosters.count > 0
    min_points = selected_rosters.last[:points].to_f
  end

  if selected_rosters.count > 0
    puts "found " + selected_rosters.count.to_s + " rosters"
    the_rosters << selected_rosters
  end

  puts "2"

  centers = all_centers
  wingers = all_wingers
  defencemen = all_defencemen
  goalies = all_goalies

  center_combos = centers.combination(2).to_a.reject{ |player| player.map { |x|  x[:salary].to_f}.reduce(:+)  > 15000 }
     .sort_by {|player| player.map { |x|  x[:projected].to_f }.reduce(:+) }.reverse
     .take(depth)
 winger_combos = wingers.combination(4).to_a.reject{ |player| player.map { |x|  x[:salary].to_f}.reduce(:+)  > 24000 }
     .sort_by {|player| player.map { |x|  x[:projected].to_f }.reduce(:+) }.reverse
     .take(depth)
 defencemen_combos = defencemen.combination(2).to_a.reject{ |player| player.map { |x|  x[:salary].to_f}.reduce(:+)  > 12500 }
     .sort_by {|player| player.map { |x|  x[:projected].to_f }.reduce(:+) }.reverse
     .take(depth)
 goalies_combos = goalies.combination(1).to_a

  selected_rosters = process_rosters center_combos, winger_combos, defencemen_combos, goalies_combos, min_points

  if selected_rosters.count > 0
    min_points = selected_rosters.last[:points].to_f
  end

  if selected_rosters.count > 0
    puts "found " + selected_rosters.count.to_s + " rosters"
    the_rosters << selected_rosters
  end

  puts "3"

  centers = all_centers
  wingers = all_wingers
  defencemen = all_defencemen
  goalies = all_goalies

  center_combos = centers.combination(2).to_a.reject{ |player| player.map { |x|  x[:salary].to_f}.reduce(:+)  > 15000 }
     .sort_by {|player| player.map { |x|  x[:projected].to_f }.reduce(:+) }.reverse
     .take(depth)
 winger_combos = wingers.combination(3).to_a.reject{ |player| player.map { |x|  x[:salary].to_f}.reduce(:+)  > 18000 }
     .sort_by {|player| player.map { |x|  x[:projected].to_f }.reduce(:+) }.reverse
     .take(depth)
 defencemen_combos = defencemen.combination(3).to_a.reject{ |player| player.map { |x|  x[:salary].to_f}.reduce(:+)  > 18000 }
     .sort_by {|player| player.map { |x|  x[:projected].to_f }.reduce(:+) }.reverse
     .take(depth)
 goalies_combos = goalies.combination(1).to_a

  selected_rosters = process_rosters center_combos, winger_combos, defencemen_combos, goalies_combos, min_points

  if selected_rosters.count > 0
    min_points = selected_rosters.last[:points].to_f
  end

  if selected_rosters.count > 0
    puts "found " + selected_rosters.count.to_s + " rosters"
    the_rosters << selected_rosters
  end


  unique_rosters = the_rosters.flatten
    .sort_by { |r| r[:expected_points] }.reverse
    .each { |roster| roster[:players].flatten! }
    .take(200000)

  selected_rosters = []
  selected_index = 0

  unique_roster = unique_rosters[0]
  selected_rosters << unique_roster

  unique_roster[:players].each do |player|
    if(the_players.include?(player[:id]))
      the_players[player[:id]] = the_players[player[:id]] + 1
    else
      the_players[player[:id]] = 1
    end
  end

  unique_rosters.each do |unique_roster|

    rosters_matched = 0

    selected_rosters.each do |selected_roster|
      matched = 0
      unique_roster[:players].each do |player|
        selected_roster[:players].each do |selected_player|
          if(selected_player[:id] == player[:id])
            matched += 1
          end
          next if matched > 4
        end
        next if matched > 4
      end
      if(matched > 4)
        rosters_matched += 1
      end
    end

    if(rosters_matched == 0)
      selected_index += 1
      players_matched = 0
      goalies_matched = false
      defencemen_matched = false
      unique_roster[:players].each  do |player|
        if(the_players.include?(player[:id]))
          if the_players[player[:id]] > 5
            players_matched += 1
          end
        end
        if(the_goalies.include?(player[:id]))
          if the_goalies[player[:id]] > 2
            goalies_matched = true
          end
        end
        if(the_defencemen.include?(player[:id]))
          if the_defencemen[player[:id]] > 2
            defencemen_matched = true
          end
        end
      end

      if(players_matched < 4 && !goalies_matched && !defencemen_matched)
        selected_rosters << unique_roster

        unique_roster[:players].each do |player|
          if(player[:position] == "G")
            if(the_goalies.include?(player[:id]))
              the_goalies[player[:id]] = the_goalies[player[:id]] + 1
            else
              the_goalies[player[:id]] = 1
            end
          elsif(player[:position] == "D")
            if(the_defencemen.include?(player[:id]))
              the_defencemen[player[:id]] = the_defencemen[player[:id]] + 1
            else
              the_defencemen[player[:id]] = 1
            end
          else
            if(the_players.include?(player[:id]))
              the_players[player[:id]] = the_players[player[:id]] + 1
            else
              the_players[player[:id]] = 1
            end
          end
        end

      else
        the_matched_rosters << unique_roster
      end
    else
      the_matched_rosters << unique_roster
    end

  end

  puts selected_rosters.count.to_s + " rosters found"

  puts selected_rosters
    .to_json

  selected_rosters.each do |selected_roster|

    roster = fantasy_csv_import.rosters.create!({
        :salary => selected_roster[:salary],
        :points => selected_roster[:expected_points]
      })

    selected_roster[:players].each do |player|

      fantasy_player = FantasyPlayer.where("external_id" => player[:id]).first
      fantasy_player.salary = player[:salary]
      fantasy_player.average_points = player[:ppg]
      fantasy_player.projected_points = player[:projected]
      fantasy_player.opponent_rank = player[:or]
      fantasy_player.save!

      roster.players << fantasy_player.player

    end

  end
end

def process_rosters center_combos, winger_combos, defencemen_combos, goalies_combos,min_points

  #centers = centers.map{ |player| player[:id] }
  #wingers = wingers.map{ |player| player[:id] }
  #defencemen = defencemen.map{ |player| player[:id] }
  #goalies = goalies.map { |player| player[:id] }
  #utils = utils.map { |player| player[:id] }

  checksum_array = []
  rosters = []

  products = CartesianProduct.new(center_combos, winger_combos, defencemen_combos, goalies_combos)

  products.each do |product|

    #checksum = Digest::SHA1.hexdigest product.to_s

    #next if checksum_array.include?checksum

    salary1 = product.map{|combo| combo.map { |x|  x[:salary].to_f}.reduce(:+) }.reduce(:+)

    next if(salary1 > 50000 || salary1 < 45000)

    points1 = product.map{|combo| combo.map { |x|  x[:points].to_f}.reduce(:+) }.reduce(:+)
    expected_points1 = product.map{|combo| combo.map { |x|  x[:projected].to_f}.reduce(:+) }.reduce(:+)
    opponent_rank = product.map{|combo| combo.map { |x|  x[:opponent_rank].to_f}.reduce(:+) }.reduce(:+)

    #next if(points1 < min_points)

    #players = product.flatten

    roster = {
      :players => product,
      :salary => salary1,
      :points => points1,
      :expected_points => expected_points1,
      :opponent_rank => opponent_rank
    }
    #roster[:checksum] = Digest::SHA1.hexdigest roster.to_s
    roster[:matches] = 0
    roster[:player_matches] = 0

    rosters << roster

  end

  if rosters.count  > 0
    return rosters
  end

  return []


end
