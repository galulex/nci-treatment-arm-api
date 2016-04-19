require 'spec_helper'

describe InclusionVariant do

  it { is_expected.to have_fields(:gene, :id, :type, :description, :amoi, :chromosome, :position, :alt,
                                  :ref, :literature_reference, :special_rules).of_type(Object)}

  it { is_expected.to have_field(:level_of_evidence).of_type(Integer)}

end