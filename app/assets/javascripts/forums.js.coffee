jQuery ($)->
  if $('#c_forums').length > 0
    $('form[data-remote]').on 'ajax:success', (event, data)->
      $(this).replaceWith(data)
