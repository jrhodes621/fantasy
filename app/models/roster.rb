class Roster
  include Mongoid::Document
  include Mongoid::Timestamps

  field :salary,        :type => String
  field :points,        :type => Float

  has_many :players

end
