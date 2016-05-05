require 'spec_helper'

describe User do

  context "should create valid basic treatment arm model" do

    let(:user) do
      stub_model User,
                 :user_id => "user1",
                 :password_digest => "831y4ahdjfhhuhadaf"

    end

    it "recieved from db" do
      ba = mock_model("User")
      ba = user
      expect(ba.user_id).to eq("user1")
      expect(ba.password_digest).to eq("831y4ahdjfhhuhadaf")
    end
  end

end