class ImagesController < ApplicationController
  layout ->(controller) { controller.request.xhr? ? false : 'application' }
  
  before_filter :authenticate_user!
  
  check_authorization
  load_and_authorize_resource through: :current_institution

  # GET /images
  # GET /images.json
  def index
    @title = t('view.images.index_title')
    @images = @images.page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @images }
    end
  end

  # GET /images/1
  # GET /images/1.json
  def show
    @title = t('view.images.show_title')

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @image }
    end
  end

  # GET /images/new
  # GET /images/new.json
  def new
    @title = t('view.images.new_title')

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @image }
    end
  end

  # GET /images/1/edit
  def edit
    @title = t('view.images.edit_title')
  end

  # POST /images
  # POST /images.json
  def create
    @title = t('view.images.new_title')

    respond_to do |format|
      if @image.save
        format.html { redirect_to @image, notice: t('view.images.correctly_created') }
        format.json { render json: @image, status: :created, location: @image }
        format.js   # create.js.erb
      else
        format.html { render action: 'new' }
        format.json { render json: @image.errors, status: :unprocessable_entity }
        format.js   # create.js.erb
      end
    end
  end

  # PUT /images/1
  # PUT /images/1.json
  def update
    @title = t('view.images.edit_title')

    respond_to do |format|
      if @image.update_attributes(params[:image])
        format.html { redirect_to @image, notice: t('view.images.correctly_updated') }
        format.json { head :ok }
      else
        format.html { render action: 'edit' }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  rescue ActiveRecord::StaleObjectError
    redirect_to edit_image_url(@image), alert: t('view.images.stale_object_error')
  end

  # DELETE /images/1
  # DELETE /images/1.json
  def destroy
    @image.destroy

    respond_to do |format|
      format.html { redirect_to images_url }
      format.json { head :ok }
    end
  end
end
