class NotationPreviewUploader < CarrierWave::Uploader::Base
  # include CarrierWave::MiniMagick

  def extension_white_list
    %w(pdf)
  end

  def store_dir
    super + "/pieces/#{model.catalogue_number}"
  end

  def filename
    'notation_preview.pdf' if file
  end

end