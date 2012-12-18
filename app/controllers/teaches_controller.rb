class TeachesController < ApplicationController
  layout ->(controller) { controller.request.xhr? ? false : 'application' }
  
  before_filter :authenticate_user!
  
  check_authorization
  load_resource :course
  load_resource :user
  load_and_authorize_resource through: [:course, :user], shallow: true

  before_filter :load_course
  
  # GET /teaches
  # GET /teaches.json
  def index
    @title = t 'view.teaches.index_title'
    @teaches = @teaches.page(params[:page]).uniq('id')
    @teaches = @teaches.in_institution(current_institution) if current_institution
    @teaches = @teaches.historic if @user

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @teaches }
    end
  end

  # GET /teaches/1
  # GET /teaches/1.json
  def show
    @title = t 'view.teaches.show_title'

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @teach }
    end
  end

  # GET /teaches/new
  # GET /teaches/new.json
  def new
    @title = t 'view.teaches.new_title'

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @teach }
    end
  end

  # GET /teaches/1/edit
  def edit
    @title = t 'view.teaches.edit_title'
  end

  # POST /teaches
  # POST /teaches.json
  def create
    @title = t 'view.teaches.new_title'

    respond_to do |format|
      if @teach.save
        format.html { redirect_to @teach, notice: t('view.teaches.correctly_created') }
        format.json { render json: @teach, status: :created, location: @teach }
      else
        format.html { render action: 'new' }
        format.json { render json: @teach.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /teaches/1
  # PUT /teaches/1.json
  def update
    @title = t 'view.teaches.edit_title'

    respond_to do |format|
      if @teach.update_attributes(params[:teach])
        format.html { redirect_to @teach, notice: t('view.teaches.correctly_updated') }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @teach.errors, status: :unprocessable_entity }
      end
    end
    
  rescue ActiveRecord::StaleObjectError
    flash.alert = t 'view.teaches.stale_object_error'
    redirect_to edit_teach_url(@teach)
  end

  # DELETE /teaches/1
  # DELETE /teaches/1.json
  def destroy
    @teach.destroy

    respond_to do |format|
      format.html { redirect_to course_teaches_url(@course) }
      format.json { head :no_content }
    end
  end
  
  # POST /teaches/1/send_email_summary
  # POST /teaches/1/send_email_summary.json
  def send_email_summary
    @teach.send_email_summary
    
    respond_to do |format|
      format.html # send_email_summary.html.erb
      format.json { render json: @enrollment }
    end
  end

  # GET /teaches/1/show_scores
  # GET /teaches/1/show_scores.json
  def show_scores
    @title = t 'view.teaches.show_scores_title'

    respond_to do |format|
      format.html # show_scores.html.erb
      format.json { render json: @teach }
    end
  end

  # GET /teaches/1/show_enrollments
  # GET /teaches/1/show_enrollments.json
  def show_enrollments
    @title = t 'view.teaches.show_enrollments_title'

    respond_to do |format|
      format.html # show_enrollments.html.erb
      format.json { render json: @teach }
    end
  end

  # GET /teaches/1/edit_scores
  # GET /teaches/1/edit_scores.json
  def edit_scores
    @title = t 'view.teaches.edit_scores_title'

    respond_to do |format|
      format.html # edit_scores.html.erb
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

  private

  def load_course
    @course ||= @teach.try(:course)
  end
end
