class Player
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name,        type: String
  field :position, 	  type: String
  field :team, 	  	  type: String
  field :salary,	  type: Integer
  field :points, 	  type: Float

  belongs_to :roster
end