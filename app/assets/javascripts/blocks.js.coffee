# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ($)->
  $(document).on 'click', 'input.create-action', (e) ->
    $(this).hide()
    $(this).parents('form').hide()

  $(document).on 'click', 'a.edit-action', (e) ->
    $(this).hide()
    $(this).prev('input.save-action').removeClass('hide')

  $(document).on 'click', 'input.save-action', (e) ->
    $(this).next('.edit-action').show()
    $(this).hide()

  $(document).on 'click', 'a.delete-action', (e) ->
    action_url = $(this).parents('form').attr('action')
    formdata = $(this).parents('form').serialize()
    $.ajax({
            type: 'DELETE',
            url: action_url,
            data: formdata,
            error: () -> 'error',
            success: () -> 'success',
            complete: () -> 'complete'
            });