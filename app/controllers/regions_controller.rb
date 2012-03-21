class RegionsController < ApplicationController
  before_filter :authenticate_user!
  
  check_authorization
  load_and_authorize_resource
  
  # GET /regions
  # GET /regions.json
  def index
    @title = t 'view.regions.index_title'
    @searchable = true
    @regions = @regions.filtered_list(params[:q]).page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @regions }
    end
  end

  # GET /regions/1
  # GET /regions/1.json
  def show
    @title = t 'view.regions.show_title'

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @region }
    end
  end

  # GET /regions/new
  # GET /regions/new.json
  def new
    @title = t 'view.regions.new_title'

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @region }
    end
  end

  # GET /regions/1/edit
  def edit
    @title = t 'view.regions.edit_title'
  end

  # POST /regions
  # POST /regions.json
  def create
    @title = t 'view.regions.new_title'

    respond_to do |format|
      if @region.save
        format.html { redirect_to @region, notice: t('view.regions.correctly_created') }
        format.json { render json: @region, status: :created, location: @region }
      else
        format.html { render action: 'new' }
        format.json { render json: @region.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /regions/1
  # PUT /regions/1.json
  def update
    @title = t 'view.regions.edit_title'

    respond_to do |format|
      if @region.update_attributes(params[:region])
        format.html { redirect_to @region, notice: t('view.regions.correctly_updated') }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @region.errors, status: :unprocessable_entity }
      end
    end
  
  rescue ActiveRecord::StaleObjectError
    flash.alert = t 'view.regions.stale_object_error'
    redirect_to edit_user_url(@user)
  end

  # DELETE /regions/1
  # DELETE /regions/1.json
  def destroy
    @region.destroy

    respond_to do |format|
      format.html { redirect_to regions_url }
      format.json { head :no_content }
    end
  end
end
