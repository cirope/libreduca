App.Event.registerEvent(
  condition: -> $('#c_users #user_email:not([data-disabled-search=true])').length
  type: 'change'
  selector: 'form.new_user input#user_email'
  handler: -> $.get('/users/find_by_email', q: $(this).val())
)
