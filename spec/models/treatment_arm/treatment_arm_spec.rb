require 'spec_helper'

describe TreatmentArm do

  it { is_expected.to have_fields(:name, :version, :description, :targetId, :targetName, :gene,
                      :treatmentArmStatus).of_type(Object) }
  it { is_expected.to have_fields(:numPatientsAssigned, :maxPatientsAllowed).of_type(Integer) }
  it { is_expected.to have_field(:statusLog).of_type(Hash) }
  it { is_expected.to have_field(:dateCreated).of_type(DateTime)}
  it { is_expected.to embed_many(:treatmentArmDrugs).of_type(Drug) }
  it { is_expected.to embed_many(:exclusionDiseases).of_type(Disease) }
  it { is_expected.to embed_many(:exclusionDrugs).of_type(Drug) }
  it { is_expected.to embed_many(:exclusionCriterias).of_type(ExclusionCriteria) }
  it { is_expected.to embed_many(:ptenResults).of_type(PtenResult) }
  it { is_expected.to embed_one(:variantReport).of_type(VariantReport)}


end