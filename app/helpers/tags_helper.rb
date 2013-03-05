module TagsHelper
  def show_tags_nav(taggable, options = {})
    tags = []

    taggable.taggings.each do |tagging|
      tag = tagging.tag
      tags << (link_to tag, polymorphic_path([tag, taggable.class], options))
    end

    tags.join(', ')
  end
end
