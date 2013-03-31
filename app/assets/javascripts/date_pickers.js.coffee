jQuery ($) ->
  $(document).on 'focus keydown click', 'input[data-date-picker]', ->
    $(this).datepicker
      showOn: 'both',
      onSelect: -> $(this).datepicker('hide')
    .removeAttr('data-date-picker').focus()


  # Due to a bug in jQuery UI, nasty hack...
  $(document).on 'page:change', ->
    $('.hasDatepicker').attr('data-date-picker', true).datepicker('destroy').removeClass('hasDatepicker')

    $.datepicker.initialized = false
