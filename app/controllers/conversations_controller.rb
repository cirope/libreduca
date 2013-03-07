class ConversationsController < ApplicationController
  before_filter :authenticate_user!
  
  check_authorization
  load_and_authorize_resource :presentation

  before_filter :set_conversable

  load_and_authorize_resource through: :conversable, singleton: true

  layout ->(controller) { controller.request.xhr? ? false : 'application' }

  # GET /conversations
  # GET /conversations.json
  def index
    @title = t('view.conversations.index_title')
    @conversations = @conversations.page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @conversations }
    end
  end

  # GET /conversations/1
  # GET /conversations/1.json
  def show
    @title = t('view.conversations.show_title')

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @conversation }
      format.js   # show.js.erb
    end
  end

  # GET /conversations/new
  # GET /conversations/new.json
  def new
    @title = t('view.conversations.new_title')

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @conversation }
      format.js   # new.js.erb
    end
  end

  # GET /conversations/1/edit
  def edit
    @title = t('view.conversations.edit_title')
  end

  # POST /conversations
  # POST /conversations.json
  def create
    @title = t('view.conversations.new_title')
    @conversation.comments.first.user = current_user if @conversation.comments.present?

    respond_to do |format|
      if @conversation.save
        [current_user, @conversable.user].each { |user| @conversation.participants.create(user: user) }

        format.html { redirect_to @conversation, notice: t('view.conversations.correctly_created') }
        format.json { render json: @conversation, status: :created, location: @conversation }
        format.js
      else
        format.html { render action: 'new' }
        format.json { render json: @conversation.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  # PUT /conversations/1
  # PUT /conversations/1.json
  def update
    @title = t('view.conversations.edit_title')

    respond_to do |format|
      if @conversation.update_attributes(params[:conversation])
        format.html { redirect_to @conversation, notice: t('view.conversations.correctly_updated') }
        format.json { head :ok }
      else
        format.html { render action: 'edit' }
        format.json { render json: @conversation.errors, status: :unprocessable_entity }
      end
    end
  rescue ActiveRecord::StaleObjectError
    redirect_to edit_conversation_url(@conversation), alert: t('view.conversations.stale_object_error')
  end

  # DELETE /conversations/1
  # DELETE /conversations/1.json
  def destroy
    @conversation.destroy

    respond_to do |format|
      format.html { redirect_to conversations_url }
      format.json { head :ok }
    end
  end

  private

  def set_conversable
    @conversable = @presentation
  end
end
