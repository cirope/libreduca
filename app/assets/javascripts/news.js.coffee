new Rule
  condition: -> $('#c_news #new_image_btn').length
  load: ->
    @map.submit_function ||= ->
      $(this).closest('form').attr('data-remote', 'true').submit(); false
      
    $(document).on 'click', '#new_image_btn', @map.submit_function
  unload: ->
    $(document).off 'click', '#new_image_btn', @map.submit_function
