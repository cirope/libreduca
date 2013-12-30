new Rule
  condition: -> $('#form-teach').length
  load: ->
    @map.replace_with_global_values ||= ->
      $($(this).data('target')).val($(this).val())

    $(document).on 'keyup', '#global_multiplier, #global_description', @map.replace_with_global_values
  unload: ->
    $(document).off 'keyup', '#global_multiplier, #global_description', @map.replace_with_global_values
