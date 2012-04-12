jQuery ($)->
  if $('#c_teaches').length > 0
    $(document).on 'keyup', '#global_multiplier, #global_description', ->
      $($(this).data('target')).val($(this).val())