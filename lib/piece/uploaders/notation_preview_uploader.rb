class NotationPreviewUploader < CarrierWave::Uploader::Base
  # include CarrierWave::MiniMagick

  def extension_white_list
    %w(pdf)
  end

  def store_dir
    super + "/pieces/UD#{model.id}"
  end

  def filename
    "UD#{model.id}_notation_preview.pdf" if file
  end

end
