class AssignedsController < ApplicationController

  accept_api_auth :create, :destroy
  
  # GET /assigneds
  #def index
  #  @assigneds = Assigned.all
  #end

  # GET /assigneds/1
  #def show
  #end

  # GET /assigneds/new
  def new
    @users_for_assigned = users_for_new_assigned
    respond_to do |format| 
      format.js
    end
  end

  # POST /assigneds/1/remove
  def remove
    ActiveRecord::Base.connection.execute("UPDATE assigneds SET deleted_user="+User.current.id.to_s+",deleted_at=current_timestamp,is_deleted = true WHERE id="+params[:assigned]+";")
    @issue = Issue.find(params[:issue])
    respond_to do |format|
      format.js 
    end
  end

  #begin POST /assigneds
  def create
    user_ids = []
    if params[:assigned].is_a?(Hash)
      user_ids << (params[:assigned][:user_ids] || params[:assigned][:user_id])
    else
      user_ids << params[:user_id]
    end
    @users = User.active.visible.where(:id => user_ids.flatten.compact.uniq)
    respond_to do |format|
      format.js 
    end
  end

  def append
    if params[:assigned].is_a?(Hash)
      user_ids = params[:assigned][:user_ids] || [params[:assigned][:user_id]]
      @users = User.active.visible.where(:id => user_ids.flatten.compact.uniq)+Group.active.visible.where(:id => user_ids.flatten.compact.uniq)
    end
    if @users.blank?
      render :nothing => true
    end
  end

  # PATCH/PUT /assigneds/1
  #def update
  #  if @assigned.update(assigned_params)
  #    redirect_to @assigned, notice: 'assigned was successfully updated.'
  #  else
  #    render :edit
  #  end
  #end

  def autocomplete_for_assigned
    @users_for_assigned = users_for_new_assigned
    render :layout => false
  end

  private

    # Only allow a trusted parameter "white list" through.
    def assigned_params
      params.require(:assigned).permit(:assigned, :issue, :user_id, :issue_id, :project_id)
    end

    def users_for_new_assigned
      scope = nil
      @project = Project.find(params[:project_id])
      scope = @project.assignable_users
      users = scope.active.visible.sorted.like(params[:q]).to_a
      users
    end
end
