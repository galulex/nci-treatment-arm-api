require 'variant'
require 'mongoid'

    class ConfirmableVariant < NonHotspotRule
      include Mongoid::Document

      field :confirmed, type: Boolean, default: false

    end

