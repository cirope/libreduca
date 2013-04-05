module NotifierHelper
  def comment_url
    if @commentable.respond_to?(:owner)
      polymorphic_url([@commentable.owner, @commentable], 
        anchor: @comment.anchor, subdomain: @institution.identification
      )
    elsif @commentable.respond_to?(:conversable)
      polymorphic_url([@commentable.conversable, @commentable], 
        anchor: @comment.anchor, subdomain: @institution.identification
      )
    end
  end
end
