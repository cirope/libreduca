module DynamicFormHelper
  def link_to_add_fields name, form, association, partial = nil
    link_to(
      name, '#',
      class: 'btn btn-default btn-sm',
      title: name,
      data: add_field_data(form, association, partial)
    )
  end

  def link_to_remove_nested_item form
    out = destroy_field(form) || ''

    out << link_to(
      remove_icon, '#',
      title: t('navigation.destroy'),
      data: remove_field_data(form)
    )

    raw out
  end

  private

    def add_field_data form, association, partial
      new_object = form.object.send(association).klass.new

      {
        id: new_object.object_id,
        dynamic_form_event: 'addNestedItem',
        dynamic_template: fieldset(new_object, form, association, partial).gsub("\n", '')
      }
    end

    def fieldset object, form, association, partial
      form.fields_for(association, object, child_index: object.object_id) do |f|
        render (partial || association.to_s.singularize), f: f
      end
    end

    def remove_field_data form
      {
        dynamic_target: ".#{form.object.class.name.underscore}",
        dynamic_form_event: (form.object.new_record? ? 'removeItem' : 'hideItem'),
        show_tooltip: true
      }
    end

    def remove_icon
      content_tag :span, nil, class: 'glyphicon glyphicon-remove-circle'
    end

    def destroy_field form
      form.hidden_field(
        :_destroy,
        value: form.object.marked_for_destruction? ? 1 : 0,
        id: "destroy_hidden_#{form.object.id}",
        data: { destroy_field: true }
      ) unless form.object.new_record?
    end
end
