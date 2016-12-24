defmodule UM.Web.Fixtures do
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

  def my_account do
    db(:customers)
    |> insert(
      id: "peter",
      first_name: "Peter",
      last_name: "Saxton",
      email: "p@me.co",
      password: "password",
      country: "GB",
      admin: true,
    )
    |> Moebius.Db.run
  end

  def grahams_account do
    db(:customers)
    |> insert(
      id: "graham",
      first_name: "Graham",
      last_name: "Lyons",
      email: "usefulmusic@gmail.com",
      password: "password",
      country: "GB",
      admin: true,
    )
    |> Moebius.Db.run
  end

  # has a basket in progress
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

  # Like joe blogs
  # Big spender
  # has completed order but no current basket
  # currency_preference = USD
  def jo_brand do
    db(:customers)
    |> insert(
      id: "jo-brand-customer",
      first_name: "Jo",
      last_name: "Brand",
      email: "jo@hotmail.com",
      password: "password",
      country: "GB",
      admin: false,
      currency_preference: "USD"
    )
    |> Moebius.Db.run
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
      asset: "TODO link I dont have again",
      piece_id: 477
    ) |> Moebius.Db.run
    db(:items) |> insert(
      id: "garden-all-parts",
      name: "all parts",
      initial_price: 140,
      asset: "TODO link I dont have again",
      piece_id: 477
    ) |> Moebius.Db.run
    db(:items) |> insert(
      id: "garden-audio-part",
      name: "audio",
      initial_price: 40,
      asset: "TODO link I dont have again",
      piece_id: 477
    ) |> Moebius.Db.run
    db(:items) |> insert(
      id: "garden-piano-part",
      name: "piano",
      initial_price: 80,
      asset: "TODO link I dont have again",
      piece_id: 477
    ) |> Moebius.Db.run
    piece
  end

  def guest_basket do
    basket = db(:shopping_baskets) |> insert(id: "inprogress-shop")
    |> Moebius.Db.run
    garden_tiger
    UM.Sales.set_item(basket.id, "garden-flute-part")
    UM.Sales.set_item(basket.id, "garden-all-parts")
    basket
  end

  def current_discount() do
    db(:discounts)
    |> insert(
      id: "test-code",
      code: "NOW123",
      value: 1000,
      allocation: 10,
      customer_allocation: 1,
      start_datetime: {{2016, 1, 1}, {0, 0, 0}},
      end_datetime: {{2020, 1, 1}, {0, 0, 0}},
    )
    |> Moebius.Db.run
  end

  def pending_discount() do
    db(:discounts)
    |> insert(
      id: "test-code",
      code: "FUTURE123",
      value: 1000,
      allocation: 10,
      customer_allocation: 1,
      start_datetime: {{2020, 1, 1}, {0, 0, 0}},
      end_datetime: {{2021, 1, 1}, {0, 0, 0}},
    )
    |> Moebius.Db.run
  end

  def expired_discount() do
    db(:discounts)
    |> insert(
      id: "test-code",
      code: "PAST123",
      value: 1000,
      allocation: 10,
      customer_allocation: 1,
      start_datetime: {{2015, 1, 1}, {0, 0, 0}},
      end_datetime: {{2016, 1, 1}, {0, 0, 0}},
    )
    |> Moebius.Db.run
  end
end
