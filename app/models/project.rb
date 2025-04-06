class Project < ApplicationRecord
  belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'
  has_many :project_membership, dependent: :destroy
  has_many :users, through: :project_memberships
  has_many :comments, dependent: :destroy
  has_many :project_histories, -> { order(created_at: :desc) }, dependent: :destroy

  enum :status, {
    planning: 'planning',
    in_progress: 'in_progress',
    in_review: 'in_review',
    completed: 'completed'
  }, default: :planning

  before_update :register_status_change, if: :status_changed?

  private

  def register_status_change
    StatusChange.create!(
      project: self,
      user: Current.user,
      old_status: self.status_was,
      new_status: self.status
    )
  end
end
