module Teaches::Enrollments
  extend ActiveSupport::Concern

  # GET /teaches/1/show_enrollments
  # GET /teaches/1/show_enrollments.json
  def show_enrollments
    @title = t 'view.teaches.show_enrollments_title'

    respond_to do |format|
      format.html # show_enrollments.html.erb
      format.json { render json: @teach }
    end
  end

  # GET /teaches/1/edit_enrollments
  # GET /teaches/1/edit_enrollments.json
  def edit_enrollments
    @title = t 'view.teaches.edit_enrollments_title'

    respond_to do |format|
      format.html # edit_enrollments.html.erb
      format.json { render json: @teach }
    end
  end
end
