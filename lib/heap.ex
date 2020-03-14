defmodule Heap do
  @moduledoc "My first max heap in Elixir !!!"
  def new_heap(value) do
    %{value: value, size: 1, left: :leaf, right: :leaf}
  end

  @doc """
  Create and insert a node into the heap.
  """
  @spec insert(%{} | :leaf, any) :: %{}

  def insert(:leaf, node_value), do: new_heap node_value
  def insert(%{value: value, size: size, left: left, right: right}, node_value) do
    cond do
    node_value < value and size(left) > size(right) ->
      %{value: value, size: size + 1, left: left, right: insert(right, node_value)}
    node_value < value ->
      %{value: value, size: size + 1, left: insert(left, node_value), right: right}
    node_value >= value and size(left) > size(right) ->
      %{value: node_value, size: size + 1, left: left, right: insert(right, value)}
    node_value >= value ->
      %{value: node_value, size: size + 1, left: insert(left, value), right: right}
      end
    end

  @doc """
  Remove a node from the given heap.
  """
  @spec delete_node(%{}, any) :: %{} | nil

  def delete_node(heap, node_value) do
    delete heap, node_value
  end

  defp delete(nil, _), do: nil
  defp delete(:leaf, _), do: :leaf
  defp delete(heap, node_value) do
    cond do
      heap.value == node_value -> del(heap)
      heap.value > node_value  ->
        %{value: heap.value,
          size: heap.size - 1,
          left: delete(heap.left, node_value),
          right: delete(heap.right, node_value)
        }
      heap.value < node_value  ->
        heap
    end
  end

  defp del(%{value: _, size: _, left: :leaf, right: right}), do: right
  defp del(%{value: _, size: _, left: left, right: :leaf}),  do: left
  defp del(%{value: _, size: s, left: left, right: right})   do
    %{value: min(right), size: s - 1, left: left, right: delete(right, min(right))}
  end

  defp size(:leaf), do: 0
  defp size(%{value: _, size: size, left: _, right: _}), do: size

  defp min(%{value: val, size: _, left: :leaf, right: _}), do: val
  defp min(%{value: _, size: _, left: left, right: _}),    do: min left

  @doc """
  Create a heap from the list.
  """
  @spec from_list(list()) :: %{} | nil

  def from_list([]), do: nil
  def from_list([h | tail]) do
    List.foldl(tail, new_heap(h), fn e, acc -> insert(acc, e) end)
  end

  @doc """
  Create list from the heap.
  """
  @spec to_list(%{}) :: list()

  def to_list(heap), do: to_list_helper(heap, [])

  defp to_list_helper(:leaf, acc), do: acc
  defp to_list_helper(%{left: left, value: v, right: right}, acc),
       do: Enum.concat([acc, [v], to_list_helper(left, acc), to_list_helper(right, acc)])

  @doc """
  Get max element from the heap.
  """
  @spec get_max(%{}) :: any

  def get_max(%{value: val, size: _, left: _, right: _}), do: val
end