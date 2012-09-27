module ImagesHelper
  def image_file_identifier(image)
    image.file.identifier || image.file_identifier if image.file?
  end

  def image_modal(image, thumb_version = :thumb)
    id = "image-modal-#{Time.now.to_i}-#{image.object_id}"
    out = link_to(
      raw(image.to_html(thumb_version)), "##{id}", data: { toggle: 'modal' }
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

    out << content_tag(:div, content, class: 'modal hide fade', id: id)
  end
end
