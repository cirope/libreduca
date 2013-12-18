module PaginationHelper
  def pagination_links(objects, params = nil)
    pagination_links = will_paginate objects,
      inner_window: 1, outer_window: 1, params: params,
      renderer: BootstrapPaginationHelper::LinkRenderer,
      class: 'pagination pagination-sm pull-right'
    page_entries = content_tag(:div,
      content_tag(:small,
        page_entries_info(objects),
        class: 'page-entries text-muted'
      ),
      class: 'hidden-lg pull-right'
    )

    pagination_links ||= empty_pagination_links

    content_tag(:div, pagination_links + page_entries, class: 'pagination-container')
  end

  def empty_pagination_links
    previous_tag = content_tag(
      :li,
      content_tag(:a, t('will_paginate.previous_label').html_safe),
      class: 'previous disabled'
    )
    next_tag = content_tag(
      :li,
      content_tag(:a, t('will_paginate.next_label').html_safe),
      class: 'next disabled'
    )

    content_tag(:ul, previous_tag + next_tag, class: 'pager pull-right')
  end
end
