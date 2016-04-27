require 'spec_helper'

describe BasicTreatmentArm do

  it {is_expected.to have_fields(:treatment_arm_name, :_id).of_type(String)}
  it {is_expected.to have_fields(:current_patients, :former_patients, :not_enrolled_patients, :pending_patients).of_type(Integer)}
  it {is_expected.to have_fields(:date_created, :date_closed, :date_suspended, :date_opened).of_type(Date)}
  it {is_expected.to have_fields(:treatment_arm_status).of_type(Object)}

end