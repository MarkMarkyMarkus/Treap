defmodule Treap do
  @moduledoc "My first Treap in Elixir !!!"
  def new_treap(x, y) do
    %{x: x, y: y, left: :leaf, right: :leaf}
  end

  @doc """
  Merge the Treaps.
  """
  @spec merge(%{} | :leaf, %{} | :leaf) :: %{}

  def merge(:leaf, r), do: r
  def merge(l, :leaf), do: l

  def merge(l = %{x: l_x, y: l_y, left: l_left, right: l_right}, r = %{x: r_x, y: r_y, left: r_left, right: r_right}) do
    if l_y > r_y do
      %{x: l_x, y: l_y, left: l_left, right: merge(l_right, r)}
    else
      %{x: r_x, y: r_y, left: merge(l, r_left), right: r_right}
    end
  end

  @doc """
  Split the Treap.
  """
  @spec split(any, %{}) :: %{}

  def split(x0, _treap = %{x: x, y: y, left: left, right: right}) do
    if x <= x0 do
      helper_split(x0, right, merge(left, new_treap(x, y)), :leaf)
    else
      helper_split(x0, left, :leaf, merge(new_treap(x, y), right))
    end
  end

  defp helper_split(_, :leaf, l, r) do
    [l, r]
  end

  defp helper_split(x0, sub_treap = %{x: x, y: _, left: left, right: right}, l, r) do
    if x <= x0 do
      helper_split(x0, right, merge(l, sub_treap), r)
    else
      helper_split(x0, left, l, merge(sub_treap, r))
    end
  end

  @doc """
  Creates and inserts a node into the Treap.
  """
  @spec insert(%{} | :leaf, any, any) :: %{}

  def insert(:leaf, node_x, node_y), do: new_treap(node_x, node_y)
  def insert(treap, node_x, node_y) do
    split_tree   = split(node_x, treap)
    tmp_treap = new_treap(node_x, node_y)
    merge(merge(Enum.at(split_tree, 0), tmp_treap), Enum.at(split_tree, 1))
    end

  @doc """
  Removes a node from the given Treap.
  """
  @spec remove(%{}, any) :: %{} | nil

  def remove(treap, node_x) do
    split_tree       = split(node_x - 1, treap)
    split_right_tree = split(node_x, Enum.at(split_tree, 1))
    merge(Enum.at(split_tree, 0), Enum.at(split_right_tree, 1))
  end
end

r0 = Treap.new_treap(50, 15)
r1 = Treap.insert(r0, 30, 5)
r2 = Treap.insert(r1, 70, 10)
r3 = Treap.insert(r2, 20, 2)
r4 = Treap.insert(r3, 40, 4)
r5 = Treap.insert(r4, 80, 12)
IO.inspect(r5)