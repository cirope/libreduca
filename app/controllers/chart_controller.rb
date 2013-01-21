class ChartController < ApplicationController
  def index
    @title = t 'view.charts.index_title'
    @kinships = current_institution.kinships.includes(:user, :relative).superiors

    respond_to do |format|
      format.html # index.html.erb
    end
  end
end
