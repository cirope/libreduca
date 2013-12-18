module FlashHelper
  def flash_message
    flash[:alert] || flash[:notice]
  end

  def flash_class
    flash[:alert] ? 'alert-danger' : 'alert-info'
  end
end
