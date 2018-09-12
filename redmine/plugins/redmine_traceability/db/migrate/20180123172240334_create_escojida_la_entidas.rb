class CreateEscojidaLaEntidas < ActiveRecord::Migration
  def change
    create_table :escojida_la_entidas, force: true do |t|
      t.string :name, null: true
      t.timestamps null: false
    end
  end
end
