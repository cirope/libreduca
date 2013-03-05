module NewsHelper
  def embedded_news_path(news)
    news_path(news, embedded: params[:embedded])
  end

  def embedded_news_index_path(page = nil)
    news_index_path(embedded: params[:embedded], page: page)
  end
end
