window.App = {}

window.App.Event =
  registeredEvents: []
  loadedEvents: []
  registerEvent: (event)-> App.Event.registeredEvents.push event
  loadEvents: ->
    jQuery.each App.Event.registeredEvents, (i, e)->
      if e.condition()
        App.Event.loadedEvents.push e
        $(document).on(e.type, e.selector, e.handler)
  unLoadEvents: ->
    jQuery.each App.Event.loadedEvents, (i, e)->
      $(document).off(e.type, e.selector, e.handler)
  reloadEvents: ->
    App.Event.unLoadEvents()
    App.Event.loadEvents()

window.App.Load =
  # Functions to call on each load of Turbolinks and no Turbolinks
  onEveryLoad: [
    ->
      # For browsers with no autofocus support
      $('[autofocus]:not([readonly]):not([disabled]):visible:first').focus()
      $('[data-show-tooltip]').tooltip()
      $('[data-show-popover]').popover(trigger: 'hover')

      $('.alert[data-close-after]').each (i, a)->
        clickClose = -> $(a).find('a.close').trigger('click')

        setTimeout clickClose, $(a).data('close-after')

      App.Event.reloadEvents()
  ]
  registerOnLoad: (onLoad) -> App.Load.onEveryLoad.push onLoad
  pageLoad: -> jQuery.each(App.Load.onEveryLoad, (i, f)-> f())

jQuery ($)->
  $(document).on 'click', 'a.submit', -> $('form').submit(); false
  
  $(document).on 'click', 'a[data-remote][data-loading-text]', ->
    $(this).button('loading')
  
  $('#loading_caption').bind
    ajaxStart: `function() { $(this).stop(true, true).fadeIn(100) }`
    ajaxStop: `function() { $(this).stop(true, true).fadeOut(100) }`
  
  $(document).on 'submit', 'form', ->
    $(this).find('input[type="submit"], input[name="utf8"]')
    .attr 'disabled', true
    $(this).find('a.submit').removeClass('submit').addClass('disabled')
    $(this).find('.dropdown-toggle').addClass('disabled')

  App.Load.pageLoad()
