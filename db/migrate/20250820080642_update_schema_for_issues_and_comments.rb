class UpdateSchemaForIssuesAndComments < ActiveRecord::Migration[8.0]
  def change
    # Ensure issue_number is unique and auto-incremented
    change_column :issues, :issue_number, :integer, null: false
    add_index :issues, :issue_number, unique: true

    # Add foreign keys to comments table
    add_foreign_key :comments, :issues unless foreign_key_exists?(:comments, :issues)
    add_foreign_key :comments, :users unless foreign_key_exists?(:comments, :users)

    # Add foreign keys to issues table
    add_foreign_key :issues, :projects unless foreign_key_exists?(:issues, :projects)
    add_foreign_key :issues, :users, column: :created_by unless foreign_key_exists?(:issues, :users, column: :created_by)
    add_foreign_key :issues, :users, column: :assigned_to unless foreign_key_exists?(:issues, :users, column: :assigned_to)

    # Add foreign key to projects table
    add_foreign_key :projects, :users unless foreign_key_exists?(:projects, :users)

    # Add indexes for foreign keys if not already present
    add_index :comments, :issue_id unless index_exists?(:comments, :issue_id)
    add_index :comments, :user_id unless index_exists?(:comments, :user_id)
    add_index :issues, :project_id unless index_exists?(:issues, :project_id)
    add_index :issues, :created_by unless index_exists?(:issues, :created_by)
    add_index :issues, :assigned_to unless index_exists?(:issues, :assigned_to)
    add_index :projects, :user_id unless index_exists?(:projects, :user_id)
  end
end
