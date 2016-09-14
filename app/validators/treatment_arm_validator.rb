module TreatmentArmValidator
  class << self

    attr_reader :schema

    def schema
      @schema = {
          "definitions" => {
              "drug" => {
                  "type" => "object",
                  "required" => ["name", "drug_id"],
                  "properties" => {
                      "drug_id" => {"anyOf" => [{"type" => "string"}, {"type" => "null"}]},
                      "name" => {"type" => "string", "minLength" => 1}
                  }
              },
              "treatment_arm_status" => {
                  "type" => "string",
                  "enum" => ["OPEN", "SUSPENDED", "UNKNOWN", "CLOSED"],
                  "required" => ["enum"]
              },
              "diseases" => {
                  "type" => "object",
                  "required" => ["disease_code", "exclusion"],
                  "properties" => {
                      "_id" => {"type" => "string", "minLength" => 1},
                      "disease_code_type" => {"anyOf" => [{"type" => "string"}, {"type" => "null"}]},
                      "disease_code" => {"type" => "string"},
                      "disease_name" => {"anyOf" => [{"type" => "string"}, {"type" => "null"}]},
                      "exclusion" => {"type" => "boolean"}
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
                      "level_of_evidence" => {"type" => "number"}
                  }
              },
              "genes" => {
                  "type" => "object",
                  "required" => ["identifier", "inclusion", "level_of_evidence"],
                  "properties" => {
                      "gene" => {"anyOf" => [{"type" => "string"}, {"type" => "null"}]},
                      "identifier" => {"type" => "string"},
                      "protein" => {"anyOf" => [{"type" => "string"}, {"type" => "null"}]},
                      "level_of_evidence" => {"type" => "number"},
                      "chromosome" => {"anyOf" => [{"type" => "string"}, {"type" => "null"}]},
                      "position" => {"anyOf" => [{"type" => "string"}, {"type" => "null"}]},
                      "ocp_reference" => {"anyOf" => [{"type" => "string"}, {"type" => "null"}]},
                      "ocp_alternative" => {"anyOf" => [{"type" => "string"}, {"type" => "null"}]},
                      "inclusion" => {"type" => "boolean"},
                      "public_med_ids" => {"anyOf" => [{"type" => "array"}, {"type" => "null"}]},
                      "arm_specific" => {"anyOf" => [{"type" => "boolean"}, {"type" => "null"}]}
                  }
              },
              "hotspotrules" => {
                  "type" => "object",
                  "required" => ["inclusion", "level_of_evidence"],
                  "properties" => {
                      "inclusion" => {"type" => "boolean"},
                      "description" => {"anyOf" => [{"type" => "string"}, {"type" => "null"}]},
                      "oncomine_variant_class" => {"type" => "string"},
                      "public_med_ids" => {"anyOf" => [{"type" => "array"}, {"type" => "null"}]},
                      "func_gene" => {"type" => "string"},
                      "arm_specific" => {"type" => "boolean"},
                      "level_of_evidence" => {"type" => "number"},
                      "function" => {"type" => "string"},
                      "exon" => {"type" => "string"}
                  }
              },
              "snvs" => {
                  "type" => "object",
                  "required" => ["identifier", "inclusion", "level_of_evidence"],
                  "properties" => {
                      "gene" => {"anyOf" => [{"type" => "string"}, {"type" => "null"}]},
                      "identifier" => {"type" => "string"},
                      "protein" => {"anyOf" => [{"type" => "string"}, {"type" => "null"}]},
                      "chromosome" => {"anyOf" => [{"type" => "string"}, {"type" => "null"}]},
                      "position" => {"anyOf" => [{"type" => "string"}, {"type" => "null"}]},
                      "ocp_reference" => {"anyOf" => [{"type" => "string"}, {"type" => "null"}]},
                      "ocp_alternative" => {"anyOf" => [{"type" => "string"}, {"type" => "null"}]},
                      "public_med_ids" => {"anyOf" => [{"type" => "array"}, {"type" => "null"}]},
                      "level_of_evidence" => {"type" => "number"},
                      "inclusion" => {"type" => "boolean"},
                      "arm_specific" => {"anyOf" => [{"type" => "boolean"}, {"type" => "null"}]}
                  }
              },
              "indels" => {
                  "type" => "object",
                  "required" => ["identifier", "inclusion", "level_of_evidence"],
                  "properties" => {
                      "gene" => {"anyOf" => [{"type" => "string"}, {"type" => "null"}]},
                      "identifier" => {"type" => "string"},
                      "chromosome" => {"anyOf" => [{"type" => "string"}, {"type" => "null"}]},
                      "position" => {"anyOf" => [{"type" => "string"}, {"type" => "null"}]},
                      "protein" => {"anyOf" => [{"type" => "string"}, {"type" => "null"}]},
                      "level_of_evidence" => {"type" => "number"},
                      "public_med_ids" => {"anyOf" => [{"type" => "array"}, {"type" => "null"}]},
                      "ocp_reference" => {"anyOf" => [{"type" => "string"}, {"type" => "null"}]},
                      "ocp_alternative" => {"anyOf" => [{"type" => "string"}, {"type" => "null"}]},
                      "inclusion" => {"type" => "boolean"},
                      "arm_specific" => {"anyOf" => [{"type" => "boolean"}, {"type" => "null"}]}
                  }
              },
              "cnvs" => {
                  "type" => "object",
                  "required" => ["identifier", "inclusion", "level_of_evidence"],
                  "properties" => {
                      "gene" => {"anyOf" => [{"type" => "string"}, {"type" => "null"}]},
                      "identifier" => {"type" => "string"},
                      "chromosome" => {"anyOf" => [{"type" => "string"}, {"type" => "null"}]},
                      "position" => {"anyOf" => [{"type" => "string"}, {"type" => "null"}]},
                      "protein" => {"anyOf" => [{"type" => "string"}, {"type" => "null"}]},
                      "level_of_evidence" => {"type" => "number"},
                      "public_med_ids" => {"anyOf" => [{"type" => "array"}, {"type" => "null"}]},
                      "ocp_reference" => {"anyOf" => [{"type" => "string"}, {"type" => "null"}]},
                      "ocp_alternative" => {"anyOf" => [{"type" => "string"}, {"type" => "null"}]},
                      "inclusion" => {"type" => "boolean"},
                      "arm_specific" => {"anyOf" => [{"type" => "boolean"}, {"type" => "null"}]}
                  }
              },
              "edrugs" => {
                  "type" => "object",
                  "required" => ["drug_id", "name"],
                  "properties" => {
                      "name" => {"type" => "string"},
                      "drug_id" => {"type" => "string"},
                      "drug_class" => {"anyOf" => [{"type" => "string"}, {"type" => "null"}]},
                      "target" => {"anyOf" => [{"type" => "string"}, {"type" => "null"}]}
                  }
              }
          },
          "type" => "object",
          "required" => ["name", "version", "id", "stratum_id", "treatment_arm_drugs", "study_id"],
          "properties" => {
              "name" => {"type" => "string", "not" => {"type" => "null"}},
              "study_id" => {"type" => "string", "not" => {"type" => "null"}},
              "active" => {"type" => "boolean", "not" => {"type" => "null"}},
              "id" => {"type" => "string", "not" => {"type" => "null"}},
              "version" => {"type" => "string", "not" => {"type" => "null"}},
              "stratum_id" => {"type" => "string", "not" => {"type" => "null"}},
              "treatment_arm_drugs" => {"type" => "array", "items" => {"$ref" => "#/definitions/drug" }},
              "description" => {"anyOf" => [{"type" => "string"},{"type" => "null"}]},
              "target_id" => {"anyOf" => [{"type" => "string"}, {"type" => "number"}, {"type" => "null"}]},
              "target_name" => {"type" => "string"},
              "gene" => {"anyOf" => [{"type" => "string"},{"type" => "null"}]},
              "single_nucleotide_variants" => {"type" => "array", "items" => { "$ref" => "#/definitions/snvs" }},
              "indels" => {"type" => "array", "items" => { "$ref" => "#/definitions/indels" }},
              "copy_number_variants" => {"type" => "array", "items" => { "$ref" => "#/definitions/cnvs" }},
              "diseases" => {"type" => "array", "items" => { "$ref" => "#/definitions/diseases" }},
              "assay_rules" => {"type" => "array", "items" => { "$ref" => "#/definitions/rules" }},
              "gene_fusions" => {"type" => "array", "items" => { "$ref" => "#/definitions/genes" }},
              "non_hotspot_rules" => {"type" => "array", "items" => { "$ref" => "#/definitions/hotspotrules" }},
              "exclusion_drugs" => {"type" => "array", "items" => { "$ref" => "#/definitions/edrugs" }},
              "exclusion_criterias" => {"type" => "array", "items" => {"type" => "object", "properties" => {
                  "id" => {"type" => "string", "minLength" => 1},
                  "description" => {"type" => "string", "minLength" => 1}
              }}},
              "status_log" => {"type" => "object", "properties" => {
                  "id" => {"type" => "number"},
                  "treatment_arm_status" => { "$ref" => "#/definitions/treatment_arm_status" }
              }}
          }
      }
    end
  end
end
