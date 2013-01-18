new Rule
  condition: -> $('form.new_reply').length
  load: ->
    @map.submit_function ||= -> $(this).parents('form:first').submit()
    @map.replace_function ||= (event, data) ->
      $(this).parents('li:first').html(data)

    $(document).on 'change', 'form.new_reply input', @map.submit_function
    $(document).on 'ajax:success', 'form.new_reply', @map.replace_function

  unload: ->
    $(document).off 'change', 'form.new_reply input', @map.submit_function
    $(document).off 'ajax:success', 'form.new_reply', @map.replace_function
