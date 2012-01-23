class UsersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :load_current_user, only: [:edit_profile, :update_profile]
  
  check_authorization
  load_and_authorize_resource
  
  # GET /users
  # GET /users.json
  def index
    @title = t 'view.users.index_title'
    @users = @users.ordered_list.paginate(
      page: params[:page], per_page: LINES_PER_PAGE
    )

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @title = t 'view.users.show_title'

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @title = t 'view.users.new_title'

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @title = t 'view.users.edit_title'
  end

  # POST /users
  # POST /users.json
  def create
    @title = t 'view.users.new_title'

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: t('view.users.correctly_created') }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    authorize! :assign_roles, @user if params[:user] && params[:user][:roles]
    @title = t 'view.users.edit_title'

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: t('view.users.correctly_updated') }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
    
  rescue ActiveRecord::StaleObjectError
    flash.alert = t 'view.users.stale_object_error'
    redirect_to edit_user_url(@user)
  end
  
  # GET /users/1/edit_profile
  def edit_profile
    @title = t('view.users.edit_profile')
  end
  
  # PUT /users/1/update_profile
  # PUT /users/1/update_profile.xml
  def update_profile
    @title = t('view.users.edit_profile')
    
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to(edit_profile_user_url(@user), notice: t('view.users.profile_correctly_updated')) }
        format.xml  { head :ok }
      else
        format.html { render action: 'edit_profile' }
        format.xml  { render xml: @user.errors, status: :unprocessable_entity }
      end
    end

  rescue ActiveRecord::StaleObjectError
    flash.alert = t('view.users.stale_object_error')
    redirect_to edit_profile_user_url(@user)
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end
  
  private
  
  def load_current_user
    @user = current_user
  end
end
