MARKDOWN_RENDERER = Redcarpet::Markdown.new(
  Redcarpet::Render::HTML.new(hard_wrap: true, filter_html: false),
  autolink: true, space_after_headers: true
)
