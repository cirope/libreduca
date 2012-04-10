module DashboardHelper
  def show_teach_info(teach)
    content = content_tag(
      :ul, [
        content_tag(
          :li, [
            content_tag(:strong, Teach.human_attribute_name('start')),
            l(teach.start, format: :long)
          ].join(' ').html_safe
        ),
        content_tag(
          :li, [
            content_tag(:strong, Teach.human_attribute_name('finish')),
            l(teach.finish, format: :long)
          ].join(' ').html_safe
        )
      ].join('').html_safe
    )
    
    content_tag(
      :span, link_to(teach.course.to_s, [teach.course, teach]),
      title: Teach.model_name.human,
      data: {
        'show-popover' => true, 'content' => raw(content), 'placement' => 'right'
      }
    )
  end
  
  def show_dashboard_score(score)
    classes = ['badge']
    classes << 'badge-success' if score >= SCORE_SUCCESS_THRESHOLD
    classes << 'badge-warning' if score <= SCORE_FAIL_THRESHOLD
    
    content_tag(
      :span, number_with_precision(score), class: classes.join(' ')
    )
  end
  
  def show_dashboard_score_extras(score)
    content = content_tag(
      :ul, [
        content_tag(
          :li, [
            content_tag(:strong, Score.human_attribute_name('multiplier')),
            number_with_precision(score.multiplier)
          ].join(' ').html_safe
        ),
        content_tag(
          :li, [
            content_tag(:strong, Score.human_attribute_name('created_at')),
            l(score.created_at, format: :long)
          ].join(' ').html_safe
        ),
        content_tag(
          :li, [
            content_tag(:strong, Score.human_attribute_name('whodunnit')),
            User.find(score.originator)
          ].join(' ').html_safe
        )
      ].join('').html_safe
    )

    content_tag(
      :span, '&#x2139;'.html_safe,
      title: score.description,
      class: 'iconic label',
      data: {
        'show-popover' => true, 'content' => raw(content), 'placement' => 'top'
      }
    )
  end
end
