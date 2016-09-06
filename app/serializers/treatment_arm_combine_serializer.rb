# This gets rendered when 'single_nucleotide_variants' and 'indels' are passed
 # as the combine_variants query params
 class TreatmentArmCombineSerializer < ActiveModel::Serializer
   attributes  :id, :active, :name, :date_created, :version, :stratum_id,
               :description, :target_id, :target_name, :gene,
               :treatment_arm_status, :study_id, :assay_rules,
               :num_patients_assigned, :total_patients_on_arm,
               :date_opened, :treatment_arm_drugs, :non_hotspot_rules,
               :single_nucleotide_variants_and_indels, :copy_number_variants,
               :gene_fusions, :diseases, :exclusion_drugs, :status_log,
               :stratum_statistics, :version_statistics

   def single_nucleotide_variants_and_indels
     [
       object.single_nucleotide_variants + object.indels
     ]
   end

   def id
     object.name
   end

   def active
     object.is_active_flag == 'true' ? true : false
   end

   def total_patients_on_arm
     0
   end

   def stratum_statistics
     {
       current_patients: object.current_patients,
       former_patients: object.former_patients,
       not_enrolled_patients: object.not_enrolled_patients,
       pending_patients: object.pending_patients
     }
   end

   def version_statistics
     {
       current_patients: object.current_patients,
       former_patients: object.former_patients,
       not_enrolled_patients: object.not_enrolled_patients,
       pending_patients: object.pending_patients
     }
   end
 end