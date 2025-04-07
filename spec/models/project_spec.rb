RSpec.describe Project, type: :model do
  describe 'associations' do
    it { should belong_to(:owner).class_name('User').with_foreign_key('owner_id') }
    it { should have_many(:project_memberships).dependent(:destroy) }
    it { should have_many(:users).through(:project_memberships) }
    it { should have_many(:comments).dependent(:destroy) }
    it { should have_many(:project_histories).order(created_at: :desc).dependent(:destroy) }
  end

  describe 'callbacks' do
    let(:owner) { User.create!(email: 'owner@example.com', password: 'password123') }
    let(:subject) { described_class.create!(name: 'Test Project', owner: owner, status: :planning) }
    let(:user) { User.create!(email: 'user@example.com', password: 'password123') }

    before { Current.user = user }
    after { Current.user = nil }

    it 'creates a status change before update if status changes' do
      expect {
        subject.update!(status: :in_progress)
      }.to change(StatusChange, :count).by(1)
      expect(StatusChange.last.project).to eq(subject)
      expect(StatusChange.last.user).to eq(user)
      expect(StatusChange.last.old_status).to eq('planning')
      expect(StatusChange.last.new_status).to eq('in_progress')
    end

    it 'does not create a status change if status does not change' do
      expect {
        subject.update!(name: 'New Name!')
      }.not_to change(StatusChange, :count)
    end
  end
end
