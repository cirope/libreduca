module CommentsHelper
  def link_to_comments(commentable, path, options = {})
    total = commentable.comments.size
    text = content_tag(:span, '&#xe05e;'.html_safe, class: 'iconic')
    text << ' '
    text << content_tag(:small, "(#{total})", class: 'muted')

    link_to text, path, options
  end
end
