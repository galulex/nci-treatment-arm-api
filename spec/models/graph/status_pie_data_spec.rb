

describe StatusPieData do

  it { is_expected.to have_fields(:_id).of_type(Object) }
  it { is_expected.to have_fields(:status_array).of_type(Array) }

end