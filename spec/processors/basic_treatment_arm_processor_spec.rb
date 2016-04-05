require 'spec_helper'
require 'rspec'
require 'rails_helper'

describe BasicTreatmentArm do

  context "Should create a basic treatment arm" do

    it "Should do nothing with an empty treatment arm" do
      basic_treatment_arm = BasicTreatmentArmProcessor.new
      expect(basic_treatment_arm).to be_truthy
    end

    it "Should return an object of type array" do
      mockTreatmentArm = build_stubbed(:basic_treatment_arm)
      @treatment_arm = TreatmentArm
      allow(@treatment_arm).to receive(:all).and_return([mockTreatmentArm])
      basic_treatment_arm = BasicTreatmentArmProcessor.new.create_treatment_arm_hash
      expect(basic_treatment_arm.class).to be(Array)
    end

  end

end

