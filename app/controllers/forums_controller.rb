class ForumsController < ApplicationController
  before_action :authenticate_user!

  check_authorization
  load_and_authorize_resource :institution
  load_and_authorize_resource :teach
  load_and_authorize_resource through: [:institution, :teach]

  before_action :set_owner
  before_action :set_comment_anchor, only: :show

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
        Notifier.delay.new_forum(@forum, current_institution) unless @forum.users.empty?

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
      if @forum.update(forum_params)
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
      format.html { redirect_to polymorphic_url([@owner, Forum]) }
      format.json { head :ok }
    end
  end

  private
    def forum_params
      params.require(:forum).permit(:name, :topic, :info, :lock_version)
    end

    def set_owner
      @owner = @institution || @teach
    end

    def set_comment_anchor
      @comment_anchor = Comment.find(params[:show_comment_id]) if params[:show_comment_id].present?
    end
end
