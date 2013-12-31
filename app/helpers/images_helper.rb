module ImagesHelper
  def image_file_identifier(image)
    image.file.identifier || image.file_identifier if image.file?
  end

  def link_to_zoom(*args)
    options = args.extract_options!

    link = content_tag(:span, nil, class: 'glyphicon glyphicon-fullscreen')
    link << ' ' << t('label.zoom')

    options['title'] ||= t('label.zoom')
    options['data-toggle'] ||= 'modal'

    link_to link, *args, options
  end
end
