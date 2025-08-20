class ChangeProjectsTitleNotNull < ActiveRecord::Migration[8.0]
  def change
    change_column_null :projects, :title, false
  end
end
