class StatusPieData
  include Dynamoid::Document

  field :_id
  field :status_array, :serialized


end