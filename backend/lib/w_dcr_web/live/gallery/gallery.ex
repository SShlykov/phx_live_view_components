defmodule Wdcr.Gallery do
  @moduledoc false

  @unsplash_url "https://images.unsplash.com"
  @ids [
    "photo-1447946442870-3be230521a91",
    "photo-1557935551-bc58f6e7b7d0",
    "photo-1591005680043-1fd6ca4b5985",
    "photo-1588694466084-b0a6f95116f7",
    "photo-1553856622-d1b352e9a211"
  ]
  @images_count Enum.count(@ids)

  def image_ids, do: @ids
  def image_url(image_id, params) do
    URI.parse(@unsplash_url)
    |> URI.merge(image_id)
    |> Map.put(:query, URI.encode_query(params))
    |> URI.to_string()
  end

  def thumb_url(id), do: image_url(id, %{w: 100, h: 100, fit: "crop"})
  def large_url(id), do: image_url(id, %{h: 500, fit: "crop"})

  def first_id(), do: List.first(@ids)
  def first_id(ids \\ @ids), do: List.first(ids)

  def next_image_id(ids\\@ids, id), do: Enum.at(ids, next_index(ids, id), first_id(ids))
  defp next_index(ids, id),         do: ids |> Enum.find_index(& &1 == id) |> Kernel.+(1)

  def prev_image_id(ids\\@ids, id), do: Enum.at(ids, prev_index(ids, id))
  defp prev_index(ids, id),         do: ids |> Enum.find_index(& &1 == id) |> Kernel.-(1)
end
