class BandejaCompartida < ActiveRecord::Base
	belongs_to :usr_propietario, :class_name => "User"
	belongs_to :usr_asistente, :class_name => "User"
end
