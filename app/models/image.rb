class Image < ActiveRecord::Base
  mount_uploader :file, ImageUploader
  
  has_paper_trail

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :file, :file_cache, :lock_version

  # Not modificable attributes
  attr_readonly :institution_id

  # Defaul order
  default_scope order("#{table_name}.name ASC")

  # Callbacks
  before_save :update_file_attributes
  
  # Validations
  validates :name, :file, :institution, presence: true
  validates :name, length: { maximum: 255 }, allow_nil: true, allow_blank: true

  # Relations
  belongs_to :institution

  def to_s
    self.name
  end

  def as_json(options = nil)
    default_options = {
      only: [:name],
      methods: [:to_md, :to_html]
    }
    
    super(default_options.merge(options || {}))
  end

  def to_md(version = nil)
    "![#{self}](#{get_version(version).url} '#{self}')"
  end

  def to_html(version = nil)
    attributes = {
      src: get_version(version).url,
      alt: self.to_s,
      title: self.to_s,
      class: 'img-rounded'
    }

    attributes[:width], attributes[:height] = self.dimensions(version)

    "<img #{attributes.map { |k, v| "#{k}=\"#{v}\"" }.join(' ')} />"
  end

  def dimensions(version = nil)
    MiniMagick::Image.open(get_version(version).path)['dimensions']
  end

  private

  def get_version(version = nil)
    version ? self.file.send(version) : self.file
  end

  def update_file_attributes
    if file.present? && file_changed?
      self.content_type = file.file.content_type
      self.content_type ||= Mime::Type.lookup_by_extension(file.file.extension)
      self.file_size = file.file.size
    end
  end
end
