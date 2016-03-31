require 'spec_helper'
require 'rspec'
require 'rails_helper'

describe BasicTreatmentArm do

  before(:each) {
    @basic_treatment_arm = BasicTreatmentArmProcessor.new.create_treatment_arm_hash
    @basic_treatment_arm_json =  {
        :"_id" => "EAY131-A",
        :"_class" => "gov.match.model.TreatmentArm",
        :"name" => "Afatinib in EGFR activating",
        :"version" => "2016-02-20",
        :"description" => "Afatinib in EGFR activating mutation",
        :"targetId" => "750691",
        :"targetName" => "Afatinib",
        :"gene" => "EGFR",
        :"exclusionCriterias" => [],
        :"ptenResults" => [],
        :"numPatientsAssigned" => 2,
        :"maxPatientsAllowed" => 35,
        :"treatmentArmStatus" => "OPEN",
        :"dateCreated" => "2016-03-03T19:38:37.890Z"
    }
  }

  context "Should create a basic treatment arm" do

    it "Should do nothing with an empty treatment arm" do
      expect(@basic_treatment_arm).to be_truthy
    end

    it "Should return an object of type array" do
      expect(@basic_treatment_arm.class).to be(Array)
    end

    it "Should create a basic treatment arm" do
      expect(@basic_treatment_arm_json).to include(:numPatientsAssigned => 2)
    end

  end

end

