new Rule
  load: ->
    # For browsers with no autofocus support
    $('[autofocus]:not([readonly]):not([disabled]):visible:first').focus()
    $('[data-show-tooltip]').tooltip()
    $('[data-show-popover]').popover(trigger: 'hover', html: true)

    timers = @map.timers = []

    $('.alert[data-close-after]').each (i, a)->
      timers.push setTimeout((-> $(a).alert('close')), $(a).data('close-after'))

  unload: -> clearTimeout timer for i, timer of @map.timers

jQuery ($) ->
  $(document).on 'click', 'a.submit', -> $(this).closest('form').submit(); false

  $(document).ajaxStart ->
    $('.loading-caption').removeClass('hidden')
  .ajaxStop ->
    $('.loading-caption').addClass('hidden')

  $(document).on 'submit', 'form', ->
    $(this).find('input[type="submit"], input[name="utf8"]').attr 'disabled', true
    $(this).find('a.submit').removeClass('submit').addClass('disabled')
    $(this).find('.dropdown-toggle').addClass('disabled')

  Inspector.instance().load()
