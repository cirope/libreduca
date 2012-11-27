class ForumsController < ApplicationController
  before_filter :authenticate_user!
  
  check_authorization
  load_and_authorize_resource :institution
  load_and_authorize_resource :teach
  load_and_authorize_resource through: [:institution, :teach]

  before_filter :set_owner

  layout ->(controller) { controller.request.xhr? ? false : 'application' }
  
  # GET /forums
  # GET /forums.json
  def index
    @title = t('view.forums.index_title')
    @searchable = true
    @forums = @forums.filtered_list(params[:q]).page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @forums }
    end
  end

  # GET /forums/1
  # GET /forums/1.json
  def show
    @title = t('view.forums.show_title')

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @forum }
    end
  end

  # GET /forums/new
  # GET /forums/new.json
  def new
    @title = t('view.forums.new_title')

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @forum }
    end
  end

  # GET /forums/1/edit
  def edit
    @title = t('view.forums.edit_title')
  end

  # POST /forums
  # POST /forums.json
  def create
    @title = t('view.forums.new_title')
    @forum.user = current_user

    respond_to do |format|
      if @forum.save
        Notifier.delay.new_forum(@forum, current_institution)

        format.html { redirect_to [@owner, @forum], notice: t('view.forums.correctly_created') }
        format.json { render json: @forum, status: :created, location: [@owner, @forum] }
      else
        format.html { render action: 'new' }
        format.json { render json: @forum.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /forums/1
  # PUT /forums/1.json
  def update
    @title = t('view.forums.edit_title')

    respond_to do |format|
      if @forum.update_attributes(params[:forum])
        format.html { redirect_to [@owner, @forum], notice: t('view.forums.correctly_updated') }
        format.json { head :ok }
      else
        format.html { render action: 'edit' }
        format.json { render json: @forum.errors, status: :unprocessable_entity }
      end
    end
  rescue ActiveRecord::StaleObjectError
    redirect_to edit_polymorphic_url([@owner, @forum]), alert: t('view.forums.stale_object_error')
  end

  # DELETE /forums/1
  # DELETE /forums/1.json
  def destroy
    @forum.destroy

    respond_to do |format|
      format.html { redirect_to polymorphic_path([@owner, Forum]) }
      format.json { head :ok }
    end
  end

  # GET /forums/1/comments
  # GET /forums/1/comments.json
  def comments
    @comments = @forum.comments

    respond_to do |format|
      format.json { render json: @comments }
    end
  end

  # POST /forums/1/comments
  # POST /forums/1/comments.json
  def create_comment
    @comment = @forum.comments.build(params[:comment])
    @comment.user = current_user

    respond_to do |format|
      if @comment.save
        jobs = current_user.jobs.in_institution(current_institution)

        Notifier.delay.new_comment(@comment, current_institution) unless jobs.all?(&:student?)

        format.html { render partial: 'comment', locals: { comment: @comment } }
        format.json { render json: @comment, status: :created, location: [@owner, @forum] }
      else
        format.html { render partial: 'new_comment', locals: { comment: @comment } }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_owner
    @owner = @institution || @teach
  end
end
