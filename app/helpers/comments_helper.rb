module CommentsHelper
  def link_to_comments(news, path, options = {})
    total = news.comments.size
    text = content_tag(:span, '&#xe05e;'.html_safe, class: 'iconic')
    text << ' '
    text << content_tag(:small, 
              Comment.model_name.human(count: total) << ' ' << "(#{total})",
              class: 'muted'
            )

    link_to text, path, options
  end
end
