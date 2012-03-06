jQuery ($)->
  # For browsers with no autofocus support
  $('*[autofocus]:not([readonly]):not([disabled]):visible:first').focus()
  
  $('*[data-show-tooltip]').tooltip()
  
  $('form').submit ->
    $(this).find('input[type="submit"], input[name="utf8"]')
    .attr 'disabled', true

  if $('.alert[data-close-after]').length > 0
    $('.alert[data-close-after]').each (i, a)->
      setTimeout(
        (-> $(a).find('a.close').trigger('click')), $(a).data('close-after')
      )