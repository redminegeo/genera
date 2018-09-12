class ESCOJIDALaEntidasController < ApplicationController

  menu_item :escojida_la_entidas

  before_filter :find_escojida_la_entida, only: [:show, :edit, :update]
  before_filter :find_escojida_la_entidas, only: [:context_menu, :bulk_edit, :bulk_update, :destroy]
  before_filter :authorize_global

  helper :escojida_la_entidas
  helper :custom_fields
  helper :context_menus
  helper :attachments
  helper :issues
  include_query_helpers

  accept_api_auth :index, :show, :create, :update, :destroy

  def index
    index_for_easy_query(ESCOJIDALaEntidaQuery)
  end

  def show
    respond_to do |format|
      format.html
      format.api
      format.js
    end
  end

  def new
    @escojida_la_entida = ESCOJIDALaEntida.new
    @escojida_la_entida.safe_attributes = params[:escojida_la_entida]

    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @escojida_la_entida = ESCOJIDALaEntida.new
    @escojida_la_entida.safe_attributes = params[:escojida_la_entida]

    if @escojida_la_entida.save
      respond_to do |format|
        format.html {
          flash[:notice] = l(:notice_successful_create)
          redirect_back_or_default escojida_la_entida_path(@escojida_la_entida)
        }
        format.api { render action: 'show', status: :created, location: escojida_la_entida_url(@escojida_la_entida) }
        format.js { render template: 'common/close_modal' }
      end
    else
      respond_to do |format|
        format.html { render action: 'new' }
        format.api { render_validation_errors(@escojida_la_entida) }
        format.js { render action: 'new' }
      end
    end
  end

  def edit
    @escojida_la_entida.safe_attributes = params[:escojida_la_entida]

    respond_to do |format|
      format.html
      format.js
    end
  end

  def update
    @escojida_la_entida.safe_attributes = params[:escojida_la_entida]

    if @escojida_la_entida.save
      respond_to do |format|
        format.html {
          flash[:notice] = l(:notice_successful_update)
          redirect_back_or_default escojida_la_entida_path(@escojida_la_entida)
        }
        format.api { render_api_ok }
        format.js { render template: 'common/close_modal' }
      end
    else
      respond_to do |format|
        format.html { render action: 'edit' }
        format.api { render_validation_errors(@escojida_la_entida) }
        format.js { render action: 'edit' }
      end
    end
  end

  def destroy
    @escojida_la_entidas.each do |escojida_la_entida|
      escojida_la_entida.destroy
    end

    respond_to do |format|
      format.html {
        flash[:notice] = l(:notice_successful_delete)
        redirect_back_or_default escojida_la_entidas_path
      }
      format.api { render_api_ok }
    end
  end

  def bulk_edit
  end

  def bulk_update
    unsaved, saved = [], []
    attributes = parse_params_for_bulk_update(params[:escojida_la_entida])
    @escojida_la_entidas.each do |entity|
      entity.init_journal(User.current) if entity.respond_to? :init_journal
      entity.safe_attributes = attributes
      if entity.save
        saved << entity
      else
        unsaved << entity
      end
    end
    respond_to do |format|
      format.html do
        if unsaved.blank?
          flash[:notice] = l(:notice_successful_update)
        else
          flash[:error] = unsaved.map{|i| i.errors.full_messages}.flatten.uniq.join(",\n")
        end
        redirect_back_or_default :index
      end
    end
  end

  def context_menu
    if @escojida_la_entidas.size == 1
      @escojida_la_entida = @escojida_la_entidas.first
    end

    can_edit = @escojida_la_entidas.detect{|c| !c.editable?}.nil?
    can_delete = @escojida_la_entidas.detect{|c| !c.deletable?}.nil?
    @can = {edit: can_edit, delete: can_delete}
    @back = back_url

    @escojida_la_entida_ids, @safe_attributes, @selected = [], [], {}
    @escojida_la_entidas.each do |e|
      @escojida_la_entida_ids << e.id
      @safe_attributes.concat e.safe_attribute_names
      attributes = e.safe_attribute_names - (%w(custom_field_values custom_fields))
      attributes.each do |c|
        column_name = c.to_sym
        if @selected.key? column_name
          @selected[column_name] = nil if @selected[column_name] != e.send(column_name)
        else
          @selected[column_name] = e.send(column_name)
        end
      end
    end

    @safe_attributes.uniq!

    render layout: false
  end

  def autocomplete
  end

  private

  def find_escojida_la_entida
    @escojida_la_entida = ESCOJIDALaEntida.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def find_escojida_la_entidas
    @escojida_la_entidas = ESCOJIDALaEntida.visible.where(id: (params[:id] || params[:ids])).to_a
    @escojida_la_entida = @escojida_la_entidas.first if @escojida_la_entidas.count == 1
    raise ActiveRecord::RecordNotFound if @escojida_la_entidas.empty?
    raise Unauthorized unless @escojida_la_entidas.all?(&:visible?)
    @projects = @escojida_la_entidas.collect(&:project).compact.uniq
    @project = @projects.first if @projects.size == 1
  rescue ActiveRecord::RecordNotFound
    render_404
  end


end
