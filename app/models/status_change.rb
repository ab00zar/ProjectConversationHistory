class StatusChange < ApplicationRecord
  belongs_to :project
  belongs_to :user
  has_one :project_history, as: :cotentable, inverse_of: :contentable, dependent: :destroy

  after_create :create_project_history

  private

  def create_project_history
    ProjectHistory.create!(
      project: project,
      user: user,
      contentable: self
    )
  end
end
