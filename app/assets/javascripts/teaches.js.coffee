new Rule
  condition: -> $('#form-scores').length
  load: ->
    @map.replace_with_global_values ||= ->
      alert 'sjhdsj'
      $($(this).data('target')).val($(this).val())
    @map.cancel_email_resubmit_function ||= ->
      $(this).removeAttr('href').removeAttr('data-remote').removeAttr('data-method')
    @map.replace_modal_with_message ||= (event, data) ->
      modal = $(this).parents('.modal:first')
      button = modal.find('.btn.btn-primary').button('complete')

      modal.find('.modal-body').hide().html(data).fadeIn()
      # Some weird behaviour with button complete make me do this
      window.setTimeout((-> button.addClass('disabled')), 20)

    $(document).on 'keyup', '#global_multiplier, #global_description', @map.replace_with_global_values
    $(document).on 'click', 'a.send_email_summary', @map.cancel_email_resubmit_function
    $(document).on 'ajax:success', 'a.send_email_summary', @map.replace_modal_with_message
  unload: ->
    $(document).off 'keyup', '#global_multiplier, #global_description', @map.replace_with_global_values
    $(document).off 'click', 'a.send_email_summary', @map.cancel_email_resubmit_function
    $(document).off 'ajax:success', 'a.send_email_summary', @map.replace_modal_with_message
