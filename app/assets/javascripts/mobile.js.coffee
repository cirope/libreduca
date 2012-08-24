jQuery ($)->
  if navigator.userAgent.match(/mobi|mini|fennec/i) && window.screen.width <= 800
    hideAddressBar = -> setTimeout window.scrollTo(0, 1), 1000

    hideAddressBar()
    App.onEveryLoad.push hideAddressBar
