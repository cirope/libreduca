class GradesController < ApplicationController
  before_filter :authenticate_user!

  check_authorization
  load_and_authorize_resource :institution
  load_and_authorize_resource :grade, through: :institution

  # GET /grades
  # GET /grades.json
  def index
    @title = t 'view.grades.index_title'
    @searchable = true
    @grades = @grades.filtered_list(params[:q]).page(params[:page]).uniq('id')

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @grades }
    end
  end

  # GET /grades/1
  # GET /grades/1.json
  def show
    @title = t 'view.grades.show_title'

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @grade }
    end
  end

  # GET /grades/new
  # GET /grades/new.json
  def new
    @title = t 'view.grades.new_title'

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @grade }
    end
  end

  # GET /grades/1/edit
  def edit
    @title = t 'view.grades.edit_title'
  end

  # POST /grades
  # POST /grades.json
  def create
    @title = t 'view.grades.new_title'

    respond_to do |format|
      if @grade.save
        format.html { redirect_to [@institution, @grade], notice: t('view.grades.correctly_created') }
        format.json { render json: @grade, status: :created, location: @grade }
      else
        format.html { render action: 'new' }
        format.json { render json: @grade.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /grades/1
  # PUT /grades/1.json
  def update
    @title = t 'view.grades.edit_title'

    respond_to do |format|
      if @grade.update_attributes(params[:grade])
        format.html { redirect_to [@institution, @grade], notice: t('view.grades.correctly_updated') }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @grade.errors, status: :unprocessable_entity }
      end
    end

  rescue ActiveRecord::StaleObjectError
    flash.alert = t 'view.grades.stale_object_error'
    redirect_to edit_institution_grade_url(@institution, @grade)
  end

  # DELETE /grades/1
  # DELETE /grades/1.json
  def destroy
    @grade.destroy

    respond_to do |format|
      format.html { redirect_to institution_grades_url(@institution) }
      format.json { head :no_content }
    end
  end
end
