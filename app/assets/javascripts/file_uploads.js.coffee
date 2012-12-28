class FileUploadHelper
  constructor: (@file, @element, @data) ->
    @errorElement = @element.data('fileupload-error-message')

  allowType: ->
    types = @element.data('fileupload-types')
    typesRegExp = new RegExp "(\.|\/)(#{types.join('|')})$", 'i' if types

    !types? || typesRegExp.test(@file.type) || typesRegExp.test(@file.name)
  drawTemplate: ->
    @data.context = $(tmpl('template-upload', @file))

    @hideErrorMessage()
    @element.hide().before(@data.context)
  evalAutosubmit: ->
    if @element.data('fileupload-autosubmit')
      @data.submit()
    else
      @element.parents('form:first').find(
        ':submit:not([data-observed])'
      ).click(-> @data.submit(); false).attr('data-observed', 'true')
  showErrorMessage: ->
    $(@errorElement).removeClass('hide').alert() if @errorElement
  hideErrorMessage: ->
    $(@errorElement).alert('close') if @errorElement

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
        fileUploadHelper = new FileUploadHelper(file, element, data)

        if fileUploadHelper.allowType()
          fileUploadHelper.drawTemplate()
          fileUploadHelper.evalAutosubmit()
        else
          fileUploadHelper.showErrorMessage()
      progress: (e, data) ->
        if data.context
          progress = parseInt(data.loaded / data.total * 100, 10)
          data.context.find('.bar').css('width', "#{progress}%")
      done: (e, data) ->
        data.context.find('.bar').css('width', '100%') if data.context
    ).attr('data-observed', true)
)
