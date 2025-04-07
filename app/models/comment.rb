class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :project
  has_one :project_history, as: :contentable, inverse_of: :contentable, dependent: :destroy

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
