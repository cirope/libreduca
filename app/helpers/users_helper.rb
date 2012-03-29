module UsersHelper
  def show_user_roles_options(form)
    options = User.valid_roles.map { |r| [t("view.users.roles.#{r}"), r] }
    
    form.input :roles, collection: options, as: :check_boxes,
      wrapper_html: { class: 'inputs-list' }, label: false
  end
  
  def show_user_job_options(form)
    jobs = Job::TYPES.map { |t| [show_human_job_type(t), t] }.sort
    
    form.input :job, label: false, collection: jobs, prompt: true
  end
  
  def show_human_job_type(job)
    t "view.jobs.types.#{job}"
  end
end
