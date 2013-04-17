module Teaches::Tracking
  extend ActiveSupport::Concern

  # GET /teaches/1/show_tracking
  # GET /teaches/1/show_tracking.json
  def show_tracking
    @title = t 'view.teaches.show_tracking_title'

    respond_to do |format|
      format.html # show_tracking.html.erb
      format.json { render json: @teach }
      format.csv  {
        response.headers['Cache-Control'] = 'private, no-store'
        response.headers['Content-Disposition'] = "attachment; filename=\"#{@title}.csv\""
      }
    end
  end
end
