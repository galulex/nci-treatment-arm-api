module TreatmentArmValidator

  class << self

    attr_reader :schema

    def schema
      @schema = {
          "definitions" => {
              "drug" => {
                  "type" => "object",
                  "required" => ["name", "drug_id", "pathway"],
                  "properties" => {
                      "drug_id" => {"anyOf" => [{"type" => "string"}, {"type" => "null"}]},
                      "name" => {"type" => "string", "minLength" => 1},
                      "pathway" => {"anyOf" => [{"type" => "string"}, {"type" => "null"}]},
                      "description" => {"anyOf" => [{"type" => "string"}, {"type" => "null"}]},
                      "drug_class" => {"anyOf" => [{"type" => "string"}, {"type" => "null"}]},
                      "target" => {"anyOf" => [{"type" => "string"}, {"type" => "null"}]},
                  }
              },
              "treatment_arm_status" => {
                  "type" => "string",
                  "enum" => ["OPEN", "SUSPENDED", "UNKNOWN", "CLOSED"],
                  "required" => ["enum"]
              },
              "diseases" => {
                  "type" => "object",
                  "required" => ["disease_code_type", "disease_code", "exclusion"],
                  "properties" => {
                      "_id" => {"type" => "string", "minLength" => 1},
                      "disease_code_type" => {"anyOf" => [{"type" => "string"}, {"type" => "null"}]},
                      "disease_code" => {"anyOf" => [{"type" => "string"}, {"type" => "null"}]},
                      "exclusion" => {"type" => "boolean"},
                      "ctep_sub_category" => {"anyOf" => [{"type" => "string"}, {"type" => "null"}]},
                      "ctep_term" => {"anyOf" => [{"type" => "string"}, {"type" => "null"}]},
                      "ctep_category" => {"anyOf" => [{"type" => "string"}, {"type" => "null"}]},
                      "short_name" => {"anyOf" => [{"type" => "string"}, {"type" => "null"}]}
                  }
              },
              "rules" => {
                  "type" => "object",
                  "required" => ["type", "assay_result_status", "gene", "assay_variant", "level_of_evidence"],
                  "properties" => {
                      "type" => {"type" => "string"},
                      "assay_result_status" => {"type" => "string", "enum" => ["POSITIVE", "NEGATIVE", "INDETERMINATE",
                                                                               "PRE_PRESENT", "PRE_NEGATIVE", "PRE_INDETERMINATE"]
                                               },
                      "gene" => {"anyOf" => [{"type" => "string"}, {"type" => "null"}]},
                      "assay_variant" => {"type" => "string", "enum" => ["PRESENT", "NEGATIVE", "EMPTY"]},
                      "level_of_evidence" => {"type" => "number", "multipleOf" => 1.0}
                  }
              },
              "genes" => {
                  "type" => "object",
                  "required" => ["ocp_reference", "identifier", "inclusion", "level_of_evidence"],
                  "properties" => {
                      "ocp_reference" => {"type" => "string"},
                      "func_gene" => {"type" => "string"},
                      "identifier" => {"type" => "string"},
                      "inclusion" => {"type" => "boolean"},
                      "public_med_ids" => {"anyOf" => [{"type" => "array"}, {"type" => "null"}]},
                      "level_of_evidence" => {"type" => "number", "multipleOf" => 1.0},
                      "chromosome" => {"type" => "string"},
                      "ocp_alternative" => {"type" => "string"},
                      "description" => {"type" => "string"},
                      "position" => {"type" => "string"},
                      "type" => {"type" => "string"}
                  }
              },
              "hotspotrules" => {
                  "type" => "object",
                  "required" => ["inclusion", "oncomine_variant_class", "func_gene", "level_of_evidence", "function",
                                 "protein_match", "exon"],
                  "properties" => {
                      "inclusion" => {"type" => "boolean"},
                      "oncomine_variant_class" => {"type" => "string"},
                      "public_med_ids" => {"type" => "string"},
                      "func_gene" => {"type" => "string"},
                      "arm_specific" => {"type" => "boolean"},
                      "level_of_evidence" => {"type" => "number", "multipleOf" => 1.0},
                      "function" => {"type" => "string"},
                      "protein_match" => {"type" => "string"},
                      "type" => {"type" => "string"},
                      "exon" => {"type" => "string"}
                  }
              },
              "edrugs" => {
                  "type" => "object",
                  "required" => ["drug_id"],
                  "properties" => {
                      "name" => {"type" => "string"},
                      "drug_id" => {"type" => "string"},
                      "drug_class" => {"type" => "string"},
                      "target" => {"type" => "string"}
                  }
              }
          },
          "type" => "object",
          "required" => ["name", "version", "active", "id", "date_created", "stratum_id", "treatment_arm_drugs", "study_id"],
          "properties" => {
              "name" => {"type" => "string", "not" => {"type" => "null"}},
              "active" => {"type" => "boolean", "not" => {"type" => "null"}},
              "id" => {"type" => "string", "not" => {"type" => "null"}},
              "version" => {"type" => "string", "not" => {"type" => "null"}},
              "date_created" => {"type" => "string", "not" => {"type" => "null"}},
              "stratum_id" => {"type" => "string", "not" => {"type" => "null"}},
              "treatment_arm_drugs" => {"type" => "array", "items" => {"$ref" => "#/definitions/drug" }},
              "description" => {"type" => "string"},
              "target_id" => {"anyOf" => [{"type" => "string"}, {"type" => "number"}, {"type" => "null"}]},
              "target_name" => {"type" => "string"},
              "gene" => {"type" => "string"},
              "diseases" => {"type" => "array", "items" => {"$ref" => "#/definitions/diseases" }},
              "assay_rules" => {"type" => "array", "items" => {"$ref" => "#/definitions/rules" }},
              "gene_fusions" => {"type" => "array", "items" => {"$ref" => "#/definitions/genes" }},
              "non_hotspot_rules" => {"type" => "array", "items" => {"$ref" => "#/definitions/hotspotrules" }},
              "exclusion_drugs" => {"type" => "array", "items" => {"$ref" => "#/definitions/edrugs"}},
              "exclusion_criterias" => {"type" => "array", "items" => {"type" => "object", "properties" => {
                  "id" => {"type" => "string", "minLength" => 1},
                  "description" => {"type" => "string", "minLength" => 1}
              }}},
              "treatment_arm_status" => { "$ref" => "#/definitions/treatment_arm_status" },
              "status_log" => {"type" => "object", "properties" => {
                  "id" => {"type" => "number"},
                  "treatment_arm_status" => {"$ref" => "#/definitions/treatment_arm_status" }
              }}
          }
      }
    end
  end
end