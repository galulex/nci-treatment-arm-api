
require 'spec_helper'
require 'mongoid-rspec'

describe Disease do

  it { is_expected.to be_embedded_in(:treatmentarm).as_inverse_of(:exclusionDiseases) }
  it { is_expected.to have_fields(:_id, :medraCode, :ctepCategory, :ctepSubCategory, :ctepTerm, :shortName).of_type(Object) }

end