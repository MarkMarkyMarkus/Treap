defmodule BinarySearchTree do
  @moduledoc "My first BST in Elixir !!!"
  def new_tree(value) do
    %{left: :leaf, value: value, right: :leaf}
  end

  @doc """
  Create and inserts a node with its value into the tree.
  """
  @spec insert(%{} | :leaf, any) :: %{}

  def insert(:leaf, node_value), do: new_tree node_value
  def insert(%{left: left, value: value, right: right}, node_value) do
    if node_value < value do
      %{left: insert(left, node_value), value: value, right: right}
    else
      %{left: left, value: value, right: insert(right, node_value)}
    end
  end

  @doc """
  Remove a node from the given tree.
  """
  @spec delete_node(%{}, any) :: %{}

  def delete_node(tree, node_value) do
      delete tree, node_value
  end

  defp delete(:leaf, _), do: :leaf
  defp delete(tree, node_value) do
    cond do
      tree.value == node_value -> del(tree)
      tree.value <  node_value ->
        %{left: tree.left,
          value: tree.value,
          right: delete(tree.right, node_value)}
      tree.value > node_value ->
        %{left: delete(tree.left,node_value),
          value: tree.value,
          right: tree.right}
    end
  end

  defp del(%{left: :leaf,  value: _, right: right}), do: right
  defp del(%{left: left, value: _, right: :leaf}),   do: left
  defp del(%{left: left, value: _, right: right})    do
    %{left: left, value: min(right), right: delete(right, min(right))}
  end

  defp min(%{left: :leaf,  value: val, right: _}), do: val
  defp min(%{left: left, value: _,   right: _}),   do: min left

  @doc """
  Create BST from the list.
  """
  @spec from_list(list()) :: %{} | nil

  def from_list([]), do: nil
  def from_list([h | tail]) do
    List.foldl(tail, new_tree(h), fn e, acc -> insert(acc, e) end)
  end

  @doc """
  Get the size of the BST.
  """
  @spec size(%{}) :: integer

  def size(bst), do: size_counter(bst, 0)

  defp size_counter(:leaf, acc), do: acc
  defp size_counter(%{left: left, value: _, right: right}, acc), do: acc + 1 + size_counter(left, acc) + size_counter(right, acc)

  @doc """
  Create list from the BST.
  """
  @spec to_list(%{}) :: list()

  def to_list(bst), do: to_list_helper(bst, [])

  defp to_list_helper(:leaf, acc), do: acc
  defp to_list_helper(%{left: left, value: v, right: right}, acc),
       do: Enum.concat([acc, [v], to_list_helper(left, acc), to_list_helper(right, acc)])

  @doc """
  Search a node in the given BST.
  """
  @spec search(%{}, any) :: %{} | nil

  def search(:leaf, _), do: nil
  def search(%{left: left, value: v, right: right}, value) do
    cond do
      v == value -> %{left: left, value: v, right: right}
      value < v  -> search(left, value)
      value > v  -> search(right, value)
    end
  end
end