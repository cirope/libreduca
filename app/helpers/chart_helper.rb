module ChartHelper
  def chart_users_row(users)
    render 'user_row', empty_rows: (6 - users.size), users: users
  end

  private

  def chart_user_description(user)
    job = user.jobs.in_institution(current_institution).first
    kinship = @kinships.find_by_user_id(user.id) if @kinships
    result = ''.html_safe
    html_class = ['thumbnail']

    html_class << 'functional' if kinship.try(:functional?)

    result << user_micro_avatar(user) if user.avatar?
    result << content_tag(:h6, content_tag(:small, user.to_s), class: 'text-center')
    result << content_tag(:p,
      content_tag(:small, job.description, class: 'text-muted'), class: 'text-center'
    ) if job && job.description.present?

    if user.inverse_kinships_in_chart_count > 0
      result << '<hr />'.html_safe
      result << t('view.charts.user_inverse_kinships.html', count: user.inverse_kinships_in_chart_count)
    end

    if user.inverse_kinships.for_chart.empty?
      content_tag :div, result, class: html_class.join(' '), data: { user: user.to_param  }
    else
      link_to result, chart_user_path(user), class: html_class.join(' '), data: { remote: true, user: user.to_param }
    end
  end

  def user_micro_avatar(user)
    dimensions = MiniMagick::Image.open(user.avatar.micro_thumb.path)[:dimensions]

    image_tag user.avatar.micro_thumb.url, size: dimensions.join('x')
  end
end
