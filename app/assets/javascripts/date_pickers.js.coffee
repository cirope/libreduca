jQuery ($)->
  $(document).on 'focus keydown click', 'input[data-date-picker]', ->
    $(this).datepicker
      showOn: 'both',
      onSelect: -> $(this).datepicker('hide')
    .removeAttr('data-date-picker').focus()