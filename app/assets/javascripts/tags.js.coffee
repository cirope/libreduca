new Rule
  condition: -> $('.tag_color_chooser').length
  load: ->
    @map.radio_button_checked ||= ->
      fieldset = $(this).closest('fieldset')
      fieldset.find('.tag_color_chooser').removeClass('selected')

      $(this).find('input[type="radio"]:first').prop('checked', true)
      $(this).toggleClass('selected')

    @map.set_current_color ||= ->
      color = $(this).data('item').category
      $(this).closest('fieldset').find("input[value=#{color}]").click()

    $(document).on 'click', '.tag_color_chooser', @map.radio_button_checked
    $(document).on 'autocomplete:update', 'input[name$="[tag_attributes][name]"]', @map.set_current_color
  unload: ->
    $(document).off 'click', '.tag_color_chooser', @map.radio_button_checked
    $(document).off 'autocomplete:update', 'input[name$="[tag_attributes][name]"]', @map.set_current_color
