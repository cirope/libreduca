App.Event.registerEvent(
  condition: -> $('#c_teaches').length
  type: 'keyup'
  selector: '#global_multiplier, #global_description'
  handler: ()-> $($(this).data('target')).val($(this).val())
)

App.Event.registerEvent(
  condition: -> $('#c_teaches').length
  type: 'click'
  selector: 'a.send_email_summary'
  handler: ()->
    $(this).removeAttr('href').removeAttr('data-remote').removeAttr('data-method')
)

App.Event.registerEvent(
  condition: -> $('#c_teaches').length
  type: 'ajax:success'
  selector: 'a.send_email_summary'
  handler: (event, data)->
    modal = $(this).parents('.modal:first')
    button = modal.find('.btn.btn-primary').button('complete')

    modal.find('.modal-body').hide().html(data).fadeIn()
    # Some weird behaviour with button complete make me do this
    window.setTimeout((-> button.addClass('disabled')), 20)

)
