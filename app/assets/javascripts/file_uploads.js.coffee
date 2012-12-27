App.Event.registerEvent(
  condition: -> $('[data-fileupload]').length
  type: 'click focus keydown drop'
  selector: '[data-fileupload]:not([data-observed])'
  handler: ->
    $(this).fileupload(
      dataType: 'script'
      add: (e, data) ->
        file = data.files[0]
        element = $(e.target)
        errorElement = element.data('fileupload-error-message')
        types = element.data('fileupload-types')
        typesRegExp = new RegExp "(\.|\/)(#{types.join('|')})$", 'i' if types

        if !types? || typesRegExp.test(file.type) || typesRegExp.test(file.name)
          data.context = $(tmpl('template-upload', file))

          $(errorElement).alert('close') if errorElement
          element.hide().before(data.context)

          if element.data('fileupload-autosubmit')
            data.submit()
          else
            element.parents('form:first').find(':submit').click ->
              data.submit()

              false
        else
          $(errorElement).removeClass('hide').alert() if errorElement
      progress: (e, data) ->
        if data.context
          progress = parseInt(data.loaded / data.total * 100, 10)
          data.context.find('.bar').css('width', "#{progress}%")
      done: (e, data) ->
        data.context.find('.bar').css('width', '100%') if data.context
    ).data('observed', true)
)
