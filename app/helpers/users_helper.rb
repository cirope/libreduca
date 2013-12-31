module UsersHelper
  def show_user_roles_options(form)
    options = User.valid_roles.map { |r| [t("view.users.roles.#{r}"), r] }

    form.input :role, collection: options, as: :radio_buttons, label: false,
      input_html: { class: nil }
  end

  def show_user_job_options(form)
    jobs = Job::TYPES.map { |t| [show_human_job_type(t), t] }.sort

    form.input :job, label: false, collection: jobs, prompt: true
  end

  def show_human_job_type(job)
    t "view.jobs.types.#{job}"
  end

  def show_user_kinship_options(form)
    kinships = Kinship::KINDS.map { |t| [show_human_kinship_type(t), t] }

    form.input :kin, label: false, collection: kinships, prompt: true
  end

  def show_human_kinship_type(kinship)
    t "view.kinships.types.#{kinship}"
  end

  def show_user_avatar(user, version = :thumb)
    avatar = user.avatar.send(version)
    dimensions = MiniMagick::Image.open(avatar.path)['dimensions']

    image_tag avatar.url, size: dimensions.join('x'), alt: user, class: 'avatar img-rounded'
  end

  def show_user_default_avatar(version = :thumb)
    content_tag(:span, nil, class: "glyphicon glyphicon-user avatar-#{version}")
  end

  def user_avatar_identifier(user)
    user.avatar.identifier || user.avatar_identifier if user.avatar?
  end

  def user_jobs(user)
    jobs = current_institution ?
      user.jobs.in_institution(current_institution).to_a : user.jobs.to_a

    jobs << (user.jobs.detect(&:new_record?) || user.jobs.build) if jobs.empty?

    jobs
  end
end
