require 'csv'
require 'digest/sha1'


desc "Create Rosters for NHL"
task :create_rosters_nba => [:environment] do

  min_points = 0
  the_rosters = []
  the_matched_rosters = []
  the_players = Hash.new
  size = 5


  #build the file name dynamically
  file = "db/csv/nov19_nba.csv"
  id_position = 0 #12
  name_position = 2 #1
  position_position = 1 # 0
  team_position = 4 #3
  salary_position = 3 #2
  opponent_rank_position = 5
  points_position = 6 #6
  expected_points_position = 7

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

  all_point_guards = players.select { |player| player[:position] == "PG"}.sort_by { |v| v[:points] }.reverse.take(25)
  all_shooting_guards = players.select { |player| player[:position] == "SG"}.sort_by { |v| v[:points] }.reverse.take(25)
  all_small_forwards = players.select { |player| player[:position] == "SF"}.sort_by { |v| v[:points] }.reverse.take(25)
  all_power_forwards = players.select { |player| player[:position] == "PF"}.sort_by { |v| v[:points] }.reverse.take(25)
  all_centers = players.select { |player| player[:position] == "C"}.sort_by { |v| v[:points] }.reverse.take(25)
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


  pgs = all_point_guards
  sgs = all_shooting_guards
  sfs = all_small_forwards
  pfs = all_power_forwards
  centers = all_centers

  selected_rosters = []
  
  pg_combos = pgs.combination(3).to_a
        .reject{ |player| player.map { |x|  x[:salary].to_f}.reduce(:+)  > 18000 }
        .sort_by {|player| player.map { |x|  x[:expected_points].to_f }.reduce(:+) }.reverse
        .take(25)
  sg_combos = sgs.combination(3).to_a
        .reject{ |player| player.map { |x|  x[:salary].to_f}.reduce(:+)  > 18000 }
        .sort_by {|player| player.map { |x|  x[:expected_points].to_f }.reduce(:+) }.reverse
        .take(25)
  sf_combos = sfs.combination(2).to_a
        .reject{ |player| player.map { |x|  x[:salary].to_f}.reduce(:+)  > 12500 }
        .sort_by {|player| player.map { |x|  x[:expected_points].to_f }.reduce(:+) }.reverse
        .take(25)
  pf_combos = pfs.combination(1).to_a
        .reject{ |player| player.map { |x|  x[:salary].to_f}.reduce(:+)  >  12500 }
        .sort_by {|player| player.map { |x|  x[:expected_points].to_f }.reduce(:+) }.reverse
        .take(25)
  center_combos = centers.combination(1).to_a
        .reject{ |player| player.map { |x|  x[:salary].to_f}.reduce(:+)  > 12500 }
        .sort_by {|player| player.map { |x|  x[:expected_points].to_f }.reduce(:+) }.reverse
        .take(25)


  selected_rosters = process_nba_rosters pg_combos, sg_combos, sf_combos, pf_combos, center_combos, min_points

  if selected_rosters.count > 0
    min_points = selected_rosters.last[:points].to_f
  end

  if selected_rosters.count > 0
    the_rosters << selected_rosters
  end

  puts the_rosters.count.to_s + " Rosters"
  
  the_rosters << build_nba_rosters(all_point_guards, all_shooting_guards, all_small_forwards, all_power_forwards, all_centers, 3, 1, 1, 2, 1)
  
    pg_combos = pgs.combination(3).to_a
        .reject{ |player| player.map { |x|  x[:salary].to_f}.reduce(:+)  > 24000 }
        .sort_by {|player| player.map { |x|  x[:expected_points].to_f }.reduce(:+) }.reverse
        .take(25)
  sg_combos = sgs.combination(1).to_a
        .reject{ |player| player.map { |x|  x[:salary].to_f}.reduce(:+)  > 12500 }
        .sort_by {|player| player.map { |x|  x[:expected_points].to_f }.reduce(:+) }.reverse
        .take(25)
  sf_combos = sfs.combination(1).to_a
        .reject{ |player| player.map { |x|  x[:salary].to_f}.reduce(:+)  > 12500 }
        .sort_by {|player| player.map { |x|  x[:expected_points].to_f }.reduce(:+) }.reverse
        .take(25)
  pf_combos = pfs.combination(2).to_a
        .reject{ |player| player.map { |x|  x[:salary].to_f}.reduce(:+)  >  20000 }
        .sort_by {|player| player.map { |x|  x[:expected_points].to_f }.reduce(:+) }.reverse
        .take(25)
  center_combos = centers.combination(1).to_a
        .reject{ |player| player.map { |x|  x[:salary].to_f}.reduce(:+)  > 12500 }
        .sort_by {|player| player.map { |x|  x[:expected_points].to_f }.reduce(:+) }.reverse
        .take(25)

  if selected_rosters.count > 0
    min_points = selected_rosters.last[:points].to_f
  end

  if selected_rosters.count > 0
    the_rosters << selected_rosters
  end

  puts the_rosters.count.to_s + " Rosters"
  
    pg_combos = pgs.combination(1).to_a
        .reject{ |player| player.map { |x|  x[:salary].to_f}.reduce(:+)  > 12500 }
        .sort_by {|player| player.map { |x|  x[:expected_points].to_f }.reduce(:+) }.reverse
        .take(25)
  sg_combos = sgs.combination(3).to_a
        .reject{ |player| player.map { |x|  x[:salary].to_f}.reduce(:+)  > 24000 }
        .sort_by {|player| player.map { |x|  x[:expected_points].to_f }.reduce(:+) }.reverse
        .take(25)
  sf_combos = sfs.combination(2).to_a
        .reject{ |player| player.map { |x|  x[:salary].to_f}.reduce(:+)  > 20000 }
        .sort_by {|player| player.map { |x|  x[:expected_points].to_f }.reduce(:+) }.reverse
        .take(25)
  pf_combos = pfs.combination(1).to_a
        .reject{ |player| player.map { |x|  x[:salary].to_f}.reduce(:+)  >  12500 }
        .sort_by {|player| player.map { |x|  x[:expected_points].to_f }.reduce(:+) }.reverse
        .take(25)
  center_combos = centers.combination(1).to_a
        .reject{ |player| player.map { |x|  x[:salary].to_f}.reduce(:+)  > 12500 }
        .sort_by {|player| player.map { |x|  x[:expected_points].to_f }.reduce(:+) }.reverse
        .take(25)

  if selected_rosters.count > 0
    min_points = selected_rosters.last[:points].to_f
  end

  if selected_rosters.count > 0
    the_rosters << selected_rosters
  end

  puts the_rosters.count.to_s + " Rosters"
  
    pg_combos = pgs.combination(1).to_a
        .reject{ |player| player.map { |x|  x[:salary].to_f}.reduce(:+)  > 15000 }
        .sort_by {|player| player.map { |x|  x[:expected_points].to_f }.reduce(:+) }.reverse
        .take(25)
  sg_combos = sgs.combination(3).to_a
        .reject{ |player| player.map { |x|  x[:salary].to_f}.reduce(:+)  > 20000 }
        .sort_by {|player| player.map { |x|  x[:expected_points].to_f }.reduce(:+) }.reverse
        .take(25)
  sf_combos = sfs.combination(1).to_a
        .reject{ |player| player.map { |x|  x[:salary].to_f}.reduce(:+)  > 12500 }
        .sort_by {|player| player.map { |x|  x[:expected_points].to_f }.reduce(:+) }.reverse
        .take(25)
  pf_combos = pfs.combination(2).to_a
        .reject{ |player| player.map { |x|  x[:salary].to_f}.reduce(:+)  >  20000 }
        .sort_by {|player| player.map { |x|  x[:expected_points].to_f }.reduce(:+) }.reverse
        .take(25)
  center_combos = centers.combination(1).to_a
        .reject{ |player| player.map { |x|  x[:salary].to_f}.reduce(:+)  > 12500 }
        .sort_by {|player| player.map { |x|  x[:expected_points].to_f }.reduce(:+) }.reverse
        .take(25)

  selected_rosters = process_nba_rosters pg_combos, sg_combos, sf_combos, pf_combos, center_combos, min_points

  if selected_rosters.count > 0
    min_points = selected_rosters.last[:points].to_f
  end

  if selected_rosters.count > 0
    the_rosters << selected_rosters
  end

  puts the_rosters.count.to_s + " Rosters"
    
  pg_combos = pgs.combination(2).to_a
        .reject{ |player| player.map { |x|  x[:salary].to_f}.reduce(:+)  > 20000 }
        .sort_by {|player| player.map { |x|  x[:expected_points].to_f }.reduce(:+) }.reverse
        .take(25)
  sg_combos = sgs.combination(1).to_a
        .reject{ |player| player.map { |x|  x[:salary].to_f}.reduce(:+)  > 12500 }
        .sort_by {|player| player.map { |x|  x[:expected_points].to_f }.reduce(:+) }.reverse
        .take(25)
  sf_combos = sfs.combination(3).to_a
        .reject{ |player| player.map { |x|  x[:salary].to_f}.reduce(:+)  > 24000 }
        .sort_by {|player| player.map { |x|  x[:expected_points].to_f }.reduce(:+) }.reverse
        .take(25)
  pf_combos = pfs.combination(1).to_a
        .reject{ |player| player.map { |x|  x[:salary].to_f}.reduce(:+)  >  12500 }
        .sort_by {|player| player.map { |x|  x[:expected_points].to_f }.reduce(:+) }.reverse
        .take(25)
  center_combos = centers.combination(1).to_a
        .reject{ |player| player.map { |x|  x[:salary].to_f}.reduce(:+)  > 12500 }
        .sort_by {|player| player.map { |x|  x[:expected_points].to_f }.reduce(:+) }.reverse
        .take(25)

  selected_rosters = process_nba_rosters pg_combos, sg_combos, sf_combos, pf_combos, center_combos, min_points

  if selected_rosters.count > 0
    min_points = selected_rosters.last[:points].to_f
  end

  if selected_rosters.count > 0
    the_rosters << selected_rosters
  end

  puts the_rosters.count.to_s + " Rosters"
  
  pg_combos = pgs.combination(2).to_a
        .reject{ |player| player.map { |x|  x[:salary].to_f}.reduce(:+)  > 18000 }
        .sort_by {|player| player.map { |x|  x[:expected_points].to_f }.reduce(:+) }.reverse
        .take(25)
  sg_combos = sgs.combination(1).to_a
        .reject{ |player| player.map { |x|  x[:salary].to_f}.reduce(:+)  > 12500 }
        .sort_by {|player| player.map { |x|  x[:expected_points].to_f }.reduce(:+) }.reverse
        .take(25)
  sf_combos = sfs.combination(2).to_a
        .reject{ |player| player.map { |x|  x[:salary].to_f}.reduce(:+)  > 18000 }
        .sort_by {|player| player.map { |x|  x[:expected_points].to_f }.reduce(:+) }.reverse
        .take(25)
  pf_combos = pfs.combination(2).to_a
        .reject{ |player| player.map { |x|  x[:salary].to_f}.reduce(:+)  >  18000 }
        .sort_by {|player| player.map { |x|  x[:expected_points].to_f }.reduce(:+) }.reverse
        .take(25)
  center_combos = centers.combination(1).to_a
        .reject{ |player| player.map { |x|  x[:salary].to_f}.reduce(:+)  > 12500 }
        .sort_by {|player| player.map { |x|  x[:expected_points].to_f }.reduce(:+) }.reverse
        .take(25)


  selected_rosters = process_nba_rosters pg_combos, sg_combos, sf_combos, pf_combos, center_combos, min_points

  if selected_rosters.count > 0
    min_points = selected_rosters.last[:points].to_f
  end

  if selected_rosters.count > 0
    the_rosters << selected_rosters
  end

  puts the_rosters.count.to_s + " Rosters"
  
  pg_combos = pgs.combination(2).to_a
        .reject{ |player| player.map { |x|  x[:salary].to_f}.reduce(:+)  > 18000 }
        .sort_by {|player| player.map { |x|  x[:expected_points].to_f }.reduce(:+) }.reverse
        .take(25)
  sg_combos = sgs.combination(1).to_a
        .reject{ |player| player.map { |x|  x[:salary].to_f}.reduce(:+)  > 12500 }
        .sort_by {|player| player.map { |x|  x[:expected_points].to_f }.reduce(:+) }.reverse
        .take(25)
  sf_combos = sfs.combination(1).to_a
        .reject{ |player| player.map { |x|  x[:salary].to_f}.reduce(:+)  > 12500 }
        .sort_by {|player| player.map { |x|  x[:expected_points].to_f }.reduce(:+) }.reverse
        .take(25)
  pf_combos = pfs.combination(3).to_a
        .reject{ |player| player.map { |x|  x[:salary].to_f}.reduce(:+)  >  24000 }
        .sort_by {|player| player.map { |x|  x[:expected_points].to_f }.reduce(:+) }.reverse
        .take(25)
  center_combos = centers.combination(1).to_a
        .reject{ |player| player.map { |x|  x[:salary].to_f}.reduce(:+)  > 12500 }
        .sort_by {|player| player.map { |x|  x[:expected_points].to_f }.reduce(:+) }.reverse
        .take(25)

  selected_rosters = process_nba_rosters pg_combos, sg_combos, sf_combos, pf_combos, center_combos, min_points

  if selected_rosters.count > 0
    min_points = selected_rosters.last[:points].to_f
  end

  if selected_rosters.count > 0
    the_rosters << selected_rosters
  end

  puts the_rosters.count.to_s + " Rosters"
  
  the_rosters << build_nba_rosters(all_point_guards, all_shooting_guards, all_small_forwards, all_power_forwards, all_centers, 2, 1, 2, 1, 2)
  
  pg_combos = pgs.combination(2).to_a
        .reject{ |player| player.map { |x|  x[:salary].to_f}.reduce(:+)  > 18000 }
        .sort_by {|player| player.map { |x|  x[:expected_points].to_f }.reduce(:+) }.reverse
        .take(25)
  sg_combos = sgs.combination(1).to_a
        .reject{ |player| player.map { |x|  x[:salary].to_f}.reduce(:+)  > 12500 }
        .sort_by {|player| player.map { |x|  x[:expected_points].to_f }.reduce(:+) }.reverse
        .take(25)
  sf_combos = sfs.combination(2).to_a
        .reject{ |player| player.map { |x|  x[:salary].to_f}.reduce(:+)  > 18000 }
        .sort_by {|player| player.map { |x|  x[:expected_points].to_f }.reduce(:+) }.reverse
        .take(25)
  pf_combos = pfs.combination(1).to_a
        .reject{ |player| player.map { |x|  x[:salary].to_f}.reduce(:+)  >  12500 }
        .sort_by {|player| player.map { |x|  x[:expected_points].to_f }.reduce(:+) }.reverse
        .take(25)
  center_combos = centers.combination(2).to_a
        .reject{ |player| player.map { |x|  x[:salary].to_f}.reduce(:+)  > 18000 }
        .sort_by {|player| player.map { |x|  x[:expected_points].to_f }.reduce(:+) }.reverse
        .take(25)

  selected_rosters = process_nba_rosters pg_combos, sg_combos, sf_combos, pf_combos, center_combos, min_points

  if selected_rosters.count > 0
    min_points = selected_rosters.last[:points].to_f
  end

  if selected_rosters.count > 0
    the_rosters << selected_rosters
  end

  puts the_rosters.count.to_s + " Rosters"

  pg_combos = pgs.combination(2).to_a
        .reject{ |player| player.map { |x|  x[:salary].to_f}.reduce(:+)  > 18000 }
        .sort_by {|player| player.map { |x|  x[:expected_points].to_f }.reduce(:+) }.reverse
        .take(25)
  sg_combos = sgs.combination(1).to_a
        .reject{ |player| player.map { |x|  x[:salary].to_f}.reduce(:+)  > 12500 }
        .sort_by {|player| player.map { |x|  x[:expected_points].to_f }.reduce(:+) }.reverse
        .take(25)
  sf_combos = sfs.combination(1).to_a
        .reject{ |player| player.map { |x|  x[:salary].to_f}.reduce(:+)  > 12500 }
        .sort_by {|player| player.map { |x|  x[:expected_points].to_f }.reduce(:+) }.reverse
        .take(25)
  pf_combos = pfs.combination(2).to_a
        .reject{ |player| player.map { |x|  x[:salary].to_f}.reduce(:+)  >  18000 }
        .sort_by {|player| player.map { |x|  x[:expected_points].to_f }.reduce(:+) }.reverse
        .take(25)
  center_combos = centers.combination(2).to_a
        .reject{ |player| player.map { |x|  x[:salary].to_f}.reduce(:+)  > 18000 }
        .sort_by {|player| player.map { |x|  x[:expected_points].to_f }.reduce(:+) }.reverse
        .take(25)

  selected_rosters = process_nba_rosters pg_combos, sg_combos, sf_combos, pf_combos, center_combos, min_points

  if selected_rosters.count > 0
    min_points = selected_rosters.last[:points].to_f
  end

  if selected_rosters.count > 0
    the_rosters << selected_rosters
  end

  puts the_rosters.count.to_s + " Rosters"
  
  pg_combos = pgs.combination(1).to_a
        .reject{ |player| player.map { |x|  x[:salary].to_f}.reduce(:+)  > 12500 }
        .sort_by {|player| player.map { |x|  x[:expected_points].to_f }.reduce(:+) }.reverse
        .take(25)
  sg_combos = sgs.combination(2).to_a
        .reject{ |player| player.map { |x|  x[:salary].to_f}.reduce(:+)  > 18000 }
        .sort_by {|player| player.map { |x|  x[:expected_points].to_f }.reduce(:+) }.reverse
        .take(25)
  sf_combos = sfs.combination(3).to_a
        .reject{ |player| player.map { |x|  x[:salary].to_f}.reduce(:+)  > 24000 }
        .sort_by {|player| player.map { |x|  x[:expected_points].to_f }.reduce(:+) }.reverse
        .take(25)
  pf_combos = pfs.combination(1).to_a
        .reject{ |player| player.map { |x|  x[:salary].to_f}.reduce(:+)  >  12500 }
        .sort_by {|player| player.map { |x|  x[:expected_points].to_f }.reduce(:+) }.reverse
        .take(25)
  center_combos = centers.combination(1).to_a
        .reject{ |player| player.map { |x|  x[:salary].to_f}.reduce(:+)  > 12500 }
        .sort_by {|player| player.map { |x|  x[:expected_points].to_f }.reduce(:+) }.reverse
        .take(25)

  selected_rosters = process_nba_rosters pg_combos, sg_combos, sf_combos, pf_combos, center_combos, min_points

  if selected_rosters.count > 0
    min_points = selected_rosters.last[:points].to_f
  end

  if selected_rosters.count > 0
    the_rosters << selected_rosters
  end

  puts the_rosters.count.to_s + " Rosters"
  
  the_rosters << build_nba_rosters(all_point_guards, all_shooting_guards, all_small_forwards, all_power_forwards, all_centers, 1, 2, 2, 2, 1)
  
  pg_combos = pgs.combination(1).to_a
        .reject{ |player| player.map { |x|  x[:salary].to_f}.reduce(:+)  > 12500 }
        .sort_by {|player| player.map { |x|  x[:expected_points].to_f }.reduce(:+) }.reverse
        .take(25)
  sg_combos = sgs.combination(2).to_a
        .reject{ |player| player.map { |x|  x[:salary].to_f}.reduce(:+)  > 18000 }
        .sort_by {|player| player.map { |x|  x[:expected_points].to_f }.reduce(:+) }.reverse
        .take(25)
  sf_combos = sfs.combination(2).to_a
        .reject{ |player| player.map { |x|  x[:salary].to_f}.reduce(:+)  > 18000 }
        .sort_by {|player| player.map { |x|  x[:expected_points].to_f }.reduce(:+) }.reverse
        .take(25)
  pf_combos = pfs.combination(2).to_a
        .reject{ |player| player.map { |x|  x[:salary].to_f}.reduce(:+)  >  18000 }
        .sort_by {|player| player.map { |x|  x[:expected_points].to_f }.reduce(:+) }.reverse
        .take(25)
  center_combos = centers.combination(1).to_a
        .reject{ |player| player.map { |x|  x[:salary].to_f}.reduce(:+)  > 12500 }
        .sort_by {|player| player.map { |x|  x[:expected_points].to_f }.reduce(:+) }.reverse
        .take(25)

  selected_rosters = process_nba_rosters pg_combos, sg_combos, sf_combos, pf_combos, center_combos, min_points

  if selected_rosters.count > 0
    min_points = selected_rosters.last[:points].to_f
  end

  if selected_rosters.count > 0
    the_rosters << selected_rosters
  end

  puts the_rosters.count.to_s + " Rosters"
  
  the_rosters << build_nba_rosters(all_point_guards, all_shooting_guards, all_small_forwards, all_power_forwards, all_centers, 1, 2, 1, 3, 1)
  
  pg_combos = pgs.combination(1).to_a
        .reject{ |player| player.map { |x|  x[:salary].to_f}.reduce(:+)  > 12500 }
        .sort_by {|player| player.map { |x|  x[:expected_points].to_f }.reduce(:+) }.reverse
        .take(25)
  sg_combos = sgs.combination(2).to_a
        .reject{ |player| player.map { |x|  x[:salary].to_f}.reduce(:+)  > 18000 }
        .sort_by {|player| player.map { |x|  x[:expected_points].to_f }.reduce(:+) }.reverse
        .take(25)
  sf_combos = sfs.combination(1).to_a
        .reject{ |player| player.map { |x|  x[:salary].to_f}.reduce(:+)  > 12500 }
        .sort_by {|player| player.map { |x|  x[:expected_points].to_f }.reduce(:+) }.reverse
        .take(25)
  pf_combos = pfs.combination(3).to_a
        .reject{ |player| player.map { |x|  x[:salary].to_f}.reduce(:+)  >  24000 }
        .sort_by {|player| player.map { |x|  x[:expected_points].to_f }.reduce(:+) }.reverse
        .take(25)
  center_combos = centers.combination(1).to_a
        .reject{ |player| player.map { |x|  x[:salary].to_f}.reduce(:+)  > 12500 }
        .sort_by {|player| player.map { |x|  x[:expected_points].to_f }.reduce(:+) }.reverse
        .take(25)

  selected_rosters = process_nba_rosters pg_combos, sg_combos, sf_combos, pf_combos, center_combos, min_points

  if selected_rosters.count > 0
    min_points = selected_rosters.last[:points].to_f
  end

  if selected_rosters.count > 0
    the_rosters << selected_rosters
  end

  puts the_rosters.count.to_s + " Rosters"
  
  pg_combos = pgs.combination(1).to_a
        .reject{ |player| player.map { |x|  x[:salary].to_f}.reduce(:+)  > 12500 }
        .sort_by {|player| player.map { |x|  x[:expected_points].to_f }.reduce(:+) }.reverse
        .take(25)
  sg_combos = sgs.combination(2).to_a
        .reject{ |player| player.map { |x|  x[:salary].to_f}.reduce(:+)  > 18000 }
        .sort_by {|player| player.map { |x|  x[:expected_points].to_f }.reduce(:+) }.reverse
        .take(25)
  sf_combos = sfs.combination(2).to_a
        .reject{ |player| player.map { |x|  x[:salary].to_f}.reduce(:+)  > 18000 }
        .sort_by {|player| player.map { |x|  x[:expected_points].to_f }.reduce(:+) }.reverse
        .take(25)
  pf_combos = pfs.combination(1).to_a
        .reject{ |player| player.map { |x|  x[:salary].to_f}.reduce(:+)  >  12500 }
        .sort_by {|player| player.map { |x|  x[:expected_points].to_f }.reduce(:+) }.reverse
        .take(25)
  center_combos = centers.combination(2).to_a
        .reject{ |player| player.map { |x|  x[:salary].to_f}.reduce(:+)  > 18000 }
        .sort_by {|player| player.map { |x|  x[:expected_points].to_f }.reduce(:+) }.reverse
        .take(25)


  selected_rosters = process_nba_rosters pg_combos, sg_combos, sf_combos, pf_combos, center_combos, min_points

  if selected_rosters.count > 0
    min_points = selected_rosters.last[:points].to_f
  end

  if selected_rosters.count > 0
    the_rosters << selected_rosters
  end

  puts the_rosters.count.to_s + " Rosters"
  
  pg_combos = pgs.combination(1).to_a
        .reject{ |player| player.map { |x|  x[:salary].to_f}.reduce(:+)  > 12500 }
        .sort_by {|player| player.map { |x|  x[:expected_points].to_f }.reduce(:+) }.reverse
        .take(25)
  sg_combos = sgs.combination(2).to_a
        .reject{ |player| player.map { |x|  x[:salary].to_f}.reduce(:+)  > 18000 }
        .sort_by {|player| player.map { |x|  x[:expected_points].to_f }.reduce(:+) }.reverse
        .take(25)
  sf_combos = sfs.combination(1).to_a
        .reject{ |player| player.map { |x|  x[:salary].to_f}.reduce(:+)  > 12500 }
        .sort_by {|player| player.map { |x|  x[:expected_points].to_f }.reduce(:+) }.reverse
        .take(25)
  pf_combos = pfs.combination(2).to_a
        .reject{ |player| player.map { |x|  x[:salary].to_f}.reduce(:+)  >  18000 }
        .sort_by {|player| player.map { |x|  x[:expected_points].to_f }.reduce(:+) }.reverse
        .take(25)
  center_combos = centers.combination(2).to_a
        .reject{ |player| player.map { |x|  x[:salary].to_f}.reduce(:+)  > 18000 }
        .sort_by {|player| player.map { |x|  x[:expected_points].to_f }.reduce(:+) }.reverse
        .take(25)

  selected_rosters = process_nba_rosters pg_combos, sg_combos, sf_combos, pf_combos, center_combos, min_points

  if selected_rosters.count > 0
    min_points = selected_rosters.last[:points].to_f
  end

  if selected_rosters.count > 0
    the_rosters << selected_rosters
  end

  puts the_rosters.count.to_s + " Rosters"
  
  unique_rosters = the_rosters.flatten
    .sort_by { |r| r[:points] }.reverse.take(200000)
    .each { |roster| roster[:players].flatten! }
    
  puts "Pulled out unique rosters"

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
    
      unique_roster[:players].each  do |player|
        if(the_players.include?(player[:id])  && player[:position] != "G")
          if the_players[player[:id]] 
            players_matched += 1
          end
        end
      end

      if(players_matched < 5)
        selected_rosters << unique_roster

        unique_roster[:players].each do |player|
          if(the_players.include?(player[:id]))
            the_players[player[:id]] = the_players[player[:id]] + 1
          else
            the_players[player[:id]] = 1
          end
        end

      else
        the_matched_rosters << unique_roster
      end 
    else
      the_matched_rosters << unique_roster
    end 
  
  end

  binding.pry
  puts selected_rosters.to_json

