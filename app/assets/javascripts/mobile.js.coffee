if navigator.userAgent.match(/mobi|mini|fennec/i) && window.screen.width <= 800
  App.Load.registerOnLoad -> setTimeout(window.scrollTo(0, 1), 1000)
  App.Load.registerOnLoad -> $('.nav-collapse').collapse('hide')
