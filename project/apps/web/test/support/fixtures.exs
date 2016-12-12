defmodule UM.Web.Fixtures do
  import Moebius.Query

  def clear_db do
    db(:purchases) |> delete |> Moebius.Db.run
    db(:items) |> delete |> Moebius.Db.run
    db(:pieces) |> delete |> Moebius.Db.run
    db(:customers) |> delete |> Moebius.Db.run
    :ok
  end

  def garden_tiger do
    db(:pieces)
    |> insert(
      id: 477,
      title: "The Garden Tiger",
      sub_heading: "Flute and piano",
      description: "The music alternates between Jazz/Rock and Bossa Nova. Besides solo flute, suitable for flutes in unison. Extra licences for flute parts are half price.",
      level_overview: "Level 4 to 6",
      notation_preview: "UD477_notation_preview.pdf",
      cover_image: "UD477_cover_image.jpg",
      audio_preview: "UD477_audio_preview.mp3",
      solo: true,
      solo_with_accompaniment: true,
      intermediate: true,
      flute: true,
      piano: true
    )
    |> Moebius.Db.run
  end

  def bugs_bunny do
    db(:customers)
    |> insert(
      id: "bugs-bunny-admin",
      first_name: "Bugs",
      last_name: "Bunny",
      email: "bugs@hotmail.com",
      password: "password",
      country: "GB",
      admin: true
    )
    |> Moebius.Db.run
  end
end
