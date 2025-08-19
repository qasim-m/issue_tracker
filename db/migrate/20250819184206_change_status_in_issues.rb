class ChangeStatusInIssues < ActiveRecord::Migration[8.0]
  def change
    change_column :issues, :status, :integer, default: 0, null: false
  end
end
