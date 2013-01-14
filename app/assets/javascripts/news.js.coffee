App.Event.registerEvent  
  condition: -> $('#c_news #images_news').length
  type: 'click'
  selector: '#images_news'
  handler: -> $(this).closest('form').attr('data-remote', 'true').submit()
