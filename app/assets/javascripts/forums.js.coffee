App.Event.registerEvent(
  condition: -> $('#c_forums').length > 0
  type: 'ajax:success'
  selector: 'form[data-remote]'
  handler: (event, data)-> $(this).replaceWith(data)
)
