jQuery ($) ->
  $(document).on 'page:fetch', -> $('.loading-caption').removeClass('hidden')
  $(document).on 'page:change', ->
    Inspector.instance().reload()
    $('.loading-caption').addClass('hidden')
