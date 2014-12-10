class Roster
  include Mongoid::Document
  include Mongoid::Timestamps

  field :salary,        type: String
  field :points,        type: Float

  belongs_to :fantasy_csv_import
  has_and_belongs_to_many :players, :inverse_of => nil

end
