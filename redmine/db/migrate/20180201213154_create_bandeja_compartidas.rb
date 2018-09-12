class CreateBandejaCompartidas < ActiveRecord::Migration
  def change
    create_table :bandeja_compartidas do |t|

      t.timestamps
    end
  end
end
