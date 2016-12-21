defmodule UM.Catalogue.Piece do
  defstruct [
    id: nil, # Integer
    title: "", # String
    sub_heading: "", # String
    level_overview: "", # String
    description: "", # String
    solo: false,
    solo_with_accompaniment: false,
    duet: false,
    trio: false,
    quartet: false,
    larger_ensembles: false,
    collection: false,
    beginner: false,
    intermediate: false,
    advanced: false,
    professional: false,
    piano: false,
    recorder: false,
    flute: false,
    oboe: false,
    clarineo: false,
    clarinet: false,
    bassoon: false,
    saxophone: false,
    trumpet: false,
    violin: false,
    viola: false,
    percussion: false,
    notation_preview: "", # Hash
    audio_preview: "", # Hash
    cover_image: "", # Hash
    print_link: "", # String
    print_title: "", # String
    weezic_link: "", # String
    meta_description: "", # String
    meta_keywords: "", # String
    items: :not_loaded
  ]

  def catalogue_number(%{id: id}) do
    "UD#{id}"
  end

  def product_name(%{title: title, sub_heading: sub_heading}) do
    "#{title} - #{sub_heading}"
  end

  def categories(piece) do
    Enum.filter([:solo,
    :solo_with_accompaniment,
    :duet,
    :trio,
    :quartet,
    :larger_ensembles], fn (key) ->
      {:ok, bool} = Map.fetch(piece, key)
      bool
    end)
  end

  def instruments(piece) do
    Enum.filter([:piano,
    :recorder,
    :flute,
    :oboe,
    :clarineo,
    :clarinet,
    :bassoon,
    :saxophone,
    :trumpet,
    :violin,
    :viola,
    :percussion], fn (key) ->
      {:ok, bool} = Map.fetch(piece, key)
      bool
    end)
  end

  def levels(piece) do
    Enum.filter([:beginner,
    :intermediate,
    :advanced,
    :professional], fn (key) ->
      {:ok, bool} = Map.fetch(piece, key)
      bool
    end)
  end

  def all_instruments do
    [:piano,
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
  end

  def all_levels do
    [:beginner,
    :intermediate,
    :advanced,
    :professional]
  end

  def all_categories do
    [:solo,
    :solo_with_accompaniment,
    :duet,
    :trio,
    :quartet,
    :larger_ensembles]
  end

  def notation_preview_url(piece) do
    UM.Catalogue.PieceStorage.url({piece.notation_preview, piece}, :original, signed: true)
  end

  def cover_image_url(piece) do
    UM.Catalogue.PieceStorage.url({piece.cover_image, piece}, :original, signed: true)
  end

  def audio_preview_url(piece) do
    UM.Catalogue.PieceStorage.url({piece.audio_preview, piece}, :original, signed: true)
  end
end
