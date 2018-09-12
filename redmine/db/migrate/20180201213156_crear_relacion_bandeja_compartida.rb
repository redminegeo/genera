class CrearRelacionBandejaCompartida < ActiveRecord::Migration
  def change
    add_column :bandeja_compartidas, :usr_propietario_id, :integer
    add_column :bandeja_compartidas, :usr_asistente_id, :integer
  end
end