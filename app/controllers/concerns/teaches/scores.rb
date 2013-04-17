module Teaches::Scores
  extend ActiveSupport::Concern

  # GET /teaches/1/show_scores
  # GET /teaches/1/show_scores.json
  def show_scores
    @title = t 'view.teaches.show_scores_title'

    respond_to do |format|
      format.html # show_scores.html.erb
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
end
