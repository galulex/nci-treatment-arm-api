describe Ability, type: :model do
  it 'can create empty object' do
    expect(Ability.new).to_not be nil
  end

  describe 'should handle roles correctly' do
    it 'should not allow management when blank' do
      expect(Ability.new.can?(:manage, :all)).to eq(false)
    end

    it 'should allow System to manage all' do
      expect(Ability.new(roles: ['SYSTEM']).can?(:manage, :all)).to eq(true)
    end
  end
end
