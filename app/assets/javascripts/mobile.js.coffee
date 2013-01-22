new Rule
  condition: ->
    navigator.userAgent.match(/mobi|mini|fennec/i) && window.screen.width <= 800

  load: ->
    $('.nav-collapse').collapse('hide')

    @map.timer = setTimeout(window.scrollTo(0, 1), 1000)

  unload: -> clearTimeout @map.timer
