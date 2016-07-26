module TreatmentArmValidator

  class << self

    attr_reader :schema

    def schema
      @schema = {
          "definitions" => {
              "drug" => {
                  "type" => "object",
                  "properties" => {
                      "drug_id" => {"anyOf" => [{"type" => "string"}, {"type" => "null"}]},
                      "name" => {"type" => "string", "minLength" => 1},
                      "pathway" => {"anyOf" => [{"type" => "string"}, {"type" => "null"}]},
                      "description" => {"anyOf" => [{"type" => "string"}, {"type" => "null"}]},
                      "drug_class" => {"anyOf" => [{"type" => "string"}, {"type" => "null"}]},
                      "target" => {"anyOf" => [{"type" => "string"}, {"type" => "null"}]},
                  },
                  "required" => ["name"]
              },
              "treatment_arm_status" => {
                  "type" => "string",
                  "enum" => ["OPEN", "SUSPENDED", "UNKNOWN",
                              "CLOSED"],
                  "required" => ["enum"]
              },
              "diseases" => {
                  "type" => "object",
                  "properties" => {
                      "_id" => {"type" => "string", "minLength" => 1},
                      "disease_type_code" => {"anyOf" => [{"type" => "string"}, {"type" => "null"}]},
                      "disease_code" => {"anyOf" => [{"type" => "string"}, {"type" => "null"}]},
                      "ctep_sub_category" => {"anyOf" => [{"type" => "string"}, {"type" => "null"}]},
                      "ctep_term" => {"anyOf" => [{"type" => "string"}, {"type" => "null"}]},
                      "ctep_category" => {"anyOf" => [{"type" => "string"}, {"type" => "null"}]},
                      "short_name" => {"anyOf" => [{"type" => "string"}, {"type" => "null"}]}
                  }
              }
          },
          "type" => "object",
          "required" => ["name", "version", "date_created", "stratum_id","treatment_arm_drugs", "study_id"],
          "properties" => {
              "name" => {"type" => "string", "not" => {"type" => "null"}},
              "version" => {"type" => "string", "not" => {"type" => "null"}},
              "date_created" => {"type" => "string", "not" => {"type" => "null"}},
              "stratum_id" => {"type" => "string", "not" => {"type" => "null"}},
              "treatment_arm_drugs" => {"type" => "array", "items" => {"$ref" => "#/definitions/drug" }},
              "description" => {"type" => "string"},
              "target_id" => {"anyOf" => [{"type" => "string"}, {"type" => "number"}, {"type" => "null"}]},
              "target_name" => {"type" => "string"},
              "gene" => {"type" => "string"},
              "exclusion_diseases" => {"type" => "array", "items" => {"$ref" => "#/definitions/diseases" }},
              "inclusion_diseases" => {"type" => "array", "items" => {"$ref" => "#/definitions/diseases" }},
              "exclusion_drugs" => {"type" => "array", "items" => {"$ref" => "#/definitions/drug"}},
              "exclusion_criterias" => {"type" => "array", "items" => {"type" => "object", "properties" => {
                  "id" => {"type" => "string", "minLength" => 1},
                  "description" => {"type" => "string", "minLength" => 1}
              }}},
              "assay_results" => {"type" => "array", "items" => {"type" => "object", "properties" => {
                  "gene" => {"anyOf" => [{"type" => "string"}, {"type" => "null"}]},
                  "description" => {"anyOf" => [{"type" => "string"}, {"type" => "null"}]},
                  "level_of_evidence" => {"type" => "number", "multipleOf" => 1.0},
                  "assay_result_status" => {"type" => "string", "enum" => ["POSITIVE", "NEGATIVE", "INDETERMINATE",
                                                                         "PRE_PRESENT", "PRE_NEGATIVE", "PRE_INDETERMINATE"]
                  },
                  "assay_variant" => {"type" => "string", "enum" => ["PRESENT", "NEGATIVE", "EMPTY"]}
              }}},
              "treatment_arm_status" => {"$ref" => "#/definitions/treatment_arm_status" },
              "status_log" => {"type" => "object", "properties" => {
                  "id" => {"type" => "number"},
                  "treatment_arm_status" => {"$ref" => "#/definitions/treatment_arm_status" }
              }}
          }
      }
    end
  end
end