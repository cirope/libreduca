class DashboardController < ApplicationController
  before_action :authenticate_user!, :load_institution_job, :validate_action

  def index
    if @job
      flash.keep

      redirect_to action: @job.job
    else
      raise 'You have no job here =)'
    end
  end

  def headmaster
    @title = t 'view.dashboard.generic_title'
    @grades = current_institution.grades

    respond_to do |format|
      format.html # janitor.html.erb
      format.json { render json: @grades }
    end
  end

  def janitor
    @title = t 'view.dashboard.generic_title'
    @grades = current_institution.grades

    respond_to do |format|
      format.html # janitor.html.erb
      format.json { render json: @grades }
    end
  end

  def student
    @title = t 'view.dashboard.generic_title'

    respond_to do |format|
      format.html # student.html.erb
      format.json { render json: current_enrollments }
    end
  end

  def teacher
    @title = t 'view.dashboard.generic_title'

    respond_to do |format|
      format.html # teacher.html.erb
      format.json { render json: current_enrollments }
    end
  end

  private

  def load_institution_job
    @job = current_user.jobs.in_institution(current_institution).first
  end

  def validate_action
    raise 'You can not do this =)' if ['index', @job.job].exclude?(action_name)
  end
end
