module InstitutionsHelper
  def institution_setting_input(form)
    form.input(
      :value,
      as: form.object.input_type,
      label: t("view.institutions.settings.#{form.object.name}"),
      wrapper: (form.object.input_type == :boolean ? :checkbox : :bootstrap),
      required: false
    )
  end
end
