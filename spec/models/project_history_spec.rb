RSpec.describe ProjectHistory, type: :model do
  describe 'associations' do
    it { should belong_to(:project) }
    it { should belong_to(:user) }
    it { should belong_to(:project) }
    it { should belong_to(:contentable) }
  end
end
