defmodule UM.Web.Admin.Pieces.CreateForm do

  def validate(form) do

    validator = %{
      id: {:required, fn
        (x) ->
          case Integer.parse(x) do
            {i, ""} -> {:ok, i}
            _ -> {:error, :not_and_integer, x}
          end
      end},
      title: {:required, fn(x) -> {:ok, x} end},
      sub_heading: {:required, fn(x) -> {:ok, x} end},
      level_overview: {:required, fn(x) -> {:ok, x} end},
      description: {:required, fn(x) -> {:ok, x} end},
      solo: {:boolean, false},
      solo_with_accompaniment: {:boolean, false},
      duet: {:boolean, false},
      trio: {:boolean, false},
      quartet: {:boolean, false},
      larger_ensembles: {:boolean, false},
      collection: {:boolean, false},
      beginner: {:boolean, false},
      intermediate: {:boolean, false},
      advanced: {:boolean, false},
      professional: {:boolean, false},
      piano: {:boolean, false},
      recorder: {:boolean, false},
      flute: {:boolean, false},
      oboe: {:boolean, false},
      clarineo: {:boolean, false},
      clarinet: {:boolean, false},
      bassoon: {:boolean, false},
      saxophone: {:boolean, false},
      trumpet: {:boolean, false},
      violin: {:boolean, false},
      viola: {:boolean, false},
      percussion: {:boolean, false},
      notation_preview: {:optional, fn(x) -> {:ok, x} end}, # Hash
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
