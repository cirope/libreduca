class ContentsController < ApplicationController
  before_filter :authenticate_user!

  check_authorization
  load_and_authorize_resource :teach
  load_and_authorize_resource through: :teach

  layout ->(controller) { controller.request.xhr? ? false : 'application' }

  # GET /contents
  # GET /contents.json
  def index
    @title = t('view.contents.index_title')
    @searchable = true
    @contents = @contents.filtered_list(params[:q]).page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @contents }
    end
  end

  # GET /contents/1
  # GET /contents/1.json
  def show
    @title = [@teach.course.to_s, @content.to_s].join(' | ')

    @content.visited_by(current_user)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @content }
    end
  end

  # GET /contents/new
  # GET /contents/new.json
  def new
    @title = t('view.contents.new_title')

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @content }
    end
  end

  # GET /contents/1/edit
  def edit
    @title = t('view.contents.edit_title')
  end

  # POST /contents
  # POST /contents.json
  def create
    @title = t('view.contents.new_title')

    respond_to do |format|
      if @content.save
        format.html { redirect_to [@teach, @content], notice: t('view.contents.correctly_created') }
        format.json { render json: @content, status: :created, location: [@teach, @content] }
      else
        format.html { render action: 'new' }
        format.json { render json: @content.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /contents/1
  # PUT /contents/1.json
  def update
    @title = t('view.contents.edit_title')

    respond_to do |format|
      if @content.update_attributes(params[:content])
        format.html { redirect_to [@teach, @content], notice: t('view.contents.correctly_updated') }
        format.json { head :ok }
      else
        format.html { render action: 'edit' }
        format.json { render json: @content.errors, status: :unprocessable_entity }
      end
    end
  rescue ActiveRecord::StaleObjectError
    redirect_to edit_teach_content_url(@teach, @content), alert: t('view.contents.stale_object_error')
  end

  # DELETE /contents/1
  # DELETE /contents/1.json
  def destroy
    @content.destroy

    respond_to do |format|
      format.html { redirect_to_back_or teach_contents_url(@teach) }
      format.json { head :ok }
    end
  end
end
