jQuery ($) ->
  $(document).on 'change', 'input.autocomplete_field', ->
    if /^\s*$/.test($(this).val())
      $($(this).data('autocompleteIdTarget')).val('')

  $(document).on 'focus', 'input.autocomplete_field:not([data-observed])', ->
    input = $(this)

    input.autocomplete
      source: (request, response) ->
        $.ajax
          url: input.data('autocompleteUrl')
          dataType: 'json'
          data: { q: request.term }
          success: (data)->
            response $.map data, (item) ->
              content = $('<div></div>')

              content.append item.label

              if item.informal
                content.append item.informal

              { label: content.html(), value: item.label, item: item }
      type: 'get'
      minLength: input.data('autocompleteMinLength')
      select: (event, ui) ->
        selected = ui.item

        input.val(selected.value)
        input.data('item', selected.item)
        $(input.data('autocompleteIdTarget')).val(selected.item.id)

        input.trigger 'autocomplete:update', input

        false
      open: -> $('.ui-menu').css('width', input.width())

    input.data('autocomplete')._renderItem = (ul, item) ->
      $('<li></li>').data('item.autocomplete', item).append(
        $('<a></a>').html(item.label)
      ).appendTo(ul)
  .attr('data-observed', true)
