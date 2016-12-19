defmodule UM.Catalogue.PieceStorage do
  use Arc.Definition

  if Mix.env == :test do
     def __storage, do: Arc.Storage.Local # Add this
  end

  def storage_dir(:original, {_file, %{id: id}}) do
    "uploads/pieces/UD#{id}"
  end

  # The filename callback is only to differentiate between versions,
  # such as :original and :thumbnail

  # DEBT allowed extenstions .pdf
  def save_notation_preview(%{content: binary, filename: filename}, %{id: id}) do
    filename = "UD#{id}_notation_preview" <> Path.extname(filename)
    store({%{filename: filename, binary: binary}, %{id: id}})
  end

  # DEBT allowed extenstions .jpg
  def save_cover_image(%{content: binary, filename: filename}, %{id: id}) do
    filename = "UD#{id}_cover_image" <> Path.extname(filename)
    store({%{filename: filename, binary: binary}, %{id: id}})
  end

  # DEBT allowed extenstions .mp3
  def save_audio_preview(%{content: binary, filename: filename}, %{id: id}) do
    filename = "UD#{id}_audio_preview" <> Path.extname(filename)
    store({%{filename: filename, binary: binary}, %{id: id}})
  end
end
