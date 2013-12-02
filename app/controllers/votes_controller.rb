class VotesController < ApplicationController
  before_filter :authenticate_user!

  check_authorization
  load_and_authorize_resource :news, shallow: true
  load_and_authorize_resource :comment, shallow: true

  before_filter :set_votable

  load_and_authorize_resource through: :votable

  layout ->(controller) { controller.request.xhr? ? false : 'application' }

  # POST /votes
  # POST /votes.json
  def create

    # Test issues
    @vote.user = current_user

    respond_to do |format|
      if @vote.save
        @vote.votable.reload

        format.json { render json: @vote, status: :created, location: @vote }
        format.js
      else
        format.json { render json: @vote.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  # DELETE /votes/1
  # DELETE /votes/1.json
  def destroy
    @vote.destroy
    @vote.votable.reload

    respond_to do |format|
      format.json { head :no_content }
      format.js
    end
  end

  private

    def vote_params
      params.require(:vote).permit(:lock_version)
    end

    def set_votable
      @votable = @news || @comment
    end
end
