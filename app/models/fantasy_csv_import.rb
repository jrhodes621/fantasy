class FantasyCsvImport
  include Mongoid::Document
  include Mongoid::Timestamps

  field :file_name, type: String
  field :fantasy_site, type: String
  field :players_array, type: Array

  has_many :rosters
end
