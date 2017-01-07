defmodule UM.SigningTest do
  use ExUnit.Case

  # http://docs.aws.amazon.com/AmazonS3/latest/dev/RESTAuthentication.html
  test "test that signature generation matches example" do
    key_id = "AKIAIOSFODNN7EXAMPLE"
    access_key = "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
    signing_string = "GET\n\n\n1175139620\n/johnsmith/photos/puppy.jpg"
    signature = :crypto.hmac(:sha, access_key, signing_string)
    |> Base.encode64
    |> URI.encode_www_form
    assert signature == "NpgCjnDzrM%2BWFzoENXmpNDUsSn8%3D"
  end
end
