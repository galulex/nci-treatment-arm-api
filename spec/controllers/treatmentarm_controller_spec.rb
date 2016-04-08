require 'rails_helper'
require 'factory_girl_rails'

describe TreatmentarmController do

  describe "POST #newTreatmentArm" do
    context "with valid data" do
      it "should save data to the database" do
        expect { post :armUpload, FactoryGirl.attributes_for(:treatmentarm, :valid)
        }.to raise_error(ArgumentError)
      end
      it "should respond with a success json message"
    end
    context "with invalid data" do
      it "should throw a 500 status" do
        expect { post :armUpload, FactoryGirl.attributes_for(:treatmentarm, :invalid)
        }.to raise_error(ArgumentError)
      end
      it "should respond with a failure json message" do
        # p FactoryGirl.attributes_for(:amoiVariant)
      end
    end

    context "with a new version of treatment arm, archive the old treatment arm"
      it "should archive old treatment arm to the database" do
        route_to('newTreatmentArm')
        expect(response).to have_http_status(200)
      end

      it "should check the version date" do
        mock_treatment_arm = build_stubbed(:treatmentArm)
        mock_treatment_arm_history = build_stubbed(:treatmentArmHistory)
        expect(mock_treatment_arm_history.dateArchived).to eq(Date.parse "Fri, 08 Apr 2016")
      end

      it "should load the treatment arm if it is a newer version"

  end

  describe "POST #approveTreatmentArm" do

    context "with valid data" do
      it "should appove a treatmentArm"
    end

    context "with invalid data" do
      it "should return status 500"
    end
  end

  describe "POST #ecogTreatmentArmList" do

    context "with valid data" do
      it "should accept a list of TA from ECOG"
    end

    context "with invalid data" do
      it "should return a status of 500"
    end
  end

  describe "GET #treatmentArms" do

    it "should return all treatment arms if params are empty" do
      route_to('treatmentArms')
      expect(response).to have_http_status(200)
    end

    it "should return a treatmentArm if id is given" do
      ta = build_stubbed(:treatmentArmVersions)
      route_to('treatmentArms', :id => ta._id)
      expect(response).to have_http_status(200)
    end

  end

  describe "GET #basicTreatmentArms" do
    it "should return the basic data for all treatment arms" do
      route_to('basicTreatmentArms')
      expect(response).to have_http_status(200)
    end
  end

end