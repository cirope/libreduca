jQuery ($)->
  if navigator.userAgent.match(/mobi|mini|fennec/i) && window.screen.width <= 800
    # Hide the address bar
    window.scrollTo(0, 1).delay 1000