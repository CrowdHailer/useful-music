defmodule UM.Web.Admin.Pieces.CreateForm do

  def validate(form) do

    validator = %{
      id: WebForm.integer(min: 100, max: 999, required: true),
      title: {:required, fn(x) -> {:ok, x} end},
      sub_heading: {:required, fn(x) -> {:ok, x} end},
      level_overview: {:required, fn(x) -> {:ok, x} end},
      description: {:required, fn(x) -> {:ok, x} end},
      solo: WebForm.checkbox(),
      solo_with_accompaniment: WebForm.checkbox(),
      duet: WebForm.checkbox(),
      trio: WebForm.checkbox(),
      quartet: WebForm.checkbox(),
      larger_ensembles: WebForm.checkbox(),
      collection: WebForm.checkbox(),
      beginner: WebForm.checkbox(),
      intermediate: WebForm.checkbox(),
      advanced: WebForm.checkbox(),
      professional: WebForm.checkbox(),
      piano: WebForm.checkbox(),
      recorder: WebForm.checkbox(),
      flute: WebForm.checkbox(),
      oboe: WebForm.checkbox(),
      clarineo: WebForm.checkbox(),
      clarinet: WebForm.checkbox(),
      bassoon: WebForm.checkbox(),
      saxophone: WebForm.checkbox(),
      trumpet: WebForm.checkbox(),
      violin: WebForm.checkbox(),
      viola: WebForm.checkbox(),
      percussion: WebForm.checkbox(),
      notation_preview: {:optional, fn
        (%{content: ""}) -> {:ok, :file_not_provided}
        (x) -> {:ok, x}
      end}, # Hash
      audio_preview: {:optional, fn(x) -> {:ok, x} end}, # Hash
      cover_image: {:optional, fn(x) -> {:ok, x} end}, # Hash
      print_link: {:optional, fn(x) -> {:ok, x} end}, # String
      print_title: {:optional, fn(x) -> {:ok, x} end}, # String
      weezic_link: {:optional, fn(x) -> {:ok, x} end}, # String
      meta_description: {:optional, fn(x) -> {:ok, x} end}, # String
      meta_keywords: {:optional, fn(x) -> {:ok, x} end}, # String
    }
    WebForm.validate(validator, form)
  end
end
