require 'mongoid'
require 'confirmable_variant'


    class Indel  < ConfirmableVariant
      include Mongoid::Document

      embedded_in :variantReport, inverse_of: :indels

    end
