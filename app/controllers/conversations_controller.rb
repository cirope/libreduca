class ConversationsController < ApplicationController
  before_filter :authenticate_user!
  
  check_authorization
  load_and_authorize_resource :presentation

  before_filter :set_conversable

  load_and_authorize_resource through: :conversable, singleton: true

  layout ->(controller) { controller.request.xhr? ? false : 'application' }

  # GET /conversations/1
  # GET /conversations/1.json
  def show
    @title = t('view.conversations.show_title')

    @conversation.visited_by(current_user)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @conversation }
    end
  end

  # GET /conversations/new
  # GET /conversations/new.json
  def new
    @title = t('view.conversations.new_title')

    @commentable = @conversation 

    unless @conversable.conversation
      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @conversation }
      end
    else
      redirect_to polymorphic_url([@conversable, @conversable.conversation])
    end
  end

  # POST /conversations
  # POST /conversations.json
  def create
    @title = t('view.conversations.new_title')

    @commentable = @conversation
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

  private

  def set_conversable
    @conversable = @presentation
  end
end
