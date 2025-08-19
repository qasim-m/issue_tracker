class CreateIssues < ActiveRecord::Migration[8.0]
  def change
    create_table :issues do |t|
      t.integer :issue_number
      t.integer :status
      t.text :description
      t.string :title
      t.references :project, null: false, foreign_key: true
      t.integer :created_by
      t.integer :assigned_to

      t.timestamps
    end
  end
end
