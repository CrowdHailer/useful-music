defmodule UM.Catalogue.ItemStorage do
  use Arc.Definition

  if Mix.env == :test do
     def __storage, do: Arc.Storage.Local # Add this
  end

  def storage_dir(:original, {_file, %{piece_id: piece_id}}) do
    "uploads/pieces/UD#{piece_id}/items"
  end

  # The filename callback is only to differentiate between versions,
  # such as :original and :thumbnail

  # DEBT allowed extenstions .pdf
  def save_asset(%{content: binary, filename: filename}, item = %{piece_id: piece_id, name: asset_name}) do
    asset_name = String.replace(asset_name, " ", "_")
    filename = "UD#{piece_id}_#{asset_name}" <> Path.extname(filename)
    store({%{filename: filename, binary: binary}, item})
  end
end
