class AddCodenToIssues < ActiveRecord::Migration
  def change
    add_column :issues, :code_num, :string
  end
end
