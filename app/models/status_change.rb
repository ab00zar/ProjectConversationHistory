class StatusChange < ApplicationRecord
  include HasProjectHistory
  belongs_to :project
  belongs_to :user
  has_one :project_history, as: :cotentable, inverse_of: :contentable, dependent: :destroy
end
