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
      # url = UM.Catalogue.PieceStorage.url({piece.notation_preview, piece}, :original)
      # |> IO.inspect
      # uri = %{path: path = "/useful-music-tmp" <> rest} = URI.parse(url)
      # IO.inspect(path)
      # {mega, seconds, _} = :erlang.now
      # expires = (mega * 1_000_000) + seconds + 3_600
      # signing_string = "GET\n\n\n#{expires}\n#{path}"
      # access_key_id = System.get_env("AWS_ACCESS_KEY_ID")
      # secret_access_key = System.get_env("AWS_SECRET_ACCESS_KEY")
      # signature = :crypto.hmac(:sha, secret_access_key, signing_string)
      # |> Base.encode64
      # |> URI.encode_www_form
      # query = "AWSAccessKeyId=#{access_key_id}&Expires=#{expires}&Signature=#{signature}"
      # host = "useful-music-tmp.s3.amazonaws.com"
      # uri = %{uri | host: host, query: query, path: rest}
      # IO.inspect("#{uri}")



      # datetime = :calendar.universal_time
      # expires_in = 3600
      # query_params = []
      # http_method = :GET
      # secret_access_key = Application.get_env(:ex_aws, :secret_access_key)
      # |> IO.inspect
      # config = %{secret_access_key: secret_access_key, region: "us-west-2", access_key_id: access_key_id}
      # ExAws.Auth.presigned_url(http_method, url, :s3, datetime, config, expires_in, query_params)
      # |> IO.inspect
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
