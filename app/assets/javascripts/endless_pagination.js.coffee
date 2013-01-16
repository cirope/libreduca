new Rule
  condition: -> $('*[data-endless-container]').length
  load: ->
    @map.scroll_function ||= ->
      url = $('.pagination a.next').attr('href')
      atBottom = $(window).scrollTop() > $(document).height() - $(window).height() - 150
      
      if url and atBottom
        $('.pagination-container').html(
          $('<div class="alert"></div>').html($('#loading_caption').html())
        )

        $.getScript(url, -> $(document).scroll())

    $(document).on 'scroll touchmove', @map.scroll_function
    $(document).scroll()

  unload: -> $(document).off 'scroll touchmove', @map.scroll_function
