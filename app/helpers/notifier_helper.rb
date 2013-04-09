module NotifierHelper
  def comment_url
    if @commentable.respond_to?(:owner)
      polymorphic_url([@commentable.owner, @commentable], 
        show_comment_id: @comment.to_param, 
        anchor: @comment.anchor, 
        subdomain: @institution.identification
      )
    else
      polymorphic_url([@commentable, Comment], 
        show_comment_id: @comment.to_param, 
        anchor: @comment.anchor, 
        subdomain: @institution.identification
      )
    end
  end
end
