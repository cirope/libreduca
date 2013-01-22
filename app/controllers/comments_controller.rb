class CommentsController < ApplicationController
  layout ->(controller) { controller.request.xhr? ? false : 'application' }

  before_filter :authenticate_user!
  
  check_authorization
  load_and_authorize_resource :forum, shallow: true
  load_and_authorize_resource :news, shallow: true

  before_filter :set_commentable

  load_and_authorize_resource through: :commentable
  
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

  # POST /comments
  # POST /comments.json
  def create
    @title = t('view.comments.new_title')
    @comment.user = current_user

    respond_to do |format|
      if @comment.save
        jobs = current_user.jobs.in_institution(current_institution)

        if @commentable.kind_of?(Forum) && !jobs.all?(&:student?)
          Notifier.delay.new_comment(@comment, current_institution)
        end

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

  private

  def set_commentable
    @commentable = @forum || @news
  end
end
