class AudioPreviewUploader < CarrierWave::Uploader::Base
  # include CarrierWave::MiniMagick

  def extension_white_list
    %w(mp3)
  end

  def store_dir
    super + "/pieces/#{model.id}"
  end

  def filename
    'audio_preview.mp3' if file
  end

end
