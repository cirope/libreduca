class PagesController < ApplicationController
  before_filter :load_resources, only: [:show]
  before_filter :authenticate_user!, except: [:show]

  check_authorization except: [:show]
  load_and_authorize_resource except: [:show]

  layout ->(controller) { controller.request.xhr? ? false : 'application' }

  def show
    @title = "#{@institution.name}"

    respond_to do |format|
      format.html
    end
  end

  private

  def load_resources
    @institution = current_institution
    @page = current_institution.pages.first_or_create!
    @blockable = @page.blocks
  end
end
