module DynamicFormHelper
  def generate_html(form, method, user_options = {})
    options = {
      object: form.object.class.reflect_on_association(method).klass.new,
      partial: method.to_s.singularize,
      form_builder_local: :f,
      locals: {},
      child_index: 'NEW_RECORD'
    }.merge(user_options)

    form.fields_for(method, options[:object], child_index: options[:child_index]) do |f|
      render(
        options[:partial],
        { options[:form_builder_local] => f }.merge(options[:locals])
      )
    end
  end
  
  def generate_template(form_builder, method, options = {})
    escape_javascript generate_html(form_builder, method, options)
  end
  
  def link_to_remove_nested_item(form = nil, class_to_remove = nil)
    new_record = form.nil? || form.object.new_record?
    out = ''
    destroy = form.object.marked_for_destruction? ? 1 : 0
    
    out << form.hidden_field(:_destroy, class: 'destroy', value: destroy) unless new_record
    out << link_to(
      '&#x2714;'.html_safe, '#', title: t('label.delete'), class: 'iconic',
      data: {
        'dynamic-target' => ".#{class_to_remove || form.object.class.name.underscore}",
        'dynamic-form-event' => (new_record ? 'removeItem' : 'hideItem'),
        'show-tooltip' => true
      }
    )

    raw out
  end
end