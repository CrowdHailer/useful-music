defmodule UM.Web.Admin.PiecesController.CreateForm do
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
      notation_preview: WebForm.file(empty: {:ok, nil}),
      audio_preview: WebForm.file(empty: {:ok, nil}),
      cover_image: WebForm.file(empty: {:ok, nil}),
      print_link: any(),
      print_title: any(),
      weezic_link: any(),
      meta_description: any(),
      meta_keywords: any(),
    }
    WebForm.validate(validator, form)
  end
end
