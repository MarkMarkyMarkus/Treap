defmodule BinarySearchTree do
  @moduledoc "My first BST in Elixir !!!"
  def new_tree(value) do
    %{left: :leaf, value: value, right: :leaf}
  end

  @doc """
  Creates and inserts a node with its value into the tree.
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
  Removes a node from the given tree.
  """
  @spec delete_node(%{}, any) :: %{} | nil

  def delete_node(tree, node_value) do
      delete tree, node_value
  end

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
  defp del(%{left: left, value: _, right: right}) do
    %{left: left, value: min(right), right: delete(right, min(right))}
  end

  defp min(%{left: :leaf,  value: val, right: _}), do: val
  defp min(%{left: left, value: _,   right: _}), do: min left
end

val1 = BinarySearchTree.new_tree(3)
r1 = BinarySearchTree.insert(val1, 5)
r2 = BinarySearchTree.insert(r1, 10)
r3 = BinarySearchTree.insert(r2, 1)
IO.inspect(r3)