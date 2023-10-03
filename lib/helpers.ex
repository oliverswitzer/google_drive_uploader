defmodule OliversGoogleDriveUploader.Helpers do
  def extract_product_id_from_url(nil) do
    nil
  end

  def extract_product_id_from_url(product_url) do
    case Regex.named_captures(
           ~r/https:\/\/www\.amazon\.com\/(gp|dp)(\/product)?\/(?<productId>[^\/?]+)(\/|\?|$)/,
           product_url
         ) do
      %{"productId" => productId} -> productId
      _ -> nil
    end
  end

  def data_path(path) do
    data_path = "../../data/"

    "#{data_path}#{path}"
    |> Path.expand(__DIR__)
  end
end
