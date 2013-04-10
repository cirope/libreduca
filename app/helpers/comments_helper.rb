module CommentsHelper
  def link_to_comments(commentable, path)
    total = commentable.comments.size
    text = content_tag(:span, '&#xe05e;'.html_safe, class: 'iconic')
    text << ' ' << content_tag(:small, "(#{total})", class: 'muted')

    if user_signed_in?
      link_to text, path, 
        title: Comment.model_name.human(count: 0),
        data: { 'show-tooltip' => true, 'placement' => 'top' }
    else
      text
    end
  end
end
