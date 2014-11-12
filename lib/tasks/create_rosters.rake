require 'csv'

desc "Import Players"
task :create_rosters => [:environment] do

  qb1 = Player.only(:_id).where(:position  => "QB").desc(:points).take(5).map(&:_id)
  rbs = Player.only(:_id).where(:position  => "RB").desc(:points).take(5).map(&:_id)
  wrs = Player.only(:_id).where(:position  => "WR").desc(:points).take(5).map(&:_id)
  te1 = Player.only(:_id).where(:position  => "TE").desc(:points).take(5).map(&:_id)
  flex = rbs + wrs + te1

  rb1 = rbs.combination(2).to_a
  wr1 = wrs.combination(3).to_a

  products = CartesianProduct.new(qb1, rb1, wr1, te1, flex)

binding.pry

 
  products.each do |product|
    players = product.flatten
   Roster.new({
      :players => Player.where(:_id.in => players).to_a
    }).tap do |r| 
      r.points = r.players.sum(:points)
      r.salary = r.players.sum(:salary)

      r.save!
    end
  end

binding.pry

end