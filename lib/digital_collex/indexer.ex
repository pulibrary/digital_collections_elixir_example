defmodule DigitalCollex.Indexer do
  alias DigitalCollex.Indexer

  def get_figgy_catalog(getter \\ Indexer) do
    apply(getter, :get_url, ["https://figgy.princeton.edu/catalog.json?rows=100"])
    |> parse_json
  end

  def convert_figgy_documents(%{"response" => %{"docs" => documents}}) do
    documents
    |> Enum.map(&convert_figgy_document/1)
  end

  def convert_figgy_document(%{"id" => id, "title_ssim" => title, "state_ssim" => state}) do
    %DigitalCollex.Resource{id: id, title: title, state: state}
  end

  def parse_json(json_string) when is_binary(json_string) do
    json_string
    |> Jason.decode()
    |> parse_json
  end

  def parse_json({:ok, json = %{}}), do: json

  def get_url(url) do
    url
    |> HTTPoison.get!([], ssl: [versions: [:"tlsv1.2"]])
    |> Map.get(:body)
  end
end
