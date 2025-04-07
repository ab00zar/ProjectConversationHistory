RSpec.describe Comment, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:project) }
    it { should have_one(:project_history).dependent(:destroy) }
  end

  describe 'modules' do
    it 'includes HasProjectHistory' do
      expect(Comment.ancestors).to include(HasProjectHistory)
    end
  end

  describe 'creation' do
    let(:user) { User.create!(email: 'test@example.com', password: 'password123') }
    let(:project) { Project.create!(name: 'Test Project', owner: user) }
    let(:comment) { Comment.new(user: user, project: project, body: 'Test comment') }

    it 'creates a project history after creation' do
      expect { comment.save! }.to change(ProjectHistory, :count).by(1)
      expect(ProjectHistory.last.contentable).to eq(comment)
      expect(ProjectHistory.last.project).to eq(project)
      expect(ProjectHistory.last.user).to eq(user)
    end
  end
end
