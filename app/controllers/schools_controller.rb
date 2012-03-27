class SchoolsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :load_regions, only: [:new, :create, :edit, :update]
  
  check_authorization
  load_and_authorize_resource
  
  # GET /schools
  # GET /schools.json
  def index
    @title = t 'view.schools.index_title'
    @searchable = true
    @schools = @schools.filtered_list(params[:q]).page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @schools }
    end
  end

  # GET /schools/1
  # GET /schools/1.json
  def show
    @title = t 'view.schools.show_title'

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @school }
    end
  end

  # GET /schools/new
  # GET /schools/new.json
  def new
    @title = t 'view.schools.new_title'

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @school }
    end
  end

  # GET /schools/1/edit
  def edit
    @title = t 'view.schools.edit_title'
  end

  # POST /schools
  # POST /schools.json
  def create
    @title = t 'view.schools.new_title'

    respond_to do |format|
      if @school.save
        format.html { redirect_to @school, notice: t('view.schools.correctly_created') }
        format.json { render json: @school, status: :created, location: @school }
      else
        format.html { render action: 'new' }
        format.json { render json: @school.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /schools/1
  # PUT /schools/1.json
  def update
    @title = t 'view.schools.edit_title'

    respond_to do |format|
      if @school.update_attributes(params[:school])
        format.html { redirect_to @school, notice: t('view.schools.correctly_updated') }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @school.errors, status: :unprocessable_entity }
      end
    end
    
  rescue ActiveRecord::StaleObjectError
    flash.alert = t 'view.schools.stale_object_error'
    redirect_to edit_user_url(@user)
  end

  # DELETE /schools/1
  # DELETE /schools/1.json
  def destroy
    @school.destroy

    respond_to do |format|
      format.html { redirect_to schools_url }
      format.json { head :no_content }
    end
  end
  
  private
  
  def load_regions
    @regions = Region.includes(:districts)
  end
end
