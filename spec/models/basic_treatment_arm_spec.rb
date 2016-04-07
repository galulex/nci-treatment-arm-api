require 'spec_helper'

describe BasicTreatmentArm do

  it {is_expected.to have_fields(:treatmentArmName, :_id).of_type(String)}
  it {is_expected.to have_fields(:currentPatients, :formerPatients, :notEnrolledPatients, :pendingPatients).of_type(Integer)}
  it {is_expected.to have_fields(:dateCreated, :dateClosed, :dateSuspended, :dateOpened).of_type(DateTime)}
  it {is_expected.to have_fields(:treatmentArmStatus).of_type(Object)}

end