end

def build_nba_rosters all_point_guards, all_shooting_guards, all_small_forwards, all_power_forwards, all_centers, num_of_pg, num_of_sg, num_of_sf, num_of_pf, num_of_center
  size = 5
  min_points = 0
  the_rosters = []

  puts num_of_pg.to_s + " " + num_of_pg.to_s + " " + num_of_sf.to_s  + " " + num_of_pf.to_s  + " " + num_of_center.to_s 

  pgs = all_point_guards
  sgs = all_shooting_guards
  sfs = all_small_forwards
  pfs = all_power_forwards
  centers = all_centers
  
  pg_combos = pgs.combination(num_of_pg).to_a
        .reject{ |player| player.map { |x|  x[:salary].to_f}.reduce(:+)  > 18000 }
        .sort_by {|player| player.map { |x|  x[:expected_points].to_f }.reduce(:+) }.reverse
        .take(25)
  sg_combos = sgs.combination(num_of_sg).to_a
        .reject{ |player| player.map { |x|  x[:salary].to_f}.reduce(:+)  > 18000 }
        .sort_by {|player| player.map { |x|  x[:expected_points].to_f }.reduce(:+) }.reverse
        .take(25)
  sf_combos = sfs.combination(num_of_sf).to_a
        .reject{ |player| player.map { |x|  x[:salary].to_f}.reduce(:+)  > 12500 }
        .sort_by {|player| player.map { |x|  x[:expected_points].to_f }.reduce(:+) }.reverse
        .take(25)
  pf_combos = pfs.combination(num_of_pf).to_a
        .reject{ |player| player.map { |x|  x[:salary].to_f}.reduce(:+)  >  12500 }
        .sort_by {|player| player.map { |x|  x[:expected_points].to_f }.reduce(:+) }.reverse
        .take(25)
  center_combos = centers.combination(num_of_center).to_a
        .reject{ |player| player.map { |x|  x[:salary].to_f}.reduce(:+)  > 12500 }
        .sort_by {|player| player.map { |x|  x[:expected_points].to_f }.reduce(:+) }.reverse
        .take(25)

  selected_rosters = process_nba_rosters pg_combos, sg_combos, sf_combos, pf_combos, center_combos, min_points

  if selected_rosters.count > 0
    min_points = selected_rosters.last[:points].to_f
  end

  if selected_rosters.count > 0
    the_rosters << selected_rosters
  end

  return the_rosters
end

def process_nba_rosters pg_combos, sg_combos, sf_combos, pf_combos, center_combos, min_points
 
  checksum_array = []
  rosters = []
  
  products = CartesianProduct.new(pg_combos, sg_combos, sf_combos, pf_combos, center_combos)

  products.each do |product|

    #checksum = Digest::SHA1.hexdigest product.to_s

    #next if checksum_array.include?checksum

    salary1 = product.map{|combo| combo.map { |x|  x[:salary].to_f}.reduce(:+) }.reduce(:+)

    next if(salary1 > 50000)

    next if(salary1 < 48000)

    points1 = product.map{|combo| combo.map { |x|  x[:points].to_f}.reduce(:+) }.reduce(:+)

    #next if(points1 < min_points)

    #players = product.flatten

    roster = {
      :players => product,
      :salary => salary1,
      :points => points1,
    }
    #roster[:checksum] = Digest::SHA1.hexdigest roster.to_s
    roster[:matches] = 0
    roster[:player_matches] = 0

    rosters << roster

    break if(rosters.count>1000)

  end

  if rosters.count  > 0
    return rosters
  end

  return []


end