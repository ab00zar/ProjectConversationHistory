RSpec.describe ProjectMembership, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:project) }
  end

  describe 'validations' do
    subject { described_class.create!(
      user: User.create!(email: 'user@example.com', password: 'password123'),
      project: Project.create!(name: 'Project 1', owner: User.create!(email: 'owner@example.com', password: 'password123')))
    }
    it { should validate_uniqueness_of(:user_id).scoped_to(:project_id) }
  end
end
