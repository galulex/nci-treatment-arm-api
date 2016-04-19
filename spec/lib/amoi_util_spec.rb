require 'rails_helper'
require 'factory_girl_rails'
require 'amoi_util'


describe AmoiUtil do
  describe "AmoiUtil should match correctly" do
    context "with valid data" do
      it "should return true" do
        expect(AmoiUtil::Amoi.match("first", "first")).to be true
        expect(AmoiUtil::Amoi.match("FIRST", "first")).to be true
        expect(AmoiUtil::Amoi.match("first", "FIRST")).to be true
        expect(AmoiUtil::Amoi.match("", "")).to be true
      end
    end

    context "with invalid data" do
      it "should return false" do
        expect(AmoiUtil::Amoi.match(nil, "")).to be false
        expect(AmoiUtil::Amoi.match("", nil)).to be false
        expect(AmoiUtil::Amoi.match(nil, nil)).to be false
        expect(AmoiUtil::Amoi.match("false", "true")).to be false
      end
    end
  end


  describe "AmoiUtil should has_comment correctly" do
    context "with valid data" do
      it "should return true" do
        expect(AmoiUtil::Amoi.has_comment?({:metadata => {:comment => "This is a comment" }})).to be true
      end
    end

    context "with invalid data" do
      it "should return false" do
        expect(AmoiUtil::Amoi.has_comment?(nil)).to be false
        expect(AmoiUtil::Amoi.has_comment?({})).to be false
        expect(AmoiUtil::Amoi.has_comment?({:metadata => nil})).to be false
        expect(AmoiUtil::Amoi.has_comment?({:metadata => ""} )).to be false
      end
    end
  end

  describe "AmoiUtil should found an amoi correctly" do
    treatmentVariant = {:gene => "PKT", :exon => "34", :function => "function", :oncominevariantclass => "class"}
    context "with valid data" do

      it "should match patient variant and treatment arm variant" do
        patientVariant = {:gene => "PKT", :exon => "34", :function => "function", :oncominevariantclass => "class"}
        expect(AmoiUtil::Amoi.is_amoi?(patientVariant, treatmentVariant)).to be true
      end

      it "should match patient variant and treatment arm variant with identifier is present" do
        patientVariant = {:gene => "PKT", :exon => "34", :function => "function", :oncominevariantclass => "class", :identifier => ""}
        treatmentVariant = {:gene => "PKT", :exon => "34", :function => "function", :oncominevariantclass => "class", :identifier => ""}
        expect(AmoiUtil::Amoi.is_amoi?(patientVariant, treatmentVariant)).to be true
      end

    end

    context "with invalid data" do

      it "should fail because gene doesnt match" do
        patientVariant = {:gene => "TKP", :exon => "34", :function => "function", :oncominevariantclass => "class"}
        expect(AmoiUtil::Amoi.is_amoi?(patientVariant, treatmentVariant)).to be false
      end

      it "should fail because exon doesnt match" do
        patientVariant = {:gene => "PKT", :exon => "35", :function => "function", :oncominevariantclass => "class"}
        expect(AmoiUtil::Amoi.is_amoi?(patientVariant, treatmentVariant)).to be false
      end

      it "should fail because function doesnt match" do
        patientVariant = {:gene => "PKT", :exon => "34", :function => "", :oncominevariantclass => "class"}
        expect(AmoiUtil::Amoi.is_amoi?(patientVariant, treatmentVariant)).to be false
      end

      it "should fail because oncominevariantclass doesnt match" do
        patientVariant = {:gene => "PKT", :exon => "34", :function => "function", :oncominevariantclass => ""}
        expect(AmoiUtil::Amoi.is_amoi?(patientVariant, treatmentVariant)).to be false
      end

    end
  end

  describe "AmoiUtil should count the correct number of amois" do

    context "with valid data" do

      it "should return 1" do
        treatmentArms = [{:id => "EAY131_A", :variant_report => {:single_nucleotide_variants =>
                                                                    [{:gene => "gene", :exon => "12", :function => "function", :oncominevariantclass => "class", :inclusion => true}],
                                                                 :copy_number_variants => []}}]
        patientVariants = {:psn => "211re", :variant_report => {:single_nucleotide_variants =>
                                                                    [{:gene => "gene", :exon => "12", :function => "function", :oncominevariantclass => "class"}]}}
        expect(AmoiUtil::Amoi.get_number_screened_patients_with_amoi(patientVariants, treatmentArms)).to equal(1)
      end

      it "should return 0 and not fail out" do
        treatmentArms = [{:id => "", :variant_report => {:single_nucleotide_variants => [],
                                                         :copy_number_variants => [],
                                                         :indels => [],
                                                         :nonHotSpotRules => []}}]
        patientVariants = {:psn => "211re", :variant_report => {:single_nucleotide_variants =>
                                                                   [{:gene => "gene", :exon => "12", :function => "function", :oncominevariantclass => "class"}],
                                                                :copy_number_variants => []}}
        expect(AmoiUtil::Amoi.get_number_screened_patients_with_amoi(patientVariants, treatmentArms)).to equal(0)
      end

      it "should return 0 because treatment_arm's inclusion is false" do
        treatmentArms = [{:id => "EAY131_A", :variant_report => {:single_nucleotide_variants =>
                                                                    [{:gene => "gene", :exon => "12", :function => "function", :oncominevariantclass => "class", :inclusion => false}],
                                                                 :copy_number_variants => []}}]
        patientVariants = {:psn => "211re", :variant_report => {:single_nucleotide_variants =>
                                                                   [{:gene => "gene", :exon => "12", :function => "function", :oncominevariantclass => "class"}]}}
        expect(AmoiUtil::Amoi.get_number_screened_patients_with_amoi(patientVariants, treatmentArms)).to equal(0)
      end

      it "should return 2 or more" do
        treatmentArms = [{:id => "EAY131_A", :variant_report => {:single_nucleotide_variants =>
                                                                    [{:gene => "gene", :exon => "12", :function => "function", :oncominevariantclass => "class", :inclusion => true}],
                                                                 :copy_number_variants => [{:gene => "AK123", :exon => "42", :function => "p.dfsaj31", :oncominevariantclass => "oni", :inclusion => true}]}}]
        patientVariants = {:psn => "211re", :variant_report => {:single_nucleotide_variants =>
                                                                   [{:gene => "gene", :exon => "12", :function => "function", :oncominevariantclass => "class"}],
                                                                :copy_number_variants => [{:gene => "AK123", :exon => "42", :function => "p.dfsaj31", :oncominevariantclass => "oni"}]}}
        expect(AmoiUtil::Amoi.get_number_screened_patients_with_amoi(patientVariants, treatmentArms)).to equal(2)
      end

    end

  end

end