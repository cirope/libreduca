new Rule
  condition: -> $('#c_forums').length
  load: ->
    @map.replace_function ||= (event, data)-> $(this).replaceWith(data)

    $(document).on 'ajax:success', 'form[data-remote]', @map.replace_function
  unload: ->
    $(document).off 'ajax:success', 'form[data-remote]', @map.replace_function
