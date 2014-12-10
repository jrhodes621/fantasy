class FantasyPlayer
  include Mongoid::Document
  include Mongoid::Timestamps

  field :fantasy_site, type: String
  field :external_id, type: String
  field :salary, type: Float
  field :average_points, type: Float
  field :projected_points, type: Float
  field :actual_points, type: Float
  field :opponent_rank, type: Float

  belongs_to :player
end
