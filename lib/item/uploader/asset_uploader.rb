class AssetUploader < CarrierWave::Uploader::Base
  # include CarrierWave::MiniMagick

  # def extension_white_list
  #   %w(mp3)
  # end

  def store_dir
    super + "/items/#{model.id}"
  end

  # def filename
  #   'audio.mp3' if file
  # end

end
