class Player
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :position, type: String
  field :injured, type: Boolean

  has_many :fantasy_player
  has_many :rosters
  
end
