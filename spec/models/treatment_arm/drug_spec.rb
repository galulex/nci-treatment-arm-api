require 'spec_helper'


describe Drug do

  # it { is_expected.to be_embedded_in(:treatmentarm).as_inverse_of(:treatment_arm_drugs) }
  it { is_expected.to be_embedded_in(:treatmentarm).as_inverse_of(:exclusion_drugs) }
  it { is_expected.to have_fields(:drugId, :name, :description, :drug_class, :pathway, :target).of_type(Object) }

end