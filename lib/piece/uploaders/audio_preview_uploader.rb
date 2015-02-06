class AudioPreviewUploader < CarrierWave::Uploader::Base
  # include CarrierWave::MiniMagick

  def extension_white_list
    %w(mp3)
  end

  def store_dir
    super + "/pieces/#{model.catalogue_number}"
  end

  def filename
    'audio.mp3' if file
  end

end
