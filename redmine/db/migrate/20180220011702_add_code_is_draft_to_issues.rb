class AddCodeIsDraftToIssues < ActiveRecord::Migration
  def change
    add_column :issues, :is_draft, :Boolean,:null => false, :default => false
  end
end
