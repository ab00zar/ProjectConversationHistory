RSpec.describe StatusChange, type: :model do
  describe 'associations' do
    it { should belong_to(:project) }
    it { should belong_to(:user) }
    it { should have_one(:project_history).dependent(:destroy) }
  end

  describe 'module' do
    it 'includes HasProjectHistory' do
      expect(StatusChange.ancestors).to include(HasProjectHistory)
    end
  end

  describe 'creation' do
    let(:user) { User.create!(email: 'test@example.com', password: 'password123') }
    let(:project) { Project.create!(name: 'Test Project', owner: user) }
    let(:subject) { described_class.new(project: project, user: user, old_status: 'planning', new_status: 'in_progress') }

    it 'creates a project history after creation' do
      expect { subject.save! }.to change(ProjectHistory, :count).by(1)
      expect(ProjectHistory.last.contentable).to eq(subject)
      expect(ProjectHistory.last.project).to eq(project)
      expect(ProjectHistory.last.user).to eq(user)
    end
  end
end
