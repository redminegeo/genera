module ESCOJIDALaEntidasHelper

  def render_api_escojida_la_entida(api, escojida_la_entida)
    api.escojida_la_entida do
      api.id escojida_la_entida.id
      api.name escojida_la_entida.name
      api.created_at escojida_la_entida.created_at
      api.updated_at escojida_la_entida.updated_at

      call_hook(:helper_render_api_escojida_la_entida, {api: api, escojida_la_entida: escojida_la_entida})
    end
  end

end
