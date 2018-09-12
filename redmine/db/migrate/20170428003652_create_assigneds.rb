class CreateAssigneds < ActiveRecord::Migration
  def change
    create_table :assigneds do |t|
      t.references :user, index: true, foreign_key: true
      t.references :issue, index: true, foreign_key: true
      t.boolean :is_deleted
      t.integer :created_user
      t.timestamp :created_at
      t.integer :updated_user
      t.timestamp :updated_at
      t.integer :deleted_user
      t.timestamp :deleted_at
    end
  end
end
