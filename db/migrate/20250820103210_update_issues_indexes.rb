class UpdateIssuesIndexes < ActiveRecord::Migration[8.0]
  def change
    # Change column types
    change_column :issues, :created_by, :bigint, null: false
    change_column :issues, :assigned_to, :bigint

    # Add foreign keys only if not already present
    add_foreign_key :issues, :users, column: :created_by unless foreign_key_exists?(:issues, :users, column: :created_by)
    add_foreign_key :issues, :users, column: :assigned_to unless foreign_key_exists?(:issues, :users, column: :assigned_to)

    # Remove old indexes (safe with if_exists: true)
    remove_index :issues, name: "index_issues_on_issue_number", if_exists: true
    remove_index :issues, name: "index_issues_on_assigned_to", if_exists: true
    remove_index :issues, name: "index_issues_on_created_by", if_exists: true # optional

    # Add new composite indexes
    add_index :issues, [:project_id, :issue_number], unique: true, name: "index_issues_on_project_and_number"
    add_index :issues, [:project_id, :status], name: "index_issues_on_project_and_status"
    add_index :issues, [:project_id, :assigned_to], name: "index_issues_on_project_and_assignee"
  end
end
