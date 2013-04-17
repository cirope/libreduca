module ApplicationHelper
  def title
    [t('app_name'), @title].compact.join(' | ')
  end

  def show_menu_link(options = {})
    name = t("menu.#{options[:name]}")
    classes = []

    classes << 'active' if [*options[:controllers]].include?(controller_name)

    content_tag(
      :li, link_to(name, options[:path]),
      class: (classes.empty? ? nil : classes.join(' '))
    )
  end

  def show_button_dropdown(main_action, extra_actions = [], options = {})
    if extra_actions.blank?
      main_action
    else
      out = ''.html_safe

      out << render(
        partial: 'shared/button_dropdown', locals: {
          main_action: main_action, extra_actions: extra_actions
        }
      )
    end
  end

  def pagination_links(objects, params = nil)
    result = will_paginate objects,
      inner_window: 1, outer_window: 1, params: params,
      renderer: BootstrapPaginationHelper::LinkRenderer,
      class: 'pagination pagination-right'
    page_entries = content_tag(
      :blockquote,
      content_tag(
        :small,
        page_entries_info(objects),
        class: 'page-entries hidden-desktop pull-right'
      )
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

    content_tag :div, result + page_entries, class: 'pagination-container'
  end

  def link_to_show(*args)
    options = args.extract_options!

    options['class'] ||= 'iconic'
    options['title'] ||= t('label.show')
    options['data-show-tooltip'] ||= true

    link_to '&#xe074;'.html_safe, *args, options
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
    options['method'] ||= :delete
    options['data-confirm'] ||= t('messages.confirmation')
    options['data-show-tooltip'] ||= true

    link_to '&#xe05a;'.html_safe, *args, options
  end

  def copy_attribute_errors(from, to, form_builder)
    form_builder.object.errors[from].each do |message|
      form_builder.object.errors.add(to, message)
    end
  end

  Job::TYPES.each do |type|
    define_method("current_user_is_#{type}?") do
      current_institution && current_user.jobs.in_institution(current_institution).any?(&:"#{type}?")
    end
  end
end
