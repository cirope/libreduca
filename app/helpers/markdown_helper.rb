module MarkdownHelper
  def markdown(text)
    MARKDOWN_RENDERER.render(text).html_safe
  end

  def markdown_help_link
    t(
      'view.contents.markdown_help.html',
      link: link_to('markdown', '#markdown-help', data: { toggle: 'modal' })
    )
  end
end
