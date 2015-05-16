class DatePickerInput < SimpleForm::Inputs::Base
  def input wrapper_options
    combined_input_html_options = merge_wrapper_options input_html_options, wrapper_options

    @builder.text_field(
      attribute_name,
      combined_input_html_options.reverse_merge(
        data:         { 'date-picker' => true },
        value:        (I18n.l(object.send(attribute_name)) if object.send(attribute_name)),
        autocomplete: 'off'
      )
    ).html_safe
  end

  def input_html_classes
    super.push('form-control')
  end
end
