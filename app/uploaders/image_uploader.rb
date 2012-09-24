# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  
  storage :file
  after :remove, :delete_empty_upstream_dirs

  version(:thumb)       { process resize_to_fit: [200, 200] }
  version(:mini_thumb)  { process resize_to_fit: [80, 80] }
  version(:micro_thumb) { process resize_to_fit: [40, 40] }

  def store_dir
    "#{base_store_dir}/#{('%08d' % model.id).scan(/\d{4}/).join('/')}"
  end

  def base_store_dir
    institution = model.institution.try(:identification) || RESERVED_SUBDOMAINS.first

    "private/#{institution}/#{model.class.to_s.underscore}/#{mounted_as}"
  end

  def delete_empty_upstream_dirs
    Dir.delete ::File.expand_path(store_dir, root)
    Dir.delete ::File.expand_path(base_store_dir, root)
  rescue SystemCallError
    true
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end
end
