new Rule
  condition: -> $('#c_news #new_image_btn').length
  load: ->
    @map.submit_function ||= ->
      $(this).closest('form').attr('data-remote', 'true').submit(); false
      
    $(document).on 'click', '#new_image_btn', @map.submit_function
  unload: ->
    $(document).off 'click', '#new_image_btn', @map.submit_function

new Rule
  condition: -> $('.custom-nav').length
  load: ->
    @map.login_tabs ||= ->
      return false;

    $(document).on 'click', '.custom-nav', @map.login_tabs
  unload: ->
    $(document).off 'click', '.custom-nav', @map.login_tabs
