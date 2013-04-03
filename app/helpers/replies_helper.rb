module RepliesHelper
  def reply_rendered_inline?
    request.xhr? || controller_name != 'replies'
  end

  def reply_form_options
    { html: { id: "question_#{@question.to_param}_form" }, remote: reply_rendered_inline? }
  end
end
