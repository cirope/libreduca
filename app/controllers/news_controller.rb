class NewsController < ApplicationController
  before_filter :authenticate_user!, except: [:index, :show]

  check_authorization
  load_and_authorize_resource :tag, through: :current_institution,
    shallow: true, only: :index

  before_filter :set_news_loader

  load_and_authorize_resource through: :news_loader

  layout ->(c) { c.send(:is_embedded?) ? 'embedded' : 'application' }

  # GET /news
  # GET /news.json
  def index
    @title = t 'view.news.index_title'
    @news = @news.page(params[:page])
    session[:user_return_to] ||= news_index_url unless current_user

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @news }
    end
  end

  # GET /news/1
  # GET /news/1.json
  def show
    @title = t 'view.news.show_title'

    @news.visited_by(current_user) if user_signed_in?

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @news }
    end
  end

  # GET /news/new
  # GET /news/new.json
  def new
    @title = t 'view.news.new_title'

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @news }
    end
  end

  # GET /news/1/edit
  def edit
    @title = t 'view.news.edit_title'
  end

  # POST /news
  # POST /news.json
  def create
    @title = t 'view.news.new_title'

    respond_to do |format|
      if @news.save
        format.html { redirect_to @news, notice: t('view.news.correctly_created') }
        format.json { render json: @news, status: :created, location: @news }
        format.js
      else
        format.html { render action: 'new' }
        format.json { render json: @news.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  # PUT /news/1
  # PUT /news/1.json
  def update
    @title = t 'view.news.edit_title'

    respond_to do |format|
      if @news.update(news_params)
        format.html { redirect_to @news, notice: t('view.news.correctly_updated') }
        format.json { head :ok }
        format.js
      else
        format.html { render action: 'edit' }
        format.json { render json: @news.errors, status: :unprocessable_entity }
        format.js
      end
    end

  rescue ActiveRecord::StaleObjectError
    redirect_to edit_news_url(@news), alert: t('view.news.stale_object_error')
  end

  # DELETE /news/1
  # DELETE /news/1.json
  def destroy
    @news.destroy

    respond_to do |format|
      format.html { redirect_to news_index_url }
      format.json { head :ok }
    end
  end

  private
    def news_params
      params.require(:news).permit(
        :title, :description, :body, :published_at, :lock_version,
        taggings_attributes: [
          :id, :tag_id, :_destroy,
          tag_attributes: [:id, :name, :category, :tagger_type]
        ]
      )
    end

    def set_news_loader
      @news_loader = @tag || current_institution
    end
end
