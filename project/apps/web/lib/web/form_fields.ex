defmodule UM.Web.FormFields do
  def name(opts) do
    WebForm.field(&validate_name/1, opts)
  end

  def email(opts) do
    WebForm.field(&validate_email/1, opts)
  end

  def password(opts) do
    WebForm.field(&validate_password/1, opts)
  end

  def password_confirmation do
    {:confirmation, "password"}
  end

  def country(opts) do
    WebForm.field(&pass_all/1, opts)
  end

  defp pass_all(input) do
    {:ok, input}
  end

  # TODO validate contains letters only
  defp validate_name(text) do
    name = String.strip(text) |> String.capitalize
    case String.length(name) >= 2 do
      false ->
        {:error, "name is too short"}
      true ->
        case String.length(name) <= 26 do
          false ->
            {:error, "name is too long"}
          true ->
            {:ok, name}
        end
    end
  end

  def validate_email(raw) do
    case String.split(raw, "@") do
      [_, _] ->
        {:ok, raw |> String.strip |> String.downcase}
      _ ->
        {:error, "not a vaild email address"}
    end
  end

  def validate_password(text) do
    case String.length(text) >= 8 do
      false ->
        {:error, "text is too short"}
      true ->
        case String.length(text) <= 55 do
          false ->
            {:error, "text is too long"}
          true ->
            {:ok, text}
        end
    end
  end
end
