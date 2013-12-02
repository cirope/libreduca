class GroupsController < ApplicationController
  before_filter :authenticate_user!

  check_authorization
  load_and_authorize_resource through: :current_institution, shallow: true

  layout ->(controller) { controller.request.xhr? ? false : 'application' }

  # GET /groups
  # GET /groups.json
  def index
    @title = t('view.groups.index_title')
    @searchable = true
    @groups = @groups.filtered_list(params[:q]).page(params[:page]).uniq('id')

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @groups }
    end
  end

  # GET /groups/new
  # GET /groups/new.json
  def new
    @title = t('view.groups.new_title')

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @content }
    end
  end


  # GET /groups/1
  # GET /groups/1.json
  def show
    @title = t('view.groups.show_title')

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @content }
    end
  end

  # POST /groups
  # POST /groups.json
  def create
    @title = t 'view.groups.created'

    respond_to do |format|
      if @group.save
        format.html { redirect_to @group, notice: t('view.groups.correctly_created') }
        format.json { render json: @group, status: :created, location: @group }
      else
        format.html { render action: 'new', notice: t('view.groups.error_message') }
      end
    end
  end

  # PUT /groups/1
  # PUT /groups/1.json
  def update
    @title = t 'view.groups.edit_title'

    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to @group, notice: t('view.groups.correctly_updated') }
        format.json { head :ok }
      else
        format.html { render action: 'edit' }
        format.json { render json: @groups.errors, status: :unprocessable_entity }
      end
    end
  rescue ActiveRecord::StaleObjectError
    redirect_to edit_group_path(@group), alert: t('view.groups.stale_object_error')
  end

  # GET /groups/1/edit
  def edit
    @title = t('view.groups.edit_title')
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    @group.destroy

    respond_to do |format|
      format.html { redirect_to groups_path }
      format.json { head :ok }
    end
  end

  private

    def group_params
      params.require(:group).permit(
        :name, :institution_id, :enrollable_type,
        memberships_attributes: [:id, :user_id, :_destroy]
      )
    end
end
