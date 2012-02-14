module ApplicationHelper
  def show_error_messages_for(model)
    render 'shared/error_messages', model: model unless model.errors.empty?
  end
  
  def pagination_links(objects, params = nil)
    result = will_paginate objects,
      inner_window: 1, outer_window: 1, params: params,
      renderer: BootstrapPaginationHelper::LinkRenderer,
      class: 'pagination pagination-right'
    page_entries = content_tag(
      :blockquote, content_tag(:small, page_entries_info(objects), class: 'page-entries pull-right')
    )
    
    unless result
      previous_tag = content_tag(
        :li,
        content_tag(:a, t('will_paginate.previous_label').html_safe),
        class: 'previous_page disabled'
      )
      next_tag = content_tag(
        :li,
        content_tag(:a, t('will_paginate.next_label').html_safe),
        class: 'next disabled'
      )
      
      result = content_tag(
        :div,
        content_tag(:ul, previous_tag + next_tag),
        class: 'pagination pagination-right'
      )
    end

    result + page_entries
  end
  
  def link_to_edit(*args)
    options = args.extract_options!
    
    options['class'] ||= 'iconic'
    options['title'] ||= t('label.edit')
    options['data-show-tooltip'] ||= true
    
    link_to '&#x270e;'.html_safe, *args, options
  end
  
  def link_to_destroy(*args)
    options = args.extract_options!
    
    options['class'] ||= 'iconic'
    options['title'] ||= t('label.delete')
    options['confirm'] ||= t('messages.confirmation')
    options['method'] ||= :delete
    options['data-show-tooltip'] ||= true
    
    link_to '&#x2714;'.html_safe, *args, options
  end
end
