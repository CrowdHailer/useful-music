defmodule UM.Web.Admin.Pieces.CreateForm do
  import UM.Web.FormFields

  def validate(form) do
    validator = %{
      id: WebForm.integer(min: 100, max: 999, required: true),
      title: any(required: true),
      sub_heading: any(required: true),
      level_overview: any(required: true),
      description: any(required: true),
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
      notation_preview: WebForm.field(fn
        (%{content: ""}) -> {:ok, :file_not_provided}
        (x) -> {:ok, x}
      end), # Hash
      audio_preview: any(), # Hash
      cover_image: any(), # Hash
      print_link: any(), # String
      print_title: any(), # String
      weezic_link: any(), # String
      meta_description: any(), # String
      meta_keywords: any(), # String
    }
    WebForm.validate(validator, form)
  end
end
