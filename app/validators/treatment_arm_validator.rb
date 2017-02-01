# Validations for the TreatmentArm JSON
module TreatmentArmValidator
  class << self
    attr_reader :schema

    def schema
      @schema = {
        'definitions' => {
          'drug' => {
            'type' => 'object',
            'required' => ['name', 'drug_id'],
            'properties' => {
              'drug_id' => { 'type' => 'string', 'minLength' => 1 },
              'name' => { 'type' => 'string', 'minLength' => 1  }
            }
          },
          'treatment_arm_status' => {
            'type' => 'string',
            'enum' => %w(OPEN SUSPENDED CLOSED),
            'required' => ['enum']
          },
          'diseases' => {
            'type' => 'object',
            'required' => ['disease_code', 'exclusion'],
            'properties' => {
              'disease_code_type' => { 'anyOf' => [{ 'type' => 'string' }, { 'type' => 'null' }] },
              'disease_code' => { 'type' => 'string' },
              'disease_name' => { 'anyOf' => [{ 'type' => 'string' }, { 'type' => 'null' }] },
              'exclusion' => { 'type' => 'boolean' }
            }
          },
          'rules' => {
            'type' => 'object',
            'required' => ['type', 'assay_result_status', 'gene', 'assay_variant', 'level_of_evidence'],
            'properties' => {
              'assay_result_status' => { 'type' => 'string', 'enum' => %w(POSITIVE NEGATIVE INDETERMINATE
                                                                          PRE_PRESENT PRE_NEGATIVE PRE_INDETERMINATE)
                                               },
              'gene' => { 'type' => 'string' },
              'level_of_evidence' => { 'type' => 'number', 'minimum' => 0, 'maximum' => 100, 'exclusiveMinimum' => true }
            }
          },
          'genes' => {
            'type' => 'object',
            'required' => ['identifier', 'inclusion', 'level_of_evidence', 'variant_type'],
            'properties' => {
              'variant_type' => { 'type' => 'string', 'enum' => ['fusion'], 'required' => ['enum'] },
              'gene' => { 'anyOf' => [{ 'type' => 'string' }, { 'type' => 'null' }] },
              'identifier' => { 'type' => 'string' },
              'protein' => { 'anyOf' => [{ 'type' => 'string' }, { 'type' => 'null' }] },
              'level_of_evidence' => { 'type' => 'number', 'minimum' => 0, 'maximum' => 100, 'exclusiveMinimum' => true },
              'chromosome' => { 'anyOf' => [{ 'type' => 'string' }, { 'type' => 'null' }] },
              'position' => { 'anyOf' => [{ 'type' => 'string' }, { 'type' => 'null' }] },
              'ocp_reference' => { 'anyOf' => [{ 'type' => 'string' }, { 'type' => 'null' }] },
              'ocp_alternative' => { 'anyOf' => [{ 'type' => 'string' }, { 'type' => 'null' }] },
              'inclusion' => { 'type' => 'boolean' },
              'public_med_ids' => { 'anyOf' => [{ 'type' => 'array' }, { 'type' => 'null' }] },
              'arm_specific' => { 'anyOf' => [{ 'type' => 'boolean' }, { 'type' => 'null' }] }
            }
          },
          'hotspotrules' => {
            'type' => 'object',
            'required' => ['inclusion', 'level_of_evidence'],
            'properties' => {
              'inclusion' => { 'type' => 'boolean' },
              'description' => { 'anyOf' => [{ 'type' => 'string' }, { 'type' => 'null' }] },
              'oncomine_variant_class' => { 'type' => 'string' },
              'public_med_ids' => { 'anyOf' => [{ 'type' => 'array' }, { 'type' => 'null' }] },
              'func_gene' => { 'type' => 'string' },
              'arm_specific' => { 'type' => 'boolean' },
              'level_of_evidence' => { 'type' => 'number', 'minimum' => 0, 'maximum' => 100, 'exclusiveMinimum' => true },
              'function' => { 'type' => 'string' },
              'exon' => { 'type' => 'string' }
            }
          },
          'snv_indels' => {
            'type' => 'object',
            'required' => ['identifier', 'inclusion', 'level_of_evidence', 'variant_type'],
            'properties' => {
              'variant_type' => { 'type' => 'string', 'enum' => %w(snp del ins complex mnp), 'required' => ['enum'] },
              'gene' => { 'anyOf' => [{ 'type' => 'string' }, { 'type' => 'null' }] },
              'identifier' => { 'type' => 'string' },
              'chromosome' => { 'anyOf' => [{ 'type' => 'string' }, { 'type' => 'null' }] },
              'position' => { 'anyOf' => [{ 'type' => 'string' }, { 'type' => 'null' }] },
              'protein' => { 'anyOf' => [{ 'type' => 'string' }, { 'type' => 'null' }] },
              'level_of_evidence' => { 'type' => 'number', 'minimum' => 0, 'maximum' => 100, 'exclusiveMinimum' => true },
              'public_med_ids' => { 'anyOf' => [{ 'type' => 'array' }, { 'type' => 'null' }] },
              'ocp_reference' => { 'anyOf' => [{ 'type' => 'string' }, { 'type' => 'null' }] },
              'ocp_alternative' => { 'anyOf' => [{ 'type' => 'string' }, { 'type' => 'null' }] },
              'inclusion' => { 'type' => 'boolean' },
              'arm_specific' => { 'anyOf' => [{ 'type' => 'boolean' }, { 'type' => 'null' }] },
              'property' => { 'type' => 'string' },
            }
          },
          'cnvs' => {
            'type' => 'object',
            'required' => ['identifier', 'inclusion', 'level_of_evidence', 'variant_type'],
            'properties' => {
              'variant_type' => { 'type' => 'string', 'enum' => ['cnv'], 'required' => ['enum'] },
              'gene' => { 'anyOf' => [{ 'type' => 'string' }, { 'type' => 'null' }] },
              'identifier' => { 'type' => 'string' },
              'chromosome' => { 'anyOf' => [{ 'type' => 'string' }, { 'type' => 'null' }] },
              'position' => { 'anyOf' => [{ 'type' => 'string' }, { 'type' => 'null' }] },
              'protein' => { 'anyOf' => [{ 'type' => 'string' }, { 'type' => 'null' }] },
              'level_of_evidence' => { 'type' => 'number', 'minimum' => 0, 'maximum' => 100, 'exclusiveMinimum' => true },
              'public_med_ids' => { 'anyOf' => [{ 'type' => 'array' }, { 'type' => 'null' }] },
              'ocp_reference' => { 'anyOf' => [{ 'type' => 'string' }, { 'type' => 'null' }] },
              'ocp_alternative' => { 'anyOf' => [{ 'type' => 'string' }, { 'type' => 'null' }] },
              'inclusion' => { 'type' => 'boolean' },
              'arm_specific' => { 'anyOf' => [{ 'type' => 'boolean' }, { 'type' => 'null' }] }
            }
          },
          'edrugs' => {
            'type' => 'object',
            'required' => ['drug_id', 'name'],
            'properties' => {
              'name' => { 'type' => 'string', 'minLength' => 1 },
              'drug_id' => { 'type' => 'string', 'minLength' => 1 },
              'drug_class' => { 'anyOf' => [{ 'type' => 'string' }, { 'type' => 'null' }] },
              'target' => { 'anyOf' => [{ 'type' => 'string' }, { 'type' => 'null' }] }
            }
          }
        },
        'type' => 'object',
        'required' => ['name', 'version', 'treatment_arm_id', 'stratum_id', 'treatment_arm_drugs', 'study_id', 'date_created'],
        'properties' => {
          'name' => { 'type' => 'string', 'not' => { 'type' => 'null' } },
          'study_id' => { 'type' => 'string', 'not' => { 'type' => 'null' }, 'enum' => ['APEC1621'], 'required' => ['enum'] },
          'active' => { 'type' => 'boolean', 'not' => { 'type' => 'null' } },
          'treatment_arm_id' => { 'type' => 'string', 'not' => { 'type' => 'null' } },
          'date_created' => { 'type' => 'string', 'not' => { 'type' => 'null' } },
          'version' => { 'type' => 'string', 'not' => { 'type' => 'null' } },
          'stratum_id' => { 'type' => 'string', 'not' => { 'type' => 'null' } },
          'treatment_arm_drugs' => { 'type' => 'array', 'not' => { 'type' => 'null' }, 'minItems' => 1, 'uniqueItems' => 'drug_id', 'items' => { '$ref' => '#/definitions/drug' } },
          'description' => { 'anyOf' => [{ 'type' => 'string' },{ 'type' => 'null' }] },
          'target_id' => { 'anyOf' => [{ 'type' => 'string' }, { 'type' => 'number' }, { 'type' => 'null' }] },
          'target_name' => { 'type' => 'string' },
          'gene' => { 'anyOf' => [{ 'type' => 'string' },{ 'type' => 'null' }] },
          'snv_indels' => { 'type' => 'array', 'uniqueItems' => 'identifier', 'items' => { '$ref' => '#/definitions/snv_indels' } },
          'copy_number_variants' => { 'type' => 'array', 'uniqueItems' => 'identifier', 'items' => { '$ref' => '#/definitions/cnvs' } },
          'diseases' => { 'type' => 'array', 'items' => { '$ref' => '#/definitions/diseases' } },
          'assay_rules' => { 'anyOf' => [{ 'type' => 'array' },{ 'type' => 'null' }], 'items' => { '$ref' => '#/definitions/rules' } },
          'gene_fusions' => { 'type' => 'array', 'uniqueItems' => 'identifier', 'items' => { '$ref' => '#/definitions/genes' } },
          'non_hotspot_rules' => { 'type' => 'array', 'items' => { '$ref' => '#/definitions/hotspotrules' } },
          'exclusion_drugs' => { 'type' => 'array', 'uniqueItems' => 'drug_id', 'items' => { '$ref' => '#/definitions/edrugs' } },
          'exclusion_criterias' => { 'type' => 'array',
            'items' => { 'type' => 'object',
              'properties' => {
                'id' => { 'type' => 'string', 'minLength' => 1 },
                'description' => { 'type' => 'string', 'minLength' => 1 }
              }
            }
          },
          'status_log' => { 'type' => 'object',
            'properties' => {
              'id' => { 'type' => 'number' },
              'treatment_arm_status' => { '$ref' => '#/definitions/treatment_arm_status' }
            }
          }
        }
      }
    end
  end
end
