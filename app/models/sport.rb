class Sport
  include Mongoid::Document
  field :name, type: String
  field :abbreviation, type: String
end
