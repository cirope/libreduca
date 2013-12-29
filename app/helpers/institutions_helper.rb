module InstitutionsHelper
  def institution_setting_input(form)
    form.input(
      :value, as: :boolean, label: false,
      inline_label: t("view.institutions.settings.#{form.object.name}"),
      required: false
    )
  end
end
