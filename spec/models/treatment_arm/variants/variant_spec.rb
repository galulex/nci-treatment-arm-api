require 'spec_helper'

# describe Variant do
#
#   it { is_expected.to have_fields(:geneName, :chromosome, :position, :identifier, :reference, :alternative,
#                       :filter, :description, :protein, :transcript, :hgvs, :location,
#                       :flowAlternativeAlleleObservationCount, :flowReferenceAlleleObservations,
#                       :variantClass).of_type(Object) }
#
#   it { is_expected.to have_fields(:readDepth, :referenceAlleleObservations, :alternativeAlleleObservationCount,
#                       :levelOfEvidence).of_type(Integer) }
#
#   it { is_expected.to have_field(:publicMedIds).of_type(Array) }
#   it { is_expected.to have_field(:alleleFrequency).of_type(Float) }
#   it { is_expected.to have_field(:rare).of_type(Mongoid::Boolean) }
#   it { is_expected.to have_field(:inclusion).of_type(Mongoid::Boolean).with_default_value_of(true) }
#   it { is_expected.to have_field(:armSpecific).of_type(Mongoid::Boolean).with_default_value_of(false) }
#
# end