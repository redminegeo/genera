class ChangeAssignedsAndIssues < ActiveRecord::Migration
  def change
  	add_column :issues, :is_deleted, :boolean
  	add_column :issues, :deleted_user, :integer
  	change_column_default	:issues, :is_deleted, false
	change_column_default :assigneds, :is_deleted, false
  end
end
