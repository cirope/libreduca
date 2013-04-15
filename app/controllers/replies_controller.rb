class RepliesController < ApplicationController
  before_filter :authenticate_user!
  
  check_authorization
  load_and_authorize_resource :question
  load_and_authorize_resource through: :question

  layout ->(controller) { controller.request.xhr? ? false : 'application' }
  
  # GET /questions/1/replies
  # GET /questions/1/replies.json
  def index
    @title = t('view.replies.index_title')
    @replies = @replies.page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @replies }
    end
  end

  # GET /questions/1/replies/1
  # GET /questions/1/replies/1.json
  def show
    @title = t('view.replies.show_title')

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @reply }
      format.js   # show.js.erb
    end
  end

  # GET /questions/1/replies/new
  # GET /questions/1/replies/new.json
  def new
    @title = t('view.replies.new_title')

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @reply }
    end
  end

  # GET /questions/1/replies/1/edit
  def edit
    @title = t('view.replies.edit_title')
  end

  # POST /questions/1/replies
  # POST /questions/1/replies.json
  def create
    @title = t('view.replies.new_title')
    @reply.user_id = current_user.id

    respond_to do |format|
      if @reply.save
        format.html { redirect_to [@question, @reply], notice: t('view.replies.correctly_created') }
        format.json { render json: @reply, status: :created, location: @reply }
        format.js   # create.js.erb
      else
        format.html { render action: 'new' }
        format.json { render json: @reply.errors, status: :unprocessable_entity }
        format.js   # create.js.erb
      end
    end
  end

  # PUT /questions/1/replies/1
  # PUT /questions/1/replies/1.json
  def update
    @title = t('view.replies.edit_title')

    respond_to do |format|
      if @reply.update_attributes(params[:reply])
        format.html { redirect_to [@question, @reply], notice: t('view.replies.correctly_updated') }
        format.json { head :ok }
        format.js   # update.js.erb
      else
        format.html { render action: 'edit' }
        format.json { render json: @reply.errors, status: :unprocessable_entity }
        format.js   # update.js.erb
      end
    end
  rescue ActiveRecord::StaleObjectError
    redirect_to edit_question_reply_url(@question, @reply), alert: t('view.replies.stale_object_error')
  end

  # GET /questions/1/replies/1/dashboard
  def dashboard
    @title = t('view.replies.dashboard_title')
  end
end
