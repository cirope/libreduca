class FileUploadHelper
  constructor: (@file, @element, @data) ->
    @errorElement = @element.data('fileupload-error-message')

  allowType: ->
    types = @element.data('fileupload-types')
    typesRegExp = new RegExp "(\.|\/)(#{types.join('|')})$", 'i' if types

    !types? || typesRegExp.test(@file.type) || typesRegExp.test(@file.name)
  drawTemplate: ->
    @data.context = $('<div></div>').html tmpl('template-upload', @file)

    @hideErrorMessage()
    @element.hide().before(@data.context)
  evalAutosubmit: ->
    if @element.data('fileupload-autosubmit')
      @submit()
    else
      _this = this

      @element.parents('form:first').find(
        ':submit:not([data-observed])'
      ).click(-> _this.submit(); false).attr('data-observed', 'true')
  showErrorMessage: ->
    $(@errorElement).removeClass('hide').alert() if @errorElement
  hideErrorMessage: ->
    $(@errorElement).alert('close') if @errorElement
  submit: ->
    @data.context.find('.message').show() if @data.context
    @data.submit()

jQuery ($) ->
  $(document).on 'click focus keydown drop', 'input[data-fileupload]:not([data-observed])', ->
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
