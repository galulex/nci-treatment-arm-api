require 'spec_helper'

describe PtenResult do

  it { is_expected.to have_field(:description).of_type(Object) }

end