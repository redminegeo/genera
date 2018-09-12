class BandejaCompartidasController < ApplicationController
	
	def destroy
		@bandeja=BandejaCompartida.find(params[:id])
		@bandeja.update(estado: 0)
		redirect_to '/admin/bc_administracion'
	end

def new
	@bandejaNueva=BandejaCompartida.new
	@users=User.where("status = ?", 1)
end

	def create

bandeja=BandejaCompartida.new(estado: 1 )
bandeja.usr_asistente_id=params[:bandeja_compartida][:usr_asistente]
bandeja.usr_propietario_id=params[:bandeja_compartida][:usr_propietario]
bandeja.save


		redirect_to '/admin/bc_administracion'

	end

end