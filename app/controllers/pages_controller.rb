class PagesController < ApplicationController
  layout ->(controller) { controller.request.xhr? ? false : 'application' }

  before_filter :load_resources, only: [:show]

  def show
    @title = "#{current_institution.name}"

    respond_to do |format|
      format.html
    end
  end

  private

  def load_resources
    @page = current_institution.page || current_institution.create_page
  end
end
