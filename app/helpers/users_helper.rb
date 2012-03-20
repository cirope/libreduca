module UsersHelper
  def show_user_roles_options(form)
    options = User.valid_roles.map { |r| [t("view.users.roles.#{r}"), r] }
    
    form.input :roles, collection: options, as: :check_boxes,
      wrapper_html: { class: 'inputs-list' }, label: false
  end
end
