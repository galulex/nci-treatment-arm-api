require 'rails_helper'


describe ConfirmableVariant do

  it { is_expected.to have_field(:confirmed).of_type(Mongoid::Boolean).with_default_value_of(false) }

end