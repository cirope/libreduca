jQuery ->
  $(document).on 'page:fetch', -> $('#loading_caption').show()
  $(document).on 'page:change', ->
    App.Load.pageLoad()
    $('#loading_caption').hide()
