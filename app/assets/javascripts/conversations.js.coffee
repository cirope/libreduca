new Rule
  condition: -> $('#c_contents .messages').length
  load: ->
    @map.popover_actions ||= ->
      $(this).removeAttr('data-remote')
      $(this).siblings('.popover').find('textarea').focus
      $(this).click ->
        return false

    $(document).on 'click', '.messages', @map.popover_actions
  unload: ->
    $(document).off 'click', '.messages', @map.popover_actions
