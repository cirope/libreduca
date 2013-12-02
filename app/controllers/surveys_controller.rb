class SurveysController < ApplicationController
  layout ->(controller) { controller.request.xhr? ? false : 'application' }

  before_action :authenticate_user!

  check_authorization
  load_and_authorize_resource :teach, shallow: true
  load_and_authorize_resource :content, shallow: true

  load_and_authorize_resource through: [:teach, :content]

  # GET /surveys
  # GET /surveys.json
  # GET /surveys.csv
  def index
    @title = t 'view.surveys.index_title'

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @surveys }
      if @teach
        format.csv  { render csv: @surveys.unscoped.to_csv(@teach), filename: @title }
      end
    end
  end

  # GET /surveys/1
  # GET /surveys/1.json
  # GET /surveys/1.csv
  def show
    @title = t 'view.surveys.show_title'

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @survey }
      format.csv  { render csv: @survey, filename: @title }
    end
  end

  # GET /surveys/new
  # GET /surveys/new.json
  def new
    @title = t 'view.surveys.new_title'

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @survey }
    end
  end

  # GET /surveys/1/edit
  def edit
    @title = t 'view.surveys.edit_title'
  end

  # POST /surveys
  # POST /surveys.json
  def create
    @title = t 'view.surveys.new_title'

    respond_to do |format|
      if @survey.save
        format.html { redirect_to [@content, @survey], notice: t('view.surveys.correctly_created') }
        format.json { render json: @survey, status: :created, location: @survey }
      else
        format.html { render action: 'new' }
        format.json { render json: @survey.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /surveys/1
  # PUT /surveys/1.json
  def update
    @title = t 'view.surveys.edit_title'

    respond_to do |format|
      if @survey.update(survey_params)
        format.html { redirect_to [@content, @survey], notice: t('view.surveys.correctly_updated') }
        format.json { head :ok }
      else
        format.html { render action: 'edit' }
        format.json { render json: @survey.errors, status: :unprocessable_entity }
      end
    end
  rescue ActiveRecord::StaleObjectError
    redirect_to edit_content_survey_url(@content, @survey), alert: t('view.surveys.stale_object_error')
  end

  # DELETE /surveys/1
  # DELETE /surveys/1.json
  def destroy
    @survey.destroy

    respond_to do |format|
      format.html { redirect_to content_surveys_url(@content) }
      format.json { head :ok }
    end
  end

  private

    def survey_params
      params.require(:survey).permit(
        :name, :content_id, :lock_version, questions_attributes: [
          :id, :content, :hint, :question_type, :required, :lock_version,
          :_destroy,
          answers_attributes: [:id, :content, :lock_version, :_destroy]
        ]
      )
    end
end
