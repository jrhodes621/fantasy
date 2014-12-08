json.array!(@fantasy_csv_imports) do |fantasy_csv_import|
  json.extract! fantasy_csv_import, :id
  json.url fantasy_csv_import_url(fantasy_csv_import, format: :json)
end
