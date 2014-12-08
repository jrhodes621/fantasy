class Team
  include Mongoid::Document
  field :name, type: String
  
  belongs_to :sport
end
