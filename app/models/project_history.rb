class ProjectHistory < ApplicationRecord
  belongs_to :project
  belongs_to :user
  belongs_to :contentable, polymorphic: true, inverse_of: :project_history
end
