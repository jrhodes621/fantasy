class Sport
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :abbreviation, type: String
end
