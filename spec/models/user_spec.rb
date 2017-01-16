
describe User, type: :model do
  it 'can create empty object' do
    expect(User.new).to_not be nil
  end

  it 'has function has_secure_password' do
    expect(User.respond_to?(:has_secure_password)).to eq(true)
  end
end
