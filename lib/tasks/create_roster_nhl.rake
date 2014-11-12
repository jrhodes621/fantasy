require 'csv'

desc "Create Rosters for NHL"
task :create_rosters_nhl => [:environment] do

  centers = Player.only(:_id).where(:position  => "C").desc(:points).take(5).map(&:_id)
  wingers = Player.only(:_id).where(:position  => "W").desc(:points).take(5).map(&:_id)
  defencemen = Player.only(:_id).where(:position  => "D").desc(:points).take(5).map(&:_id)
  goalies = Player.only(:_id).where(:position  => "G").desc(:points).take(5).map(&:_id)
  utils = centers + wingers

  center_combos = centers.combination(2).to_a
  winger_combos = wingers.combination(3).to_a
  defencemen_combos = defencemen.combination(2).to_a

  products = CartesianProduct.new(center_combos, winger_combos, defencemen_combos, goalies, utils)

  i = products.count
  rosters = []
  products.each do |product|
    players = product.flatten
    Roster.create({
      :players => players.map { |p| Player.find(p) }.flatten
    }).tap do |r|
      
      puts i
      i -= 1

    end
  end

end