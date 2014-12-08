json.array!(@roster_players) do |roster_player|
  json.extract! roster_player, :id
  json.url roster_player_url(roster_player, format: :json)
end
