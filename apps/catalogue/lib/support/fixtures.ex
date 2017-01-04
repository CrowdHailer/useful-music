defmodule UM.Catalogue.Fixtures do
  import Moebius.Query

  def clear_db do
    db(:purchases) |> delete |> Moebius.Db.run
    db(:items) |> delete |> Moebius.Db.run
    db(:pieces) |> delete |> Moebius.Db.run
    db(:customers) |> delete |> Moebius.Db.run
    db(:shopping_baskets) |> delete |> Moebius.Db.run
    db(:discounts) |> delete |> Moebius.Db.run
    :ok
  end

  def canonical_piece do
    db(:pieces)
    |> insert(
      id: 101,
      title: "Canonical Piece",
      sub_heading: "The very first piece",
      description: "I uses this piece for testing all the flipping time",
      level_overview: "not that easy",
      notation_preview: "UD101_notation_preview.pdf",
    )
    |> Moebius.Db.run
  end

  def garden_tiger do
    piece = db(:pieces)
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
    db(:items) |> insert(
      id: "garden-flute-part",
      name: "flute",
      initial_price: 80,
      discounted_price: 40,
      asset: "link I dont have",
      piece_id: 477
    ) |> Moebius.Db.run
    db(:items) |> insert(
      id: "garden-all-parts",
      name: "all parts",
      initial_price: 140,
      asset: "link I dont have",
      piece_id: 477
    ) |> Moebius.Db.run
    db(:items) |> insert(
      id: "garden-audio-part",
      name: "audio",
      initial_price: 40,
      asset: "link I dont have",
      piece_id: 477
    ) |> Moebius.Db.run
    db(:items) |> insert(
      id: "garden-piano-part",
      name: "piano",
      initial_price: 80,
      asset: "link I dont have",
      piece_id: 477
    ) |> Moebius.Db.run
    piece
  end

end
