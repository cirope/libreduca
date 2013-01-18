# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
new Rule
  condition: -> $('#c_teaches').length
  load: ->
    @map.replace_function ||= (event, data)->
      console.log($(this))
      console.log(data)

    $(document).on 'autocomplete:update', 'form[data-remote]', @map.replace_function
  unload: ->
    $(document).off 'autocomplete:update', 'form[data-remote]', @map.replace_function