class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :project
  has_one :project_history, as: :contentable, inverse_of: :contentable, dependent: :destroy
end
