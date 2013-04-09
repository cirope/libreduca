class CommentsController < ApplicationController
  before_filter :authenticate_user!
  
  check_authorization
  load_and_authorize_resource :forum, shallow: true
  load_and_authorize_resource :news, shallow: true
  load_and_authorize_resource :presentation, shallow: true

  before_filter :set_commentable
  before_filter :set_comment_anchor, only: :index 

  load_and_authorize_resource through: :commentable

  layout ->(controller) { controller.request.xhr? ? false : 'application' }
  
  # GET /comments
  # GET /comments.json
  def index
    @title = t('view.comments.index_title')
    @comments = @comments.page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @comments }
      format.js   # index.js.erb
    end
  end

  # POST /comments
  # POST /comments.json
  def create
    @title = t('view.comments.new_title')
    @comment.user = current_user

    respond_to do |format|
      if @comment.save
        users = @commentable.users_to_notify(current_user, current_institution).to_a.uniq

        Notifier.delay.new_comment(@comment, current_institution, users) unless users.empty?

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
    @commentable = @forum || @news || @presentation
  end

  def set_comment_anchor
    @comment_anchor = Comment.find(params[:show_comment_id]) if params[:show_comment_id].present?
  end
end
