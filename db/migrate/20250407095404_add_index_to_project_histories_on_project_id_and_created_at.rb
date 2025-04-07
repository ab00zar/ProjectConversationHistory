class AddIndexToProjectHistoriesOnProjectIdAndCreatedAt < ActiveRecord::Migration[8.0]
  def change
    add_index :project_histories, [:project_id, :created_at]
  end
end
