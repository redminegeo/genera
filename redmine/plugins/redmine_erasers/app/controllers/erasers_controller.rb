class ErasersController < ApplicationController
  unloadable
  
  before_filter :require_login

  def autosave
    #Redmine 2.1.x had params[:notes] while Redmine 2.2.x moved it to
    #params[:issue][:notes] when introducing private notes. We want to
    #support both formats so we need to save and restore at both places.
    params[:issue] ||= {}
    params[:notes] = params[:issue][:notes] if params[:notes].blank?
    params[:issue][:notes] = params[:notes] if params[:issue][:notes].blank?
    #decide whether the record should be saved
    has_to_be_saved = !params[:notes].blank?
    has_to_be_saved ||= (params[:issue_id].to_i == 0 && !params[:issue][:subject].blank?)
    #if so, save it!
    if request.xhr? && has_to_be_saved
      @eraser = Eraser.find_or_create_for_issue(:user_id => User.current.id,
                                              :element_id => params[:issue_id].to_i)
      new_content = params.reject{|k,v| !%w(issue notes).include?(k)}
      unless @eraser.content == new_content
        @eraser.content = new_content
        if @eraser.save
          render :partial => "saved", :layout => false
        else
          render :text => "Error saving eraser"
        end
      end
    end
    render :nothing => true unless performed?
  end

  def restore
    @eraser = Eraser.find_by_id(params[:id])
    if @eraser.blank? || @eraser.element_id == 0
      redirect_to({:controller => "issues", :action => "new", :project_id => params[:project_id].to_i, :eraser_id => @eraser})
    else
      redirect_to({:controller => "issues", :action => "edit", :id => @eraser.element_id, :eraser_id => @eraser})
    end
  end
  
  def destroy
    @eraser = Eraser.find_by_id(params[:id])
    @eraser.destroy if @eraser.present?
    respond_to do |format|
       format.js
     end
  end
end
