class EnrollmentsController < ApplicationController
  layout ->(controller) { controller.request.xhr? ? false : 'application' }

  before_filter :authenticate_user!

  check_authorization except: [:find_user_or_group]
  load_and_authorize_resource :user, except: [:find_user_or_group]
  load_and_authorize_resource :enrollment, through: :user, except: [:find_user_or_group]

  # POST /users/1/enrollments/1/send_email_summary
  # POST /users/1/enrollments/1/send_email_summary.json
  def send_email_summary
    @enrollment.send_email_summary

    respond_to do |format|
      format.html # send_email_summary.html.erb
      format.json { render json: @enrollment }
    end
  end

  def find_user_or_group
    @enrolled = User.filtered_list(params[:q]).page(params[:page])
    @enrolled = Group.filtered_list(params[:q]).page(params[:page]) if @enrolled.empty?

    respond_to do |format|
      format.json { render json: @enrolled }
    end
  end
end
