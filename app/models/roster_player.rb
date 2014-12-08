class RosterPlayer
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name,          type: String
  field :position,      type: String
  field :team,          type: String
  field :salary,        type: String
  field :average_points, type: Float
  field :projected_points, type: Float
  field :opponent_rank,   type: Float
  field :actual_points, type: Float
  belongs_to :roster

end
