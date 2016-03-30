
FactoryGirl.define do

  factory :copy_number_variant_amoi, :class => CopyNumberVariant, parent: :confirmable_variant do
    refCopyNumber 10.1
    rawCopyNumber 7.5
    copyNumber 2.5
    confidenceInterval95percent 0.87
    confidenceInterval5percent 0.96
  end

end