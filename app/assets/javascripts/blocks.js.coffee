new Rule
  condition: -> $('.sortable').length
  load: ->
    $('.sortable').sortable
      axis: 'y'
      handle: '.handle'
      cursor: 'move'
      connectWith: '.con'
      update: ->
        $.post($(this).data('update-url'), $(this).sortable('serialize'))
    .addClass('con')
