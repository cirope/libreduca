module ImagesHelper
  def image_file_identifier(image)
    image.file.identifier || image.file_identifier if image.file?
  end

  def image_modal(image, thumb_version = :thumb)
    out = link_to(
      raw(image.to_html(thumb_version)), "#image-modal-#{image.object_id}",
      data: { toggle: 'modal' }
    )

    content = content_tag(
      :div, content_tag(:h3, image.to_s), class: 'modal-header'
    )

    content << content_tag(:div, raw(image.to_html), class: 'modal-body')
    content << content_tag(
      :div,
      link_to(t('label.close'), '#', class: 'btn', data: { dismiss: 'modal' }),
      class: 'modal-footer'
    )

    out << content_tag(
      :div, content, class: 'modal fade', id: "image-modal-#{image.object_id}"
    )
  end
end
