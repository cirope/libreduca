if navigator.userAgent.match(/mobi|mini|fennec/i) && window.screen.width <= 800
  App.Load.registerOnLoad -> setTimeout(window.scrollTo(0, 1), 1000)
  App.Load.registerOnLoad -> $('.nav-collapse').collapse('hide')

  # Temporary solution until https://github.com/twitter/bootstrap/issues/5900
  # gets fixed
  $('a.dropdown-toggle, .dropdown-menu a').on 'touchstart', (e)->
    e.stopPropagation()
