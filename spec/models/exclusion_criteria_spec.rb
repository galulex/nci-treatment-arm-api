require 'spec_helper'

describe ExclusionCriteria do

  it { is_expected.to be_embedded_in(:treatmentarm).as_inverse_of(:exclusionCriterias) }
  it { is_expected.to have_fields(:id, :description).of_type(Object) }

end