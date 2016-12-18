
describe User, type: :model do
  it 'can create empty object' do
    expect(User.new).to_not be nil
  end

  it 'has function has_secure_password' do
    expect(User.respond_to?(:has_secure_password)).to eq(true)
  end

  it 'should not have empty payload' do
    expect(User.from_token_payload 'payload').to be_truthy
    expect(User.from_token_payload 'payload').to_not be_nil
  end
end