jQuery ($)->
  if $('#c_teaches').length > 0
    $(document).on 'keyup', '#global_multiplier, #global_description', ->
      $($(this).data('target')).val($(this).val())
      
    $(document).on 'click', 'a.send_email_summary', ->
      $(this).removeAttr('href').removeAttr('data-remote').
      removeAttr('data-method')
    
    $(document).on 'ajax:success', 'a.send_email_summary', (event, data)->
      modal = $(this).parents('.modal:first')
      
      modal.find('.modal-body').hide().html(data).fadeIn()
      modal.find('.btn.btn-primary').button('complete')
      # Some weird behaviour with button complete make me do this
      window.setTimeout(
        (-> modal.find('.btn.btn-primary').addClass('disabled')), 20
      )
      