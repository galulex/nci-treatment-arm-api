
describe DiseasePieData do

  let(:disease_pie_data) do
    stub_model DiseasePieData,
               :_id => "EAY131-A",
               :disease_array => []
  end


  it "recieved from db" do
    ba = mock_model("DiseasePieData")
    ba = disease_pie_data
    expect(ba._id).to eq("EAY131-A")
    expect(ba.disease_array).to eq([])
  end

end