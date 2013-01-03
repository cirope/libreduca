class BlocksController < ApplicationController
  before_filter :set_blockable
  before_filter :authenticate_user!

  check_authorization
  load_and_authorize_resource through: :blockable

  layout ->(controller) { controller.request.xhr? ? false : 'application' }

  def new
    @title = t('view.blocks.new_title')

    respond_to do |format|
      format.html # new.html.erb
      format.js
      format.json { render json: @forum }
    end
  end

  # POST /blocks
  # POST /blocks.json
  def create
    @title = t('view.blocks.new_title')
    @page = @blockable

    respond_to do |format|
      if @block.save
        format.html { redirect_to root_url }
        format.js
        format.json { head :ok }
      else
        format.js
        format.json { render json: @block.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    @title = t('view.blocks.show_title')

    respond_to do |format|
      format.html { render partial: 'block' }
      format.json { head :ok }
      format.js
    end
  end

  # GET /blocks/1/edit
  def edit
    @title = t('view.blocks.edit_title')

    respond_to do |format|
      format.html
      format.js
    end
  end

  # PUT /blocks/1
  # PUT /blocks/1.json
  def update
    @title = t('view.blocks.edit_title')

    respond_to do |format|
      if @block.update_attributes(params[:block])
        format.html
        format.js
        format.json { head :ok }
      else
        format.js
        format.json { render json: @block.errors, status: :unprocessable_entity }
      end
    end
  rescue ActiveRecord::StaleObjectError
    redirect_to edit_polymorphic_url([@blockable, @block]), alert: t('view.blocks.stale_object_error')
  end

  # DELETE /blocks/1
  # DELETE /blocks/1.json
  def destroy
    @block.destroy

    respond_to do |format|
      format.html { head :ok, notice: t('view.blocks.destroy') }
      format.js
      format.json { head :ok }
    end
  end

  def set_blockable
    @blockable = current_institution.pages.find(params[:page_id])
  end
end
