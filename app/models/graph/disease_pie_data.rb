class DiseasePieData
  include Dynamoid::Document

  field :_id
  field :disease_array, :serialized


end