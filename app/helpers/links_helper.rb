module LinksHelper
  def link_to_destroy(*args)
    options = args.extract_options!

    options[:data]           ||= {}
    options[:data][:method]  ||= :delete
    options[:data][:confirm] ||= t('messages.confirmation')

    link_with_icon({ action: 'destroy', icon: 'glyphicon-trash' }, *(args << options))
  end

  def link_to_edit(*args)
    link_with_icon({ action: 'edit', icon: 'glyphicon-pencil' }, *args)
  end

  def link_to_index(*args)
    link_to t('navigation.index'), *args
  end

  def link_to_new(*args)
    link_to t('.new'), *args
  end

  def link_to_show(*args)
    link_with_icon({ action: 'show', icon: 'glyphicon-search' }, *args)
  end

  private
    def link_with_icon(options = {}, *args)
      arg_options = args.extract_options!

      arg_options.reverse_merge!(
        title: t("navigation.#{options.fetch(:action)}"),
        class: 'icon'
      )

      link_to *args, arg_options do
        content_tag :span, nil, class: "glyphicon #{options.fetch(:icon)}"
      end
    end
end
