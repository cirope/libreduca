jQuery ($)->
  # For browsers with no autofocus support
  $('*[autofocus]:not([readonly]):not([disabled]):visible:first').focus()
  
  $('*[data-show-tooltip]').tooltip()

  if $('.alert[data-close-after]').length > 0
    $('.alert[data-close-after]').each (i, a)->
      setTimeout(
        (-> $(a).find('a.close').trigger('click')), $(a).data('close-after')
      )