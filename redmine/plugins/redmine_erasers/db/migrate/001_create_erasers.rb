class CreateErasers < ActiveRecord::Migration
  def self.up
    create_table :erasers do |t|
      t.column :element_type, :string
      t.column :element_id, :integer
      t.column :user_id, :integer
      t.column :content, :text
      t.timestamps null: false
    end
  end

  def self.down
    drop_table :erasers
  end
end
