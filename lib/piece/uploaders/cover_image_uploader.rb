class CoverImageUploader < CarrierWave::Uploader::Base
  # include CarrierWave::MiniMagick

  def extension_white_list
    %w(jpg)
  end

  def store_dir
    super + "/pieces/#{model.catalogue_number}"
  end

  def filename
    'notation_preview.jpg' if file
  end

end
