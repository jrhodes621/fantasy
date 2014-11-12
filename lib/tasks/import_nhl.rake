require 'csv'

desc "Import NHL Players"
task :import_nhl => [:environment] do

  file = "db/csv/nov11_nhl.csv"

  CSV.foreach(file, :headers => true) do |row|

    Player.create!(
      :name => row[1],
      :position => row[0],
      :team => row[3],
      :salary => row[2],
      :points => row[6]
    )

  end

end