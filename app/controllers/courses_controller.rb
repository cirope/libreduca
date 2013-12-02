class CoursesController < ApplicationController
  before_action :authenticate_user!

  check_authorization
  load_and_authorize_resource :grade
  load_and_authorize_resource :course, through: :grade

  # GET /courses
  # GET /courses.json
  def index
    @title = t 'view.courses.index_title'
    @searchable = true
    @courses = @courses.filtered_list(params[:q]).page(params[:page]).uniq('id')

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @courses }
    end
  end

  # GET /courses/1
  # GET /courses/1.json
  def show
    @title = t 'view.courses.show_title'

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @course }
    end
  end

  # GET /courses/new
  # GET /courses/new.json
  def new
    @title = t 'view.courses.new_title'

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @course }
    end
  end

  # GET /courses/1/edit
  def edit
    @title = t 'view.courses.edit_title'
  end

  # POST /courses
  # POST /courses.json
  def create
    @title = t 'view.courses.new_title'

    respond_to do |format|
      if @course.save
        format.html { redirect_to [@grade, @course], notice: t('view.courses.correctly_created') }
        format.json { render json: @course, status: :created, location: @course }
      else
        format.html { render action: 'new' }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /courses/1
  # PUT /courses/1.json
  def update
    @title = t 'view.courses.edit_title'

    respond_to do |format|
      if @course.update(course_params)
        format.html { redirect_to [@grade, @course], notice: t('view.courses.correctly_updated') }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  rescue ActiveRecord::StaleObjectError
    flash.alert = t 'view.courses.stale_object_error'
    redirect_to edit_grade_course_url(@grade, @course)
  end

  # DELETE /courses/1
  # DELETE /courses/1.json
  def destroy
    @course.destroy

    respond_to do |format|
      format.html { redirect_to grade_courses_url(@grade) }
      format.json { head :no_content }
    end
  end

  private

  def course_params
    params.require(:course).permit(:name, :grade_id, :lock_version)
  end
end
