class ProjectMembershipService
  def self.add_members_to_project(project, user_ids)
    added_count = 0
    user_ids.each do |user_id|
      user = User.find_by(id: user_id)
      if user && !project.users.include?(user)
        project.project_memberships.create(user: user)
        added_count += 1
      end
    end

    if added_count > 0
      {
        success: true,
        added_count: added_count
      }
    else
      {
        success: false,
        error: "No new members were added!"
      }
    end
  rescue StandardError => e
    Rails.logger.error "Error adding members to project #{project.id}: #{e.message}"
    {
      success: false,
      error: "An error occurred while adding members!"
    }
  end
end
