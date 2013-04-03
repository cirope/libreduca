$(document).on 'change', 'form [data-autosubmit-on-change]', -> $(this).closest('form').submit()
