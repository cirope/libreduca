class RouterController < ApplicationController
  def index
    if redirect_to_news?
      redirect_to news_index_url
    else
      redirect_to new_user_session_url
    end
  end

  private

  def redirect_to_news?
    current_institution && current_institution.show_news.converted_value && current_institution.news.present?
  end
end
