
describe User, type: :model do
  it 'can create empty object' do
    expect(User.new).to_not be nil
  end

  it 'has function has_secure_password' do
    expect(User.respond_to?(:has_secure_password)).to eq(true)
  end

  it 'responds to from_token_payload' do
    expect(User.from_token_payload(email: 'test@nih.gov', roles: 'SuperUSER', sub: 'random-sub')).to be_truthy
    expect(User.from_token_payload(email: 'test@nih.gov', roles: 'SuperUSER', sub: 'random-sub')).to eq(email: 'test@nih.gov', roles: 'SuperUSER', sub: 'random-sub')
  end
end
