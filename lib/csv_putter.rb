require 'csv'
require 'rest_client'
require 'debugger'

qbs = "/Users/lovebob/src/fantasy/tmp/FantasyPros_Fantasy_Football_Rankings_QB.csv"
rbs = "/Users/lovebob/src/fantasy/tmp/FantasyPros_Fantasy_Football_Rankings_RB.csv"
tes = "/Users/lovebob/src/fantasy/tmp/FantasyPros_Fantasy_Football_Rankings_TE.csv"
wrs = "/Users/lovebob/src/fantasy/tmp/FantasyPros_Fantasy_Football_Rankings_WR.csv"


files = [qbs, rbs, tes, wrs]

players = {}

all_headers = []

master_path = File.expand_path(File.dirname(__FILE__))

files.each do |f|
  path = f
    #master_path + "/tmp" + f
#  foo = File.read(path)

  cow = CSV.read(path, {:headers => true, :header_converters => lambda{|x| x.strip.downcase.gsub(' ', '_').intern}})
  heads = cow.headers
  all_headers = all_headers | heads

  cow.each do |row|
    hsh = row.to_h
    uid = row[:player_name] + ":" + row[:team].upcase
    players[uid] = hsh
  end
end


dk_url = "https://www.draftkings.com/lineup/getavailableplayers?draftGroupId=4931"
dk_path = "cached_dk.json"
if File.exist?(dk_path)
# nothing, we will used cached file
  dk_raw = File.read(dk_path)
else
  puts "Fetching #{dk_url}"
  dk_raw = RestClient.get(dk_url)
  File.open(dk_path, 'w') {|f| f.write(dk_raw) }
end

json = JSON.parse(dk_raw)
dk_players = json['playerList']

dkps = {}
keys = ["pid", "pcode", "tsid", "fn", "ln", "fnu", "lnu", "pn", "tid", "htid", "atid", "htabbr", "atabbr", "posid", "slo", "IsDisabledFromDrafting", "ExceptionalMessages", "s", "ppg", "or", "swp", "pp", "i", "news"]

all_headers << :position
all_headers << :ppg
all_headers << :salary
all_headers << :home
all_headers << :opponent_rank


aliases = {
  "T.Y. Hilton" => "Ty Hilton",
  "Cecil Shorts III" => "Cecil Shorts",
  "Steve Smith Sr." => "Steve Smith"
}


dk_players.each do |player|
  if player['tid'] == player['htid'] # home team is their team
    pteam = player["htabbr"].upcase
    home = true
  else
    pteam = player["atabbr"].upcase
    home = false
  end
  name = (player["fn"] + " " + player["ln"]).strip

  if aliases[name]
    name = aliases[name]
  end

  uid = name + ":" + pteam
  if players[uid]
    players[uid][:position] = player['pn']
    players[uid][:ppg] = player['ppg']
    players[uid][:salary] = player['s']
    players[uid][:home] = home
    players[uid][:opponent_rank] = player['or']
  else
    if player['pn'] == "DST"
      # defense, fuck it
    else
      if player['ppg'].to_f > 10
        # sigh, guess we should figure out who it is
        puts "couldn't find #{uid}"
      end
    end
  end
end

















CSV.open("result.csv", "wb") do |csv|
  csv << all_headers
  players.each do |k, v|
    arr = all_headers.map{|x| v[x] || 0}
    csv << arr
  end
end
