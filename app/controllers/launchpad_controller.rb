class LaunchpadController < ApplicationController
  before_action :authenticate_user!

  def index
    @title = t 'view.launchpad.index_title'
    @institutions = current_user.institutions

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @institutions }
    end
  end
end
