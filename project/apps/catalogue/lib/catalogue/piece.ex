defmodule UM.Catalogue.Piece do
  defstruct [
    id: "", # Integer
    title: "", # String
    sub_heading: "", # String
    level_overview: "", # String
    description: "", # String
    solo: "", # String, think this is a lie and these are booleans
    solo_with_accompaniment: "", # String
    duet: "", # String
    trio: "", # String
    quartet: "", # String
    larger_ensembles: "", # String
    collection: "", # String
    beginner: "", # Boolean
    intermediate: "", # Boolean
    advanced: "", # Boolean
    professional: "", # Boolean
    piano: "", # Boolean
    recorder: "", # Boolean
    flute: "", # Boolean
    oboe: "", # Boolean
    clarineo: "", # Boolean
    clarinet: "", # Boolean
    bassoon: "", # Boolean
    saxophone: "", # Boolean
    trumpet: "", # Boolean
    violin: "", # Boolean
    viola: "", # Boolean
    percussion: "", # Boolean
    notation_preview: "", # Hash
    audio_preview: "", # Hash
    cover_image: "", # Hash
    print_link: "", # String
    print_title: "", # String
    weezic_link: "", # String
    meta_description: "", # String
    meta_keywords: "", # String
  ]

  def catalogue_number(%{id: id}) do
    "UM#{id}"
  end
end
