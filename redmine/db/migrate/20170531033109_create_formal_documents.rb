class CreateFormalDocuments < ActiveRecord::Migration
  def change
    create_table :formal_documents do |t|
      t.integer :issue_id, null: false
      t.integer :journal_id, null: false
      t.text :content_html, null: false
      t.string :filename, null: false
      t.integer :author_id, null: false
      t.boolean :is_signatured, null: false,default: false
      t.boolean :is_deleted, null: false,default: false
      t.integer :deleted_user
      t.integer :created_user, null: false

      t.timestamps null: false
    end
    add_index :formal_documents, :issue_id
    add_index :formal_documents, :journal_id
    add_index :formal_documents, :filename
    add_index :formal_documents, :author_id
    add_index :formal_documents, :is_signatured
  end
end
