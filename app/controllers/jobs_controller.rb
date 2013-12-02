class JobsController < ApplicationController
  before_filter :authenticate_user!

  check_authorization
  load_resource :user
  load_and_authorize_resource through: :user

  layout ->(controller) { controller.request.xhr? ? false : 'application' }

  def create
    @title = t 'view.jobs.created'

    respond_to do |format|
      if @job.save
        format.html { redirect_to @user, notice: t('view.jobs.correctly_created') }
        format.json { render json: @job, status: :created, location: @job }
      else
        format.html { redirect_to edit_user_path(@user), notice: t('view.jobs.error_message') }
      end
    end
  end

  private

    def job_params
      params.require(:job).permit(:job, :description, :user_id, :institution_id, :auto_institution_name, :lock_version)
    end
end
