#!/bin/sh

curl -k -X POST -H "Content-Type: application/json" -H "Accept: application/json"  -d '{
  "header": {
    "msg_guid": "0f8fad5b-d9cb-469f-al65-80067728950e",
    "msg_dttm": "2016-05-09T22:06:33+00:00"
  },
  "treatment_arm_id": "APEC1621-A",
  "name": "APEC1621-A",
  "version": "2015-08-06",
  "stratum_id": "100",
  "date_created": "2015-08-06",
  "description": "TEST Treatment Arm used by Cucumber Tests",
  "target_id": "113",
  "target_name": "Crizotinib",
  "gene": "ALK",
  "study_id": "APEC1621SC",
  "assay_rules":[
    {
      "type": "IHC",
      "assay_result_status": "POSITIVE",
      "assay_variant": "PRESENT",
      "gene": "PTEN",
      "level_of_evidence": 3.0
    }
  ],
  "treatment_arm_drugs":[
    {
      "name": "Crizotinib",
      "pathway": "ALK",
      "drug_id": "113"
    }
  ],
  "snv_indels": [
    {
      "position": "30035190",
      "ocp_alternative": "-",
      "gene": "NRAS",
      "protein": "p.Q61H",
      "level_of_evidence": 3.0,
      "ocp_reference": "TTC",
      "variant_type": "snp",
      "chromosome": "chr22",
      "arm_specific": false,
      "identifier": "COSM22189",
      "public_med_ids": [
        "18827604",
        "21917678",
        "23181703"
      ],
      "inclusion": true
    }
  ],
  "non_hotspot_rules":[
    {
      "inclusion": true,
      "oncomine_variant_class": "deleterious",
      "public_med_ids": null,
      "func_gene": "PTEN",
      "domain_name": "iSH2",
      "domain_range": "200-400",
      "arm_specific": false,
      "level_of_evidence":3.0,
      "function": "null",
      "protein_match": null,
      "type": "nhr",
      "exon": "null"
    }
  ],
  "copy_number_variants": [
    {
      "position": "40361592",
      "ocp_alternative": "<CNV>",
      "gene": "MET",
      "protein": null,
      "level_of_evidence": 2.0,
      "ocp_reference": "C",
      "variant_type": "cnv",
      "chromosome": "chr1",
      "identifier": "MET",
      "public_med_ids": [
        "18827604"
      ],
      "arm_specific": false,
      "inclusion": false
    },
    {
      "position": "40361592",
      "ocp_alternative": "<CNV>",
      "gene": "MET",
      "protein": null,
      "level_of_evidence": 2.0,
      "ocp_reference": "C",
      "variant_type": "cnv",
      "chromosome": "chr1",
      "identifier": "POLITAN",
      "public_med_ids": [
        "18827604"
      ],
      "arm_specific": false,
      "inclusion": true
    }
  ],
  "gene_fusions":[
    {
      "variant_type": "fusion",
      "ocp_reference": "A",
      "gene": "ALK",
      "identifier": "TPM3-ALK.T7A20",
      "inclusion": true,
      "public_med_ids": ["23724913"],
      "arm_specific": false,
      "level_of_evidence": 2.0,
      "chromosome": "chr2",
      "ocp_alternative": "[chr1:154142875[A",
      "description": "ALK translocation",
      "position": "29446394"
    }
  ],
  "diseases":[
    {
      "disease_code_type": "ICD-O",
      "disease_code": "9380/3",
      "disease_name": "Glioma, malignant (C71._)\nGlioma, NOS (except Nasal glioma, not neoplastic) (C71._)",
      "exclusion": true
    }
  ],
  "exclusion_drugs":[
    {
      "name": "Doxorubicin Hydrochloride",
      "drug_id": "10001",
      "drug_class": "ALK inhibitor",
      "target": "ALK"
    }
  ] }' http://localhost:10235/api/v1/treatment_arms/APEC1621-A/100/2015-08-06   # This is a sample TreatmentArm JSON File for uploading into the ecosystem