Autocomplete =
  source: (input, request, response) ->
    jQuery.ajax
      url: input.data('autocompleteUrl')
      dataType: 'json'
      data: { q: request.term }
      success: (data) ->
        response jQuery.map data, (item) -> Autocomplete.renderResponse item

  renderResponse: (item) ->
    content = $ '<div></div>'
    item.label ||= item.name

    content.append $('<span class="title"></span>').text item.label
    content.append $('<small></small>').text item.informal if item.informal

    { label: content.html(), value: item.label, item: item }

  selected: (input, event, ui) ->
    selected = ui.item

    input.val selected.value
    input.data 'item', selected.item
    $(input.data('autocompleteIdTarget')).val selected.item.id

    input.trigger 'autocomplete:update', input

    false

  renderItem: (ul, item) ->
    $('<li></li>').data('item.autocomplete', item).append($('<a></a>').html(item.label)).appendTo ul


jQuery ($) ->
  $(document).on 'change', 'input[data-autocomplete-url]', ->
    if /^\s*$/.test($(this).val())
      $($(this).data('autocompleteIdTarget')).val ''

  $(document).on 'focus', 'input[data-autocomplete-url]:not([data-observed])', ->
    input = $(this)

    input.autocomplete
      source: (request, response) -> Autocomplete.source input, request, response
      type: 'get'
      minLength: input.data('autocompleteMinLength')
      select: (event, ui) -> Autocomplete.selected input, event, ui
      open: -> $('.ui-menu').css 'width', input.outerWidth()

    input.data('ui-autocomplete')._renderItem = Autocomplete.renderItem

    input.attr 'data-observed', true

  $('[autofocus]:first').focus()
