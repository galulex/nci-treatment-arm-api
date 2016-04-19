
require 'spec_helper'
require 'mongoid-rspec'

describe Disease do

  it { is_expected.to be_embedded_in(:treatmentarm).as_inverse_of(:exclusion_diseases) }
  it { is_expected.to have_fields(:_id, :medra_code, :ctep_category, :ctep_sub_category, :ctep_term, :short_name).of_type(Object) }

end