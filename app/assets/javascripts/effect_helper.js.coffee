@EffectHelper =
  hide: (element, callback) -> $(element).stop().fadeOut(200, callback)

  remove: (element, callback) ->
    $(element).stop().fadeOut 200, -> callback?(); $(this).remove()

  show: (e, callback) -> $(e).stop().fadeIn(1000, callback)
