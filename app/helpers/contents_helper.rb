module ContentsHelper
  def document_file_identifier(document)
    document.file.identifier || document.file_identifier if document.file?
  end

  def content_next_and_prev_links
    prev_content = @teach.prev_content_for(@content)
    next_content = @teach.next_content_for(@content)

    content = navigate_to_content_link(prev_content, 'previous')
    content << navigate_to_content_link(next_content)

    content_tag(:ul, content, class: 'pager')
  end

  def navigate_to_content_link(content, label = 'next')
    link = link_to(
      raw(t("will_paginate.#{label}_label")),
      content ? [@teach, content] : '#',
      title: content.try(:title), data: { 'show-tooltip' => true }
    )

    content_tag(:li, link, class: "#{label} #{'disabled' unless content}")
  end

  def render_new_homework_presentation_form(homework)
    @homework = homework
    @presentation ||= Presentation.new

    render template: 'presentations/new'
  end

  def render_homework_presentations(homework)
    @homework = homework
    @presentations = homework.presentations

    render template: 'presentations/index'
  end

  def show_content_survey?
    @content.persisted? && !@teach.past? && current_institution
  end

  def content_has_no_relations?
    @content.documents.empty? && @content.surveys.empty? && @content.homeworks.empty?
  end
end
