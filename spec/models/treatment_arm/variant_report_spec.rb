require 'spec_helper'

describe VariantReport do

  it { is_expected.to embed_many(:single_nucleotide_variants).of_type(SingleNucleotideVariant) }
  it { is_expected.to embed_many(:indels).of_type(Indel) }
  it { is_expected.to embed_many(:copy_number_variants).of_type(CopyNumberVariant) }
  it { is_expected.to embed_many(:gene_fusions).of_type(GeneFusion) }
  it { is_expected.to embed_many(:unified_gene_fusions).of_type(UnifiedGeneFusion) }
  it { is_expected.to embed_many(:non_hotspot_rules).of_type(NonHotspotRule) }

  it { is_expected.to have_field(:created_date).of_type(DateTime) }

  it { is_expected.to be_embedded_in(:treatmentarm).as_inverse_of(:variant_report) }

end