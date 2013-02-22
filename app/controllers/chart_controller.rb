class ChartController < ApplicationController
  def index
    @title = t 'view.charts.index_title'

    if params[:id].present?
      user = current_institution.users.find(params[:id])

      @kinships = user.inverse_kinships.includes(:user).for_chart
      @users = @kinships.map(&:user)
    else
      @users = current_institution.users.roots_for_chart
    end

    respond_to do |format|
      format.html # index.html.erb
      format.js   # index.js.erb
    end
  end
end
