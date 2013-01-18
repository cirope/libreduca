class VotesController < ApplicationController
  layout ->(controller) { controller.request.xhr? ? false : 'application' }

  before_filter :authenticate_user!

  check_authorization

  # Array doesn't work?
  load_resource :news, shallow: true
  load_resource :comment, shallow: true

  before_filter :set_votable

  load_and_authorize_resource through: :votable

  # GET /votes/1
  # GET /votes/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @vote }
    end
  end

  # POST /votes
  # POST /votes.json
  def create
    @vote.vote_flag = params[:vote_flag] == 'positive'

    # Test issues
    @vote.user = current_user

    respond_to do |format|
      if @vote.save
        format.html { redirect_to [@votable, @vote], notice: t('view.votes.correctly_created') }
        format.json { render json: @vote, status: :created, location: @vote }
        format.js
      else
        format.html { render action: 'new' }
        format.json { render json: @vote.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  # PUT /votes/1
  # PUT /votes/1.json
  def update
    @vote.vote_flag = params[:vote_flag] == 'positive'

    respond_to do |format|
      if @vote.save
        format.html { redirect_to [@votable, @vote], notice: t('view.votes.correctly_updated') }
        format.json { head :ok }
        format.js
      else
        format.html { render action: 'edit' }
        format.json { render json: @vote.errors, status: :unprocessable_entity }
        format.js
      end
    end
  rescue ActiveRecord::StaleObjectError
    redirect_to edit_vote_url(@vote), alert: t('view.votes.stale_object_error')
  end

  private
  
  def set_votable
    @votable = @news || @comment
  end
end
