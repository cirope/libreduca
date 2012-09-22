jQuery ($)->
  if $('form.new_reply').length > 0
    $(document).on 'change', 'form.new_reply input', ->
      $(this).parents('form:first').submit()

    $(document).on 'ajax:success', 'form.new_reply', (event, data)->
      $(this).parents('li:first').html(data)
