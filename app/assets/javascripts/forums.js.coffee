App.Event.registerEvent(
  condition: -> $('#c_forums').length
  type: 'ajax:success'
  selector: 'form[data-remote]'
  handler: (event, data)-> $(this).replaceWith(data)
)
