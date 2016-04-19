
require 'mongoid'
require 'single_nucleotide_variant'
require 'indel'
require 'copy_number_variant'
require 'gene_fusion'
require 'non_hotspot_rule'
require 'unified_gene_fusion'

  class VariantReport
    include Mongoid::Document


    embeds_many :single_nucleotide_variants, class_name: "SingleNucleotideVariant", inverse_of: :variant_report
    embeds_many :indels, class_name: "Indel", inverse_of: :variant_report
    embeds_many :copy_number_variants, class_name: "CopyNumberVariant", inverse_of: :variant_report
    embeds_many :gene_fusions, class_name: "GeneFusion", inverse_of: :variant_report
    embeds_many :unified_gene_fusions, class_name: "UnifiedGeneFusion", inverse_of: :variant_report
    embeds_many :non_hotspot_rules, class_name: "NonHotspotRule", inverse_of: :variant_report

    field :created_date, type: DateTime, default: Time.now


    embedded_in :treatmentarm, inverse_of: :variant_report


    def has_a_inclusion
      if loop_variant(:inclusion, singleNucleotideVariants).include? true
        return true
      elif loop_variant(:inclusion, indels).include? true
        return true
      elsif loop_variant(:inclusion, copyNumberVariants).include? true
        return true
      elsif loop_variant(:inclusion, geneFusions).include? true
        return true
      elsif loop_variant(:inclusion, unifiedGeneFusions).include? true
        return true
      elsif loop_variant(:inclusion, nonHotspotRules).include? true
        return true
      else
        return false
      end
    end


    private

    def loop_variant(attributeName, objects=self)
      objects.collect do | object |
        object.read_attribute(attributeName)
      end
    end


  end