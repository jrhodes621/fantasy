require 'csv'
require 'digest/sha1'


desc "Create Rosters for NHL"
task :create_rosters_nhl => [:environment] do

  min_points = 0
  the_rosters = []
  size = 5
  file = "db/csv/nov14_nhl.csv"
  id_position = 0 #12
  name_position = 2 #1
  position_position = 1 # 0
  team_position = 4 #3
  salary_position = 3 #2
  points_position = 5 #6

  players = []
  CSV.foreach(file, :headers => true) do |row|

    player = {
      :id => row[id_position],
      :name => row[name_position],
      :position => row[position_position],
      :team => row[team_position],
      :salary => row[salary_position],
      :points => row[points_position]
    }

    players << player

  end

  all_centers = players.select { |player| player[:position] == "C"}.sort_by { |v| v[:points] }.reverse.take(30)
  all_wingers = players.select { |player| player[:position] == "W"}.sort_by { |v| v[:points] }.reverse.take(30)
  all_defencemen = players.select { |player| player[:position] == "D"}.sort_by { |v| v[:points] }.reverse.take(30)
  all_goalies = players.select { |player| player[:position] == "G"}.sort_by { |v| v[:points] }.reverse

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

  for c in (0..all_centers.count).step(size)
    for w in (0..all_wingers.count).step(size)
      for d in (0..all_defencemen.count).step(size)

        puts c.to_s + " " + w.to_s + " " + d.to_s 

        centers = all_centers.drop(c).take(size)
        wingers = all_wingers.drop(w).take(size)
        defencemen = all_defencemen.drop(d).take(size)
        goalies = all_goalies

        center_combos = centers.combination(3).to_a
        winger_combos = wingers.combination(3).to_a
        defencemen_combos = defencemen.combination(2).to_a
        goalies_combos = goalies.combination(1).to_a
        
        selected_rosters = process_rosters center_combos, winger_combos, defencemen_combos, goalies_combos, min_points
 
        if selected_rosters.count > 0
          min_points = selected_rosters.last[:points].to_f
        end

        if selected_rosters.count > 0
          puts "found " + selected_rosters.count.to_s + " rosters"
          the_rosters << selected_rosters
        end
      end
    end
  end 

    for c in (0..all_centers.count).step(size)
    for w in (0..all_wingers.count).step(size)
      for d in (0..all_defencemen.count).step(size)

        puts c.to_s + " " + w.to_s + " " + d.to_s 

        centers = all_centers.drop(c).take(size)
        wingers = all_wingers.drop(w).take(size)
        defencemen = all_defencemen.drop(d).take(size)
        goalies = all_goalies

        center_combos = centers.combination(2).to_a
        winger_combos = wingers.combination(4).to_a
        defencemen_combos = defencemen.combination(2).to_a
        goalies_combos = goalies.combination(1).to_a
        
        selected_rosters = process_rosters center_combos, winger_combos, defencemen_combos, goalies_combos, min_points
 
        if selected_rosters.count > 0
          min_points = selected_rosters.last[:points].to_f
        end

        if selected_rosters.count > 0
          puts "found " + selected_rosters.count.to_s + " rosters"
          the_rosters << selected_rosters
        end
      end
    end
  end 

    for c in (0..all_centers.count).step(size)
    for w in (0..all_wingers.count).step(size)
      for d in (0..all_defencemen.count).step(size)

        puts c.to_s + " " + w.to_s + " " + d.to_s 

        centers = all_centers.drop(c).take(size)
        wingers = all_wingers.drop(w).take(size)
        defencemen = all_defencemen.drop(d).take(size)
        goalies = all_goalies

        center_combos = centers.combination(2).to_a
        winger_combos = wingers.combination(3).to_a
        defencemen_combos = defencemen.combination(3).to_a
        goalies_combos = goalies.combination(1).to_a
        
        selected_rosters = process_rosters center_combos, winger_combos, defencemen_combos, goalies_combos, min_points
 
        if selected_rosters.count > 0
          min_points = selected_rosters.last[:points].to_f
        end

        if selected_rosters.count > 0
          puts "found " + selected_rosters.count.to_s + " rosters"
          the_rosters << selected_rosters
        end
      end
    end
  end 

  unique_rosters = the_rosters.flatten
    .sort_by { |r| r[:points] }.reverse.take(5000)
    .each { |roster| roster[:players].flatten! }
    

  puts "Pulled out unique rosters"

  selected_rosters = []
  selected_index = 0

  selected_rosters << unique_rosters[0]

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
      selected_rosters << unique_roster

      puts selected_index
    end 
  
  end

  puts selected_rosters.to_json

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

    next if(salary1 > 50000 || salary1 < 48000)

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

    rosters << roster

  end

  if rosters.count  > 0
    return rosters
  end

  return []


end