defmodule OliversGoogleDriveUploader.AmazonOrderParser do
  import OliversGoogleDriveUploader.Helpers

  require Logger

  defmodule AmazonOrder do
    defstruct [:title, :product_url, :product_id, :total, :date_ordered, :invoice_url]
  end

  def run do
    data_path("path/to/orders.csv")
    |> parse_amazon_order_csv()
  end

  defp parse_amazon_order_csv(path) do
    File.stream!(path)
    |> CSV.decode(headers: true)
    |> Enum.map(&amazon_order_row_to_struct/1)
    |> Enum.reject(&is_nil/1)
  end

  defp amazon_order_row_to_struct({:error, csv_row_data}) do
    Logger.warn("Could not parse row with data: ", csv_row_data)
  end

  defp amazon_order_row_to_struct(
         {:ok,
          %{
            "title" => title,
            "productLink" => product_url,
            "total" => total,
            "dateOrdered" => date_ordered,
            "invoiceUrl" => invoice_url
          } = row}
       ) do
    cond do
      title == "" ->
        Logger.warning("Could not parse empty amazon order row: #{inspect(row)}")
        nil

      true ->
        %AmazonOrder{
          title: title,
          product_url: product_url,
          total: total,
          date_ordered: date_ordered,
          invoice_url: invoice_url,
          product_id: extract_product_id_from_url(product_url)
        }
    end
  end
end
