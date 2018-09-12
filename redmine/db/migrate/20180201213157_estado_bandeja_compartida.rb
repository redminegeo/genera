class EstadoBandejaCompartida < ActiveRecord::Migration
  def change
    add_column :bandeja_compartidas, :estado, :integer,:default => 0
  end
end