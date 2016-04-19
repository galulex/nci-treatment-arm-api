module AmoiUtil
  class Amoi

    def self.is_amoi?(patient_variant, treatment_arm_variant)
      return false if patient_variant.blank? || treatment_arm_variant.blank?
      return false if treatment_arm_variant[:gene].blank? && treatment_arm_variant[:exon].blank? &&
                      treatment_arm_variant[:function].blank? && treatment_arm_variant[:oncominevariantclass].blank?

      proteinMatch = treatment_arm_variant[:protein_match].blank?
      if (!proteinMatch)
        proteinMatch = match(patient_variant[:protein], treatment_arm_variant[:protein_match])
      end



      match(patient_variant[:gene],treatment_arm_variant[:gene]) &&
      match(patient_variant[:exon], treatment_arm_variant[:exon]) &&
      match(patient_variant[:function],treatment_arm_variant[:function]) &&
      proteinMatch &&
      (match(patient_variant[:oncominevariantclass], treatment_arm_variant[:oncominevariantclass]) || match(patient_variant[:identifier], treatment_arm_variant[:identifier]))
    end

    def self.has_comment?(variant=self)
      return false if variant.blank?
      !variant[:metadata].blank?
    end


    def self.match(variable, variable2=self)
      return false if variable.nil? || variable2.nil?
      (variable.to_s).casecmp(variable2.to_s) == 0
    end

    def self.get_number_screened_patients_with_amoi(patient_variants, treatment_arm_variants)

      patient_amoi_count = 0

      treatment_arm_variants.each do | treatment_arm_variant |
        next if treatment_arm_variant[:variant_report].blank?
        treatment_arm_variant[:variant_report].each_key do | key |
          next if treatment_arm_variant[:variant_report][key].blank?
          next if patient_variants[:variant_report][key].blank?
          treatment_arm_variant[:variant_report][key].each do | treatment_variant |
            next if treatment_variant[:inclusion].blank? || treatment_variant[:inclusion] == false
            patient_variants[:variant_report][key].each do | patient_variant |
              patient_amoi_count += 1 if is_amoi?(patient_variant, treatment_variant)
            end
          end
        end
      end
      patient_amoi_count
    end



  end
end