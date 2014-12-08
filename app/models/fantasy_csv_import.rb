class FantasyCsvImport
  include Mongoid::Document
  field :file_name, type: String
  field :fantasy_site, type: String

  has_many :rosters
end
