App.Event.registerEvent(
  condition: -> $('.nav-tabs[data-remote]').length
  type: 'show'
  selector: '.nav-tabs[data-remote]'
  handler: (event)->
    tab = $(event.target)

    if tab.data('remote-url')
      tabID = tab.attr('href')

      unless $(tabID).data('loaded')
        $(tabID).load($(event.target).data('remote-url')).data 'loaded', true
)
