new Rule
  condition: -> $('#c_users #user_email:not([data-disabled-search=true])').length
  load: ->
    @map.replace_function ||= (event, data) ->
      $.get('/users/find_by_email', q: $('form input#user_email').val())

    $(document).on 'change', @map.replace_function
  unload: ->
    $(document).off 'change', @map.replace_function