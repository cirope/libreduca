new Rule
  condition: -> $('.nav-tabs[data-remote]').length
  load: ->
    @map.remote_tab_function ||= (event)->
      tab = $(event.target)

      if tab.data('remote-url')
        tabID = tab.attr('href')

        unless $(tabID).data('loaded')
          $(tabID).load($(event.target).data('remote-url')).data 'loaded', true

    $(document).on 'show', '.nav-tabs[data-remote]', @map.remote_tab_function
  unload: ->
    $(document).off 'show', '.nav-tabs[data-remote]', @map.remote_tab_function
