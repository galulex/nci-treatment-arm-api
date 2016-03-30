require 'mongoid'
require 'variant'

    class NonHotspotRule < Variant
      include Mongoid::Document
      include Mongoid::Attributes::Dynamic

      field :gene
      field :oncominevariantclass
      field :exon
      field :function
      field :proteinMatch

      embedded_in :variantReport, inverse_of: :nonHotspotRules
      
    end
