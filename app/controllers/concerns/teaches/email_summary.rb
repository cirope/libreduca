module Teaches::EmailSummary
  extend ActiveSupport::Concern

  # POST /teaches/1/send_email_summary
  # POST /teaches/1/send_email_summary.json
  def send_email_summary
    @teach.send_email_summary

    respond_to do |format|
      format.html # send_email_summary.html.erb
      format.json { render json: @enrollment }
      format.js
    end
  end
end
