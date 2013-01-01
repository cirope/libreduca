class CommentsController < ApplicationController
  before_filter :authenticate_user!
  
  check_authorization
  load_and_authorize_resource :forum
  load_and_authorize_resource through: [:forum]

  before_filter :set_commentable

  layout ->(controller) { controller.request.xhr? ? false : 'application' }
  
  # GET /comments
  # GET /comments.json
  def index
    @title = t('view.comments.index_title')
    @comments = @comments.page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @comments }
    end
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
    @title = t('view.comments.show_title')

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @comment }
    end
  end

  # GET /comments/new
  # GET /comments/new.json
  def new
    @title = t('view.comments.new_title')

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @comment }
    end
  end

  # GET /comments/1/edit
  def edit
    @title = t('view.comments.edit_title')
  end

  # POST /comments
  # POST /comments.json
  def create
    @title = t('view.comments.new_title')
    @comment.user = current_user

    respond_to do |format|
      if @comment.save
        jobs = current_user.jobs.in_institution(current_institution)

        Notifier.delay.new_comment(@comment, current_institution) unless jobs.all?(&:student?)

        format.html { redirect_to [@commentable, @comment], notice: t('view.comments.correctly_created') }
        format.json { render json: @comment, status: :created, location: @comment }
        format.js   # create.js.erb
      else
        format.html { render action: 'new' }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
        format.js   # create.js.erb
      end
    end
  end

  # PUT /comments/1
  # PUT /comments/1.json
  def update
    @title = t('view.comments.edit_title')

    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        format.html { redirect_to [@commentable, @comment], notice: t('view.comments.correctly_updated') }
        format.json { head :ok }
      else
        format.html { render action: 'edit' }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  rescue ActiveRecord::StaleObjectError
    redirect_to edit_comment_url(@comment), alert: t('view.comments.stale_object_error')
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to polymorphic_url([@commentable, Comment]) }
      format.json { head :ok }
    end
  end

  private

  def set_commentable
    @commentable = @forum
  end
end
