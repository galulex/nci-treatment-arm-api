require 'spec_helper'

describe VariantReport do

  it { is_expected.to embed_many(:singleNucleotideVariants).of_type(SingleNucleotideVariant) }
  it { is_expected.to embed_many(:indels).of_type(Indel) }
  it { is_expected.to embed_many(:copyNumberVariants).of_type(CopyNumberVariant) }
  it { is_expected.to embed_many(:geneFusions).of_type(GeneFusion) }
  it { is_expected.to embed_many(:unifiedGeneFusions).of_type(UnifiedGeneFusion) }
  it { is_expected.to embed_many(:nonHotspotRules).of_type(NonHotspotRule) }

  it { is_expected.to have_field(:createdDate).of_type(DateTime) }

  it { is_expected.to be_embedded_in(:treatmentarm).as_inverse_of(:variantReport) }

end