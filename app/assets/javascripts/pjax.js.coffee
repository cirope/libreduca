jQuery ($)->
  if $.support.pjax
    $(document).on 'pjax:success', '[data-pjax-container]', (e, data, st, xhr)->
      $('head title').html xhr.getResponseHeader('X-PJAX-Title')
      controller = xhr.getResponseHeader('X-PJAX-Controller')

      $('body').attr('id', "c_#{controller}").attr(
        'data-action', xhr.getResponseHeader('X-PJAX-Action')
      )

      if xhr.getResponseHeader('X-PJAX-Searchable')
        $('.navbar form.navbar-search').removeClass('hidden')
      else
        $('.navbar form.navbar-search').addClass('hidden')

      $('.navbar .nav *[data-controllers]').each ->
        if $.inArray(controller, $(this).data('controllers')) != -1
          newAction = $(this).find('a').attr('href')

          $(this).addClass('active')
          $('.navbar form.navbar-search').attr 'action', newAction

      App.Load.pageLoad()

    $(document).on 'pjax:start', '[data-pjax-container]', ->
      $('input.search-query').val('')
      $('.navbar .nav .active').removeClass('active')
      $('[data-show-tooltip]').tooltip('destroy')
      $('[data-show-popover]').popover('destroy')
