class TeachesController < ApplicationController
  include Teaches::EmailSummary
  include Teaches::Enrollments
  include Teaches::Scores
  include Teaches::Tracking

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
      if @teach.update(teach_params)
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

  private

    def teach_params
      params.require(:teach).permit(
        :start, :finish, :description, :course_id, :lock_version,
        enrollments_attributes: [
          :id, :teach_id, :job, :enrollable_id, :enrollable_type, :lock_version,
          :_destroy
        ],
        scores_attributes: [
          :id, :score, :multiplier, :description, :user_id, :teach_id, :lock_version,
          :_destroy
        ]
      )
    end

    def load_course
      @course ||= @teach.try(:course)
    end
end
