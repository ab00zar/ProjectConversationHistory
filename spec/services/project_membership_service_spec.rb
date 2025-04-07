RSpec.describe ProjectMembershipService do
  describe '.add_members_to_project' do
    subject { described_class.add_members_to_project(project, user_ids) }

    let(:project) { Project.create!(name: 'Test Project', owner: User.create!(email: 'owner@example.com', password: 'password123')) }
    let(:user1) { User.create!(email: 'user1@test.com', password: 'password123') }
    let(:user2) { User.create!(email: 'user2@test.com', password: 'password123') }
    let(:user3) { User.create!(email: 'user3@test.com', password: 'password123') }

    context 'when we provide valid user IDs' do
      let(:user_ids) { [user1.id, user2.id] }

      it 'should successfully add the new members to the project' do
        expect { subject }.to change(project.project_memberships, :count).by(2)
        expect(project.users).to include(user1, user2)
        expect(subject[:success]).to be true
        expect(subject[:added_count]).to eq(2)
      end

      context 'and one of the users is already a member' do
        before { project.project_memberships.create(user: user1) }
        let(:user_ids) { [user1.id, user2.id] }

        it 'should add only the new member to the project' do
          expect { subject }.to change(project.project_memberships, :count).by(1)
          expect(project.users).to include(user1, user2)
          expect(subject[:success]).to be true
          expect(subject[:added_count]).to eq(1)
        end
      end

      context 'and we provide a mix of existing and new members' do
        before { project.project_memberships.create(user: user1) }
        let(:user_ids) { [user1.id, user2.id, user3.id] }

        it 'should add only the new members to the project' do
          expect { subject }.to change(project.project_memberships, :count).by(2)
          expect(project.users).to include(user1, user2, user3)
          expect(subject[:success]).to be true
          expect(subject[:added_count]).to eq(2)
        end
      end
    end

    context 'when adding members causes a database error' do
      let(:user_ids) { [user1.id] }

      before do
        allow(User).to receive(:find_by).and_raise(StandardError, 'Database error')
      end

      it 'should log the error and return a generic failure message' do
        expect(Rails.logger).to receive(:error).with(/Error adding members to project #{project.id}: Database error/)
        expect { subject }.not_to change(project.project_memberships, :count)
        expect(project.users).to be_empty
        expect(subject[:success]).to be false
        expect(subject[:error]).to eq("An error occurred while adding members!")
      end
    end
  end
end
