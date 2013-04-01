new Rule
  condition: -> $('#c_surveys [data-action="edit"]')
  load: ->
    @map.replace_template = ->
      container = $(this).closest('fieldset').find('[data-question-type-template]')
      templates = $(this).data('question-type-templates')
      type = $(this).val()

      container.html(templates[type]).effect('highlight', 'slow')
      container.attr('data-question-type', type) # For integration test purposes

    $(document).on 'change', 'select[data-question-type-templates]', @map.replace_template
  unload: ->
    $(document).off 'change', 'select[data-question-type-templates]', @map.replace_template
