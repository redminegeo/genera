require_dependency 'issues_controller'

class IssuesController
  prepend_before_filter :set_eraser

  private
  def set_eraser
    if params[:eraser_id]
      eraser = Eraser.find(params[:eraser_id]) rescue nil
      if eraser
        params.merge!(eraser.content)
      end
    end
    true
  end
end

