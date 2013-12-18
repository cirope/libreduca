module InstitutionsHelper
  def institution_setting_input(form)
    form.input(
      :value, as: :boolean,
      label: t("view.institutions.settings.#{form.object.name}"),
      wrapper: :checkbox, required: false
    )
  end
end
