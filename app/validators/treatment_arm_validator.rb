module TreatmentArmValidator

  class << self

    attr_reader :schema

    def schema
      @schema = {
          "definitions" => {
              "drug" => {
                  "type" => "object",
                  "properties" => {
                      "drug_id" => {"type" => "string"},
                      "name" => {"type" => "string", "minLength" => 1},
                      "pathway" => {"type" => "string"},
                      "description" => {"type" => "string"},
                      "drug_class" => {"type" => "string"},
                      "target" => {"type" => "string"}
                  },
                  "required" => ["name"]
              }
          },
          "type" => "object",
          "required" => ["name", "version","treatment_arm_drugs", "study_id"],
          "properties" => {
              "name" => {"type" => "string", "minLength" => 1},
              "version" => {"type" => "string", "minLength" => 1},
              "treatment_arm_drugs" => {"type" => "array", "items" => {"$ref" => "#/definitions/drug" }},
              "description" => {"type" => "string"},
              "target_id" => {"type" => "string"},
              "target_name" => {"type" => "string"},
              "gene" => {"type" => "string"},
              "exclusion_diseases" => {"type" => "array", "items" =>{"type" => "object", "properties" => {
                  "_id" => {"type" => "string", "minLength" => 1},
                  "medra_code" => {"type" => "string"},
                  "ctep_sub_category" => {"type" => "string"},
                  "ctep_term" => {"type" => "string"},
                  "ctep_category" => {"type" => "string"},
                  "short_name" => {"type" => "string"}
              }}},
              "exclusion_drugs" => {"type" => "array", "items" => {"$ref" => "#/definitions/drug"}},
              "exclusion_criterias" => {"type" => "array", "items" => {"type" => "object", "properties" => {
                  "id" => {"type" => "string", "minLength" => 1},
                  "description" => {"type" => "string", "minLength" => 1}
              }}},
              "assay_results" => {"type" => "array", "items" => {"type" => "object", "properties" => {
                  "gene" => {"type" => "string"},
                  "description" => {"type" => "string"},
                  "level_of_evidence" => {"type" => "number", "multipleOf" => 1.0},
                  "assay_result_status" => {"type" => "string", "enum" => ["POSITIVE", "NEGATIVE", "INDETERMINATE",
                                                                         "PRE_PRESENT", "PRE_NEGATIVE", "PRE_INDETERMINATE"]
                  },
                  "assay_variant" => {"type" => "string", "enum" => ["PRESENT", "NEGATIVE", "EMPTY"]}
              }}},
              "pten_results" => {"type" => "array", "items" => {"type" => "object", "properties" => {

              }}},
              "treatment_arm_status" => {"type" => "string", "minLength" => 1, "enum" => ["OPEN", "SUSPENDED", "UNKNOWN",
                                                                                        "CLOSED"]
              },
              "date_created" => {"type" => "string"},
              "status_log" => {"type" => "object", "properties" => {
                  "id" => {"type" => "number"},
                  "treatment_arm_status" => {"type" => "string", "enum" => ["OPEN", "SUSPENDED", "UNKNOWN",
                                                                          "CLOSED"]}
              }}
          }
      }
    end
  end
end