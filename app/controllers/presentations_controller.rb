class PresentationsController < ApplicationController
  layout ->(controller) { controller.request.xhr? ? false : 'application' }

  before_filter :authenticate_user!

  check_authorization
  load_resource :content
  load_resource :homework, through: :content, shallow: true
  load_and_authorize_resource through: [:homework, :content]


  # GET /presentations
  # GET /presentations.json
  def index
    @title = t 'view.presentations.index_title'

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @presentations }
    end
  end

  # GET /presentations/1
  # GET /presentations/1.json
  def show
    @title = t 'view.presentations.show_title'

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @presentation }
    end
  end

  # GET /presentations/new
  # GET /presentations/new.json
  def new
    @title = t 'view.presentations.new_title'

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @presentation }
    end
  end

  # POST /presentations
  # POST /presentations.json
  def create
    @title = t 'view.presentations.new_title'
    @presentation.user = current_user

    respond_to do |format|
      if @presentation.save
        format.html { redirect_to [@content.teach, @content], notice: t('view.presentations.correctly_created') }
        format.json { render json: @presentation, status: :created, location: @presentation }
        format.js   { flash.now.notice = t('view.presentations.correctly_created') } # create.js.erb
      else
        format.html { render action: 'new' }
        format.json { render json: @presentation.errors, status: :unprocessable_entity }
        format.js   # create.js.erb
      end
    end
  end

  # DELETE /presentations/1
  # DELETE /presentations/1.json
  def destroy
    @presentation.destroy

    respond_to do |format|
      format.html { redirect_to [@content.teach, @content] }
      format.json { head :ok }
    end
  end

  private

    def presentation_params
      params.require(:presentation).permit(:file, :file_cache, :lock_version)
    end
end
