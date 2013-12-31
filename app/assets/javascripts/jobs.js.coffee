new Rule
  condition: -> $('[data-controller="users"] #user_email:not([data-disable-search="true"])').length
  load: ->
    @map.replace_function ||= (event, data) ->
      $.get $(this).data('url'), email: $(this).val(), null, 'script'

    $(document).on 'change', '#user_email', @map.replace_function
  unload: ->
    $(document).off 'change', '#user_email', @map.replace_function
