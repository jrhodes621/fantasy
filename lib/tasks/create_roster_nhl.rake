require 'csv'
require 'digest/sha1'

desc "Create Rosters for NHL"
task :create_rosters_nhl => [:environment] do

  file = "db/csv/nov11_nhl.csv"

  players = []
  CSV.foreach(file, :headers => true) do |row|

    player = {
      :id => row[12],
      :name => row[1],
      :position => row[0],
      :team => row[3],
      :salary => row[2],
      :points => row[6]
    }

    players << player

  end

  rosters = []
  
  centers = players.select { |player| player[:position] == "C"}.sort_by { |v| v[:points] }.reverse.take(20)
  wingers = players.select { |player| player[:position] == "W"}.sort_by { |v| v[:points] }.reverse.take(20)
  defencemen = players.select { |player| player[:position] == "D"}.sort_by { |v| v[:points] }.reverse.take(20)
  goalies = players.select { |player| player[:position] == "G"}.sort_by { |v| v[:points] }.reverse.take(10)
  utils = centers + wingers + defencemen

  center_combos = centers.combination(2).to_a
  winger_combos = wingers.combination(3).to_a
  defencemen_combos = defencemen.combination(2).to_a

  products = CartesianProduct.new(center_combos, winger_combos, defencemen_combos, goalies, utils)

  puts "Generated cartesian product of positions " + products.count.to_s
  p = products.collect { |p| p.flatten }
  i = products.count
  
  p.each do |product|
    salary = 0
    players = product.each { |p| salary += p[:salary].to_f }
  
    i -= 1
    puts i

    next if(salary > 50000)

    points = 0
    product.each { |p| points += p[:points].to_f }
    roster = {
      :players => players,
      :salary => salary,
      :points => points,
    }
    roster[:checksum] = Digest::SHA1.hexdigest roster.to_s
    roster[:matches] = 0

    rosters << roster

  end

  top_rosters = rosters.sort_by { |r| r[:points] }.reverse.take(5000)
  puts "Got top rosters"

  unique_rosters = rosters.uniq { |r| r[:checksum] }
  put "Pulled out unique rosters"

  selected_rosters = []
  selected_index = 0

  selected_rosters << unique_rosters.sort_by { |r| r[:points] }.reverse[0]

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

  the_rosters = selected_rosters.sort_by { |r| r[:points] }.reverse.take(25)
  puts the_rosters

end