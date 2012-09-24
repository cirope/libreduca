module ContentsHelper
  def document_file_identifier(document)
    document.file.identifier || document.file_identifier if document.file?
  end

  def content_next_and_prev_links(teach, content)
    prev_content = teach.prev_content_for(content)
    next_content = teach.next_content_for(content)
    prev_link = link_to(
      raw(t('will_paginate.previous_label')),
      prev_content ? [teach, prev_content] : '#',
      title: prev_content.try(:title), data: { 'show-tooltip' => true }
    )
    next_link = link_to(
      raw(t('will_paginate.next_label')),
      next_content ? [teach, next_content] : '#',
      title: next_content.try(:title), data: { 'show-tooltip' => true }
    )

    content =  content_tag(
      :li, prev_link, class: "previous #{'disabled' unless prev_content}"
    )
    content << content_tag(
      :li, next_link, class: "next #{'disabled' unless next_content}"
    )

    content_tag(:ul, content, class: 'pager')
  end
end
