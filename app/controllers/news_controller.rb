class NewsController < ApplicationController
  before_filter :authenticate_user!

  check_authorization
  load_and_authorize_resource through: :current_institution

  respond_to :html, :js, :json, except: [:create, :update]

  layout ->(controller) { controller.request.xhr? ? false : 'application' }

  # GET /news
  # GET /news.json
  def index
    @title = t('view.news.index_title')
    @news = @news.page(params[:page]).uniq('id')
  end

  # GET /news/1
  # GET /news/1.json
  def show
    @title = t('view.news.show_title')
  end

  # GET /news/new
  # GET /news/new.json
  def new
    @title = t('view.news.new_title')
  end

  # GET /news/1/edit
  def edit
    @title = t('view.news.edit_title')
  end

  # POST /news
  # POST /news.json
  def create
    @title = t('view.news.new_title')

    respond_to do |format|
      if @news.save
        format.html { redirect_to @news, notice: t('view.news.correctly_created') }
        format.js
      else
        format.html { render action: 'new' }
        format.js
      end
    end
  end

  # PUT /news/1
  # PUT /news/1.json
  def update
    @title = t('view.news.edit_title')

    respond_to do |format|
      if @news.update_attributes(params[:news])
        format.html { redirect_to @news, notice: t('view.news.correctly_updated') }
        format.js
      else
        format.html { render action: 'edit' }
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
  end
end
