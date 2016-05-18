require 'spec_helper'

describe User do

  context "should create valid basic treatment arm model" do

    let(:user) do
       user_data = User.new
       user_data.user_id = "user1"
       user_data.password_digest = "831y4ahdjfhhuhadaf"
      user_data
    end

    it "recieved from db" do
      ba = user
      expect(ba.user_id).to eq("user1")
      expect(ba.password_digest).to eq("831y4ahdjfhhuhadaf")
    end

    it "should take the correct data type" do
      ba = user
      expect(ba.user_id).to be_kind_of(String)
      expect(ba.password_digest).to be_kind_of(String)
    end
  end

end