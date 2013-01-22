new Rule
  condition: -> $('#comment_comment').length
  load: ->
    @map.focus_function ||= -> $(this).attr('rows', '6')

    $(document).on 'focus', '#comment_comment', @map.focus_function
  unload: ->
    $(document).off 'focus', '#comment_comment', @map.focus_function
