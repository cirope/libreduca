new Rule
  condition: -> $('#c_users #user_email:not([data-disable-search="true"])').length
  load: ->
    @map.replace_function ||= (event, data) ->
      $.get $(this).data('url'), q: $(this).val()

    $(document).on 'change', '#user_email', @map.replace_function
  unload: ->
    $(document).off 'change', '#user_email', @map.replace_function
