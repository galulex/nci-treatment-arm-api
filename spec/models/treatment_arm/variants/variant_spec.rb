require 'spec_helper'

# describe Variant do
#
#   it { is_expected.to have_fields(:gene_name, :chromosome, :position, :identifier, :reference, :alternative,
#                       :filter, :description, :protein, :transcript, :hgvs, :location,
#                       :flow_alternative_allele_observation_count, :flow_reference_allele_observations,
#                       :variant_class).of_type(Object) }
#
#   it { is_expected.to have_fields(:read_depth, :reference_allele_observations, :alternative_allele_observation_count,
#                       :level_of_evidence).of_type(Integer) }
#
#   it { is_expected.to have_field(:public_med_ids).of_type(Array) }
#   it { is_expected.to have_field(:allele_frequency).of_type(Float) }
#   it { is_expected.to have_field(:rare).of_type(Mongoid::Boolean) }
#   it { is_expected.to have_field(:inclusion).of_type(Mongoid::Boolean).with_default_value_of(true) }
#   it { is_expected.to have_field(:arm_specific).of_type(Mongoid::Boolean).with_default_value_of(false) }
#
# end