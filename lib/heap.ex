defmodule Heap do
  @moduledoc "My first heap in Elixir !!!"
  def new_heap(value) do
    %{value: value, size: 1, left: :leaf, right: :leaf}
  end

  @doc """
  Creates and inserts a node into the heap.
  """
  @spec insert(%{} | :leaf, any) :: %{}

  def insert(:leaf, node_value), do: new_heap node_value
  def insert(%{value: value, size: size, left: left, right: right}, node_value) do
    cond do
    node_value < value and size(left) > size(right) ->
      %{value: value, size: size + 1, left: left, right: insert(right, node_value)}
    node_value < value ->
      %{value: value, size: size + 1, left: insert(left, node_value), right: right}
    node_value > value and size(left) > size(right) ->
      %{value: node_value, size: size + 1, left: left, right: insert(right, value)}
    node_value > value ->
      %{value: node_value, size: size + 1, left: insert(left, value), right: right}
      end
    end

  @doc """
  Removes a node from the given heap.
  """
  @spec delete_node(%{}, any) :: %{} | nil

  def delete_node(heap, node_value) do
    delete heap, node_value
  end

  defp delete(heap, node_value) do
    cond do
      heap.value == node_value -> del(heap)
      heap.value <  node_value ->
        %{value: heap.value,
          size: heap.size,
          left: heap.left,
          right: delete(heap.right, node_value)}
      heap.value > node_value ->
        %{value: heap.value,
          size: heap.size,
          left: delete(heap.left,node_value),
          right: heap.right}
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
end

val1 = Heap.new_heap(3)
r1 = Heap.insert(val1, 5)
r2 = Heap.insert(r1, 10)
r3 = Heap.insert(r2, 1)
IO.inspect(r3)