defmodule GoogleDriveUploader.Uploaders.AmazonInvoiceRenamer do
  @moduledoc """
  Assuming you have Amazon invoices with the following labeling system in the data directory:

  data/invoices/INVOICE-<amazon_url_product_id>.html

  This script will iterate through a CSV containing a list of expenses for a project, find the associated
  invoice via the product id extracted from the URL, and rename the invoice to the name of that product.

  It will place the renamed and .pdf formatted files in data/invoices/renamed

  Please use the Amazon order downloader chrome extension to extract all your order invoices from your account
  https://github.com/oliverswitzer/amazon-downloader-extension
  """

  import OliversGoogleDriveUploader.Helpers

  require Logger

  defmodule Expense do
    defstruct [:title, :product_url, :product_id, :total, :purchased_by]
  end

  def run do
    expenses =
      data_path("osm-expenses.csv")
      |> parse_expenses_csv()
      |> Enum.filter(&(&1.purchased_by == "Oliver"))

    invoices =
      data_path("invoices/")
      |> File.ls!()

    renamed_invoices_dir = data_path("invoices/renamed/")

    renamed_invoices_dir
    |> File.mkdir_p!()

    expenses
    |> Enum.each(fn e ->
      with :ok <- if(is_nil(e.product_id), do: {:error, :product_id_nil}, else: :ok),
           matching_invoice_path <- Enum.find(invoices, &String.contains?(&1, e.product_id)) do
        renamed_invoice_path = Path.join(renamed_invoices_dir, "#{e.title}.html")

        Logger.info(
          "Found matching invoice for #{e.title}: #{matching_invoice_path}. Copying to #{renamed_invoice_path}"
        )

        File.cp(data_path("invoices/#{matching_invoice_path}"), renamed_invoice_path)
      else
        _ ->
          Logger.warn(
            "Could not find matching invoice for #{e.title}. Product ID: #{e.product_id}"
          )
      end
    end)
  end

  defp parse_expenses_csv(path) do
    File.stream!(path)
    |> CSV.decode(headers: true)
    |> Enum.map(&expense_row_to_struct/1)
    |> Enum.reject(&is_nil/1)
  end

  defp expense_row_to_struct(
         {:ok,
          %{
            "Item" => title,
            "Link" => listing_url,
            "Cost with tax (est)" => total,
            "Bought by" => purchased_by
          }}
       ) do
    %Expense{
      title: title,
      product_url: listing_url,
      total: total,
      purchased_by: purchased_by,
      product_id: extract_product_id_from_url(listing_url)
    }
  end

  defp expense_row_to_struct({:error, csv_row_data}) do
    Logger.warn("Could not parse row with data: ", csv_row_data)
  end
end
