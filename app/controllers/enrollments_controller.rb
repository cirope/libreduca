class EnrollmentsController < ApplicationController
  layout ->(controller) { controller.request.xhr? ? false : 'application' }

  before_filter :authenticate_user!

  check_authorization
  load_and_authorize_resource :user
  load_and_authorize_resource :enrollment, through: :user

  # POST /users/1/enrollments/1/send_email_summary
  # POST /users/1/enrollments/1/send_email_summary.json
  def send_email_summary
    @enrollment.send_email_summary

    respond_to do |format|
      format.html # send_email_summary.html.erb
      format.json { render json: @enrollment }
    end
  end
end
