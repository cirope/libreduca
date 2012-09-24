App.Event.registerEvent(
  condition: -> $('form.new_reply').length > 0
  type: 'change'
  selector: 'form.new_reply input'
  handler: -> $(this).parents('form:first').submit()
)

App.Event.registerEvent(
  condition: -> $('form.new_reply').length > 0
  type: 'ajax:success'
  selector: 'form.new_reply'
  handler: (event, data)-> $(this).parents('li:first').html(data)
)
