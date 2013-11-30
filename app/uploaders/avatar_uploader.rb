# encoding: utf-8

class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file
  after :remove, :delete_empty_upstream_dirs

  version(:thumb)       { process resize_to_fill: [200, 200] }
  version(:mini_thumb)  { process resize_to_fill: [80, 80] }
  version(:micro_thumb) { process resize_to_fill: [40, 40] }

  def url
    super.to_s.sub(/^\/public/, '')
  end

  def store_dir
    "#{base_store_dir}/#{('%08d' % model.id).scan(/\d{4}/).join('/')}"
  end

  def base_store_dir
    "public/system/avatars/#{model.class.to_s.underscore}/#{mounted_as}"
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
