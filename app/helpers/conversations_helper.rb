module ConversationsHelper
  def link_to_conversation(path, total = 0, options = {})
    text = content_tag(:span, '&#xe05e;'.html_safe, class: 'iconic')
    text << ' '
    text << content_tag(:small, "(#{total})", class: 'muted')

    link_to text, path, options
  end
end
