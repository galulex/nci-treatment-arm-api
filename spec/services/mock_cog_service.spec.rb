require 'rails_helper'
require 'httparty/response'
require 'httparty/request'

describe MockCogService do
  it "Should call Mock COG when the actual COG is down or wan't able to connect" do
    allow(HTTParty::Request).to receive(:new).and_return(HTTParty::Request)
    allow(HTTParty::Response).to receive(:new).and_return(HTTParty::Response)
    allow(HTTParty::Request).to receive(:perform).and_return(HTTParty::Response)
    allow(HTTParty::Response).to receive(:code).and_return(200)
    expect(MockCogService.perform).to be_truthy
  end

  it 'should raise exception when unable to connect to Mock COG' do
    allow(HTTParty::Request).to receive(:new).and_return(HTTParty::Request)
    allow(HTTParty::Response).to receive(:new).and_return(HTTParty::Response)
    allow(HTTParty::Request).to receive(:perform).and_return(HTTParty::Response)
    allow(HTTParty::Response).to receive(:code).and_return(500)
    allow(MockCogService.perform).to receive(:scan).and_raise('this error')
  end
end
