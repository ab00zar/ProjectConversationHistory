module HasProjectHistory
  extend ActiveSupport::Concern

  included do
    after_create :create_project_history
  end

  private

  def create_project_history
    ProjectHistory.create(
      project: project,
      user: user,
      contentable: self
    ) || Rails.logger.error("Failed to create project history for #{self.class.name} #{id}")
  end
end
