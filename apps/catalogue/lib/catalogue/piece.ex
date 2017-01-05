defmodule UM.Catalogue.Piece do
  @all_instruments [:piano,
    :recorder,
    :flute,
    :oboe,
    :clarineo,
    :clarinet,
    :bassoon,
    :saxophone,
    :trumpet,
    :violin,
    :viola]

  @all_levels [
    :beginner,
    :intermediate,
    :advanced,
    :professional]

  @all_categories [:solo,
    :solo_with_accompaniment,
    :duet,
    :trio,
    :quartet,
    :larger_ensembles]

  defstruct ([
    id: nil, # Integer
    title: nil, # String
    sub_heading: nil, # String
    level_overview: nil, # String
    description: nil, # String
    ] ++ for c <- (@all_instruments ++ @all_levels ++ @all_categories) do
      {c, false}
    end ++ [
    collection: false,
    percussion: false,
    notation_preview: nil, # Hash
    audio_preview: nil, # Hash
    cover_image: nil, # Hash
    print_link: nil, # String
    print_title: nil, # String
    weezic_link: nil, # String
    meta_description: nil, # String
    meta_keywords: nil, # String
    items: :not_loaded
  ])

  def catalogue_number(%{id: id}) do
    "UD#{id}"
  end

  def product_name(%{title: title, sub_heading: sub_heading}) do
    "#{title} - #{sub_heading}"
  end

  # score types
  def categories(piece) do
    Enum.filter(all_categories, fn (key) ->
      {:ok, bool} = Map.fetch(piece, key)
      bool
    end)
  end

  def instruments(piece) do
    Enum.filter(all_instruments, fn (key) ->
      {:ok, bool} = Map.fetch(piece, key)
      bool
    end)
  end

  def levels(piece) do
    Enum.filter(all_levels, fn (key) ->
      {:ok, bool} = Map.fetch(piece, key)
      bool
    end)
  end

  def all_instruments do
    @all_instruments
  end

  def all_levels do
    @all_levels
  end

  def all_categories do
    @all_categories
  end

# DEBT these belong in a View layer
  def description_summary(%{description: description}, length \\ 12) do
    String.slice(description, 0, length)
  end

  def notation_preview_url(piece, default \\ nil) do
    if piece.notation_preview do
      UM.Catalogue.PieceStorage.url({piece.notation_preview, piece}, :original, signed: true)
    else
      default
    end
  end

  def cover_image_url(piece, default \\ nil) do
    if piece.cover_image do
      UM.Catalogue.PieceStorage.url({piece.cover_image, piece}, :original, signed: true)
    else
      default
    end
  end

  def audio_preview_url(piece, default \\ nil) do
    if piece.audio_preview do
      UM.Catalogue.PieceStorage.url({piece.audio_preview, piece}, :original, signed: true)
    else
      default
    end
  end
end
