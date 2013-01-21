new Rule
  condition: -> $('#c_news #images_news').length
  load: ->
    @map.submit_function ||= ->
      $(this).closest('form').attr('data-remote', 'true').submit()
      
    $(document).on 'click', '#images_news', @map.submit_function
  unload: ->
    $(document).off 'click', '#images_news', @map.submit_function
