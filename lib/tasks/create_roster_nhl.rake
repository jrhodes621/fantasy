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


  #build the file name dynamically
  file = "2014-12-07T23:32:15-05:00.csv"
  id_position = 0 #12
  name_position = 2 #1
  position_position = 1 # 0
  team_position = 4 #3
  salary_position = 3 #2
  opponent_rank_position = 5
  points_position = 6 #6
  expected_points_position = 8

  players = []
  CSV.foreach(file, :headers => true) do |row|

    player = {
      :id => row[id_position],
      :name => row[name_position],
      :position => row[position_position],
      :team => row[team_position],
      :salary => row[salary_position],
      :points => row[points_position],
      :expected_points => row[expected_points_position],
      :opponent_rank => row[opponent_rank_position]
    }

    players << player

  end

  all_centers = players.select { |player| player[:position] == "C" && player[:expected_points].to_f > 2}.sort_by { |v| v[:points] }.reverse
  all_wingers = players.select { |player| (player[:position] == "RW" || player[:position] == "LW") && player[:expected_points].to_f > 2}.sort_by { |v| v[:points] }.reverse
  all_defencemen = players.select { |player| player[:position] == "D" && player[:expected_points].to_f > 2}.sort_by { |v| v[:points] }.reverse
  all_goalies = players.select { |player| player[:position] == "G" && player[:expected_points].to_f > 2}.sort_by { |v| v[:points] }.reverse

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

  center_combos = centers.combination(3).to_a.reject{ |player| player.map { |x|  x[:salary].delete(',').to_f}.reduce(:+)  > 24000 }
    .sort_by {|player| player.map { |x|  x[:expected_points].to_f }.reduce(:+) }.reverse
    .take(20)
  winger_combos = wingers.combination(3).to_a.reject{ |player| player.map { |x|  x[:salary].delete(',').to_f}.reduce(:+)  > 24000 }
    .sort_by {|player| player.map { |x|  x[:expected_points].to_f }.reduce(:+) }.reverse
    .take(20)
  defencemen_combos = defencemen.combination(2).to_a
    .reject{ |player| player.map { |x|  x[:salary].delete(',').to_f}.reduce(:+)  > 24000 }
    .sort_by {|player| player.map { |x|  x[:expected_points].to_f }.reduce(:+) }.reverse
    .take(20)

  goalies_combos = goalies.combination(1).to_a
  
  binding.pry
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

  center_combos = centers.combination(2).to_a.reject{ |player| player.map { |x|  x[:salary].delete(',').to_f}.reduce(:+)  > 24000 }
     .sort_by {|player| player.map { |x|  x[:expected_points].to_f }.reduce(:+) }.reverse
     .take(20)
 winger_combos = wingers.combination(4).to_a.reject{ |player| player.map { |x|  x[:salary].delete(',').to_f}.reduce(:+)  > 30000 }
     .sort_by {|player| player.map { |x|  x[:expected_points].to_f }.reduce(:+) }.reverse
     .take(20)
 defencemen_combos = defencemen.combination(2).to_a.reject{ |player| player.map { |x|  x[:salary].delete(',').to_f}.reduce(:+)  > 24000 }
     .sort_by {|player| player.map { |x|  x[:expected_points].to_f }.reduce(:+) }.reverse
     .take(20)
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

  center_combos = centers.combination(2).to_a.reject{ |player| player.map { |x|  x[:salary].delete(',').to_f}.reduce(:+)  > 24000 }
     .sort_by {|player| player.map { |x|  x[:expected_points].to_f }.reduce(:+) }.reverse
     .take(20)
 winger_combos = wingers.combination(3).to_a.reject{ |player| player.map { |x|  x[:salary].delete(',').to_f}.reduce(:+)  > 24000 }
     .sort_by {|player| player.map { |x|  x[:expected_points].to_f }.reduce(:+) }.reverse
     .take(20)
 defencemen_combos = defencemen.combination(3).to_a.reject{ |player| player.map { |x|  x[:salary].delete(',').to_f}.reduce(:+)  > 24000 }
     .sort_by {|player| player.map { |x|  x[:expected_points].to_f }.reduce(:+) }.reverse
     .take(20)
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

    binding.pry
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

  fantasy_csv_import = FantasyCsvImport.create!({
    :file_name => file,
    :fantasy_site => "Draft Kings"
  })
  selected_rosters.each do |selected_roster|

    roster = fantasy_csv_import.rosters.create!({
        :salary => selected_roster[:salary],
        :points => selected_roster[:expected_points]
      })

    selected_roster[:players].each do |player|
      roster.roster_players.create!({
        :name => player[:name],
        :position => player[:position],
        :team => player[:team],
        :salary => player[:salary],
        :average_points => player[:points],
        :projected_points => player[:expected_points],
        :opponent_rank => player[:opponent_rank]
      })

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

    salary1 = product.map{|combo| combo.map { |x|  x[:salary].delete(',').to_f}.reduce(:+) }.reduce(:+)

    next if(salary1 > 50000 || salary1 < 45000)

    points1 = product.map{|combo| combo.map { |x|  x[:points].to_f}.reduce(:+) }.reduce(:+)
    expected_points1 = product.map{|combo| combo.map { |x|  x[:expected_points].to_f}.reduce(:+) }.reduce(:+)
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