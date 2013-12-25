module CommentsHelper
  def link_to_comments(commentable, path)
    total = commentable.comments.size
    text = content_tag(:span, nil, class: 'glyphicon glyphicon-comment')
    text << ' ' << content_tag(:span, "(#{total})")

    if user_signed_in?
      link_to text, path,
        title: Comment.model_name.human(count: 0),
        data: { 'show-tooltip' => true, 'placement' => 'top' }
    else
      text
    end
  end
end
