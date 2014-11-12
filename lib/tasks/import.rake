require 'csv'

desc "Import Players"
task :import => [:environment] do

  file = "db/csv/week9.csv"

  CSV.foreach(file, :headers => true) do |row|

    Player.create!(
      :name => row[1],
      :position => row[2],
      :team => row[3],
      :salary => row[4],
      :points => row[5]
    )

  end

end