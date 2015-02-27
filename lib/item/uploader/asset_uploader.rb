class AssetUploader < CarrierWave::Uploader::Base
  # include CarrierWave::MiniMagick

  # def extension_white_list
  #   %w(mp3)
  # end

  def store_dir
    super + "/pieces/UD#{model.piece_record.id}/items"
  end

  def filename
    "UD#{model.piece_record.id}_#{model.name.gsub(' ', '_') if model.name}.#{file.extension.downcase}" if file
  end

end
