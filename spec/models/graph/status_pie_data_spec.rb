

describe StatusPieData do

  let(:status_pie_data) do
    stub_model StatusPieData,
               :_id => "EAY131-A",
               :status_array => []
  end


  it "recieved from db" do
    ba = mock_model("StatusPieData")
    ba = status_pie_data
    expect(ba._id).to eq("EAY131-A")
    expect(ba.status_array).to eq([])
  end

end