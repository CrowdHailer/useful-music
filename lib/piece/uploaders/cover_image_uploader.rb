class CoverImageUploader < CarrierWave::Uploader::Base
  # include CarrierWave::MiniMagick

  def extension_white_list
    %w(jpg)
  end

  def store_dir
    super + "/pieces/UD#{model.id}"
  end

  def filename
    'cover_image.jpg' if file
  end

end
