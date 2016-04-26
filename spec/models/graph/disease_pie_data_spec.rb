
describe DiseasePieData do

  it { is_expected.to have_fields(:_id).of_type(Object) }
  it { is_expected.to have_fields(:disease_array).of_type(Array) }

end