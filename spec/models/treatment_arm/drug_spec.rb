require 'spec_helper'


describe Drug do

  # it { is_expected.to be_embedded_in(:treatmentarm).as_inverse_of(:treatmentArmDrugs) }
  it { is_expected.to be_embedded_in(:treatmentarm).as_inverse_of(:exclusionDrugs) }
  it { is_expected.to have_fields(:drugId, :name, :description, :drugClass, :pathway, :target).of_type(Object) }

end