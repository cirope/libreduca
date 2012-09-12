window.DynamicFormEvent =
  addNestedItem: (e)->
    template = e.data('dynamic-template')
    regexp = new RegExp(e.data('id'), 'g')

    $(e.data('dynamic-container')).append(
      DynamicFormHelper.replaceIds(template, regexp)
    )
    
    e.trigger('dynamic-item.added', e)

  hideItem: (e)->
    EffectHelper.hide e.parents(e.data('dynamic-target'))
    
    e.prev('input[type=hidden].destroy').val('1').trigger(
      'dynamic-item.hidden', e
    )

  removeItem: (e)->
    target = e.parents e.data('dynamic-target')

    EffectHelper.remove target, ->
      $(document).trigger('dynamic-item.removed', target)
    
window.DynamicFormHelper =
  newIdCounter: 0,
  
  replaceIds: (s, regex)->
    s.replace(regex, new Date().getTime() + DynamicFormHelper.newIdCounter++)
    
jQuery ($)->
  eventList = $.map DynamicFormEvent, (v, k)-> k
  
  $(document).on 'click', 'a[data-dynamic-form-event]', (event)->
    return if event.stopped
    
    eventName = $(this).data('dynamic-form-event')

    if $.inArray(eventName, eventList) != -1
      DynamicFormEvent[eventName]($(this))
      
      event.preventDefault()
      event.stopPropagation()
