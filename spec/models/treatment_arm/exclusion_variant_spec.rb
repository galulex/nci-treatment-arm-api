require 'spec_helper'

describe ExclusionVariant do

  it { is_expected.to have_fields(:gene, :id, :type, :description, :amoi, :chromosome, :position, :alt,
                      :ref, :literature_Reference, :special_Rules).of_type(Object)}

  it { is_expected.to have_field(:level_Of_Evidence).of_type(Integer)}

end