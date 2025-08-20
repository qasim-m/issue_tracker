class CleanupIssuesIndexes < ActiveRecord::Migration[8.0]
  def change
    remove_index :issues, name: "index_issues_on_project_id", if_exists: true
  end
end
