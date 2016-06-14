module TreatmentArmValidator

  class << self

    attr_reader :schema

    def schema
      @schema = {
          "type" => "object",
          "required" => ["name", "version","treatmentArmDrugs", "studyId"],
          "properties" => {
              "name" => {"type" => "string", "minLength" => 1},
              "version" => {"type" => "string", "minLength" => 1},
              "treatment_arm_drugs" => {"type" => "array", "items" => {"type" => "object", "properties" => {
                  "drugId" => {"type" => "string"},
                  "name" => {"type" => "string", "minLength" => 1},
                  "pathway" => {"type" => "string"},
                  "description" => {"type" => "string"},
                  "drugClass" => {"type" => "string"},
                  "target" => {"type" => "string"}
              }}},
              "description" => {"type" => "string"},
              "targetId" => {"type" => "string"},
              "targetName" => {"type" => "string"},
              "gene" => {"type" => "string"},
              "exclusionDiseases" => {"type" => "array", "items" =>{"type" => "object", "properties" => {
                  "_id" => {"type" => "string", "minLength" => 1},
                  "medraCode" => {"type" => "string"},
                  "ctepSubCategory" => {"type" => "string"},
                  "ctepTerm" => {"type" => "string"},
                  "ctepCategory" => {"type" => "string"},
                  "shortName" => {"type" => "string"}
              }}},
              "exclusionDrugs" => {"type" => "array", "items" => {"type" => "object", "properties" => {
                  "drugId" => {"type" => "string"},
                  "name" => {"type" => "string", "minLength" => 1},
                  "pathway" => {"type" => "string"},
                  "description" => {"type" => "string"},
                  "drugClass" => {"type" => "string"},
                  "target" => {"type" => "string"}
              }}},
              "exclusionCriterias" => {"type" => "array", "items" => {"type" => "object", "properties" => {
                  "id" => {"type" => "string", "minLength" => 1},
                  "description" => {"type" => "string", "minLength" => 1}
              }}},
              "assayResults" => {"type" => "array", "items" => {"type" => "object", "properties" => {
                  "gene" => {"type" => "string"},
                  "description" => {"type" => "string"},
                  "levelOfEvidence" => {"type" => "number", "multipleOf" => 1.0},
                  "assayResultStatus" => {"type" => "string", "enum" => ["POSITIVE", "NEGATIVE", "INDETERMINATE",
                                                                         "PRE_PRESENT", "PRE_NEGATIVE", "PRE_INDETERMINATE"]
                  },
                  "assayVariant" => {"type" => "string", "enum" => ["PRESENT", "NEGATIVE", "EMPTY"]}
              }}},
              "ptenResults" => {"type" => "array", "items" => {"type" => "object", "properties" => {

              }}},
              "treatmentArmStatus" => {"type" => "string", "minLength" => 1, "enum" => ["OPEN", "SUSPENDED", "UNKNOWN",
                                                                                        "CLOSED"]
              },
              "dateCreated" => {"type" => "string"},
              "statusLog" => {"type" => "object", "properties" => {
                  "id" => {"type" => "number"},
                  "treatmentArmStatus" => {"type" => "string", "enum" => ["OPEN", "SUSPENDED", "UNKNOWN",
                                                                          "CLOSED"]}
              }}
          }
      }
    end
  end
end