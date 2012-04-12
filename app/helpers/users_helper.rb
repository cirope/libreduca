module UsersHelper
  def show_user_roles_options(form)
    options = User.valid_roles.map { |r| [t("view.users.roles.#{r}"), r] }
    
    form.input :role, collection: options, as: :radio_buttons, label: false
  end
end
