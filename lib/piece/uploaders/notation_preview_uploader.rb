class NotationPreviewUploader < CarrierWave::Uploader::Base
  # include CarrierWave::MiniMagick

  def extension_white_list
    %w(pdf)
  end

  def store_dir
    super + "/pieces/#{model.id}"
  end

  def filename
    'notation_preview.pdf' if file
  end

  def default_url
    'standin url'
  end

end
