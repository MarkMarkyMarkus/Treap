defmodule Treap do
  @moduledoc "My first Treap in Elixir !!!"

  def new_treap(x) do
    len = 100000
    %{x: x, y: Enum.random(1..len), left: :leaf, right: :leaf}
  end

  @doc """
  Merge the Treaps.
  """
  @spec merge(%{} | :leaf, %{} | :leaf) :: %{} | nil

  def merge(:leaf, r), do: r
  def merge(l, :leaf), do: l
  def merge(nil, r), do: r
  def merge(l, nil), do: l
  def merge(nil, nil), do: nil

  def merge(l = %{x: l_x, y: l_y, left: l_left, right: l_right}, r = %{x: r_x, y: r_y, left: r_left, right: r_right}) do
    if l_y > r_y do
      if l_x > r_x do
        %{x: l_x, y: l_y, left: merge(l_left, r), right: l_right}
      else
        %{x: l_x, y: l_y, left: l_left, right: merge(l_right, r)}
      end
    else
      if l_x > r_x do
        %{x: r_x, y: r_y, left: r_left, right: merge(l, r_right)}
      else
        %{x: r_x, y: r_y, left: merge(r_left, l), right: r_right}
      end
    end
  end

  @doc """
  Split the Treap.
  """
  @spec split(any, %{}) :: %{}

  def split(x0, %{x: x, y: _, left: left, right: right}) do
    cond do
      x == x0 -> helper_split(x0, merge(left, right), :leaf, new_treap(x))
      x < x0  -> helper_split(x0, merge(left, right), new_treap(x), :leaf)
      x > x0  -> helper_split(x0, merge(left, right), :leaf, new_treap(x))
    end
  end

  defp helper_split(_, :leaf, l, r), do: [l, r]
  defp helper_split(x0, %{x: x, y: _, left: left, right: right}, l, r) do
    cond do
      x == x0 -> helper_split(x0, merge(left, right), l, merge(new_treap(x), r))
      x < x0  -> helper_split(x0, merge(left, right), merge(l, new_treap(x)), r)
      x > x0  -> helper_split(x0, merge(left, right), l, merge(new_treap(x), r))
    end
  end

  @doc """
  Create and insert a node into the Treap.
  """
  @spec insert(%{} | :leaf, any) :: %{}

  def insert(:leaf, x), do: new_treap(x)
  def insert(treap, x) do
    split_tree = split(x, treap)
    tmp_treap  = new_treap(x)
    merge(merge(Enum.at(split_tree, 0), tmp_treap), Enum.at(split_tree, 1))
    end

  @doc """
  Remove a node from the given Treap.
  """
  @spec remove(%{}, any) :: %{} | nil

  def remove(%{x: x, y: _, left: :leaf, right: :leaf}, x), do: nil
  def remove(treap, x) do
    split_tree       = split(x, treap)
    split_right_tree = split(x + 1, Enum.at(split_tree, 1))
    merge(Enum.at(split_tree, 0), Enum.at(split_right_tree, 1))
  end

  @doc """
  Create a Treap from the list.
  """
  @spec from_list(list()) :: %{} | nil

  def from_list([]), do: nil
  def from_list([h | tail]) do
    List.foldl(tail, new_treap(h), fn e, acc -> insert(acc, e) end)
  end

  @doc """
  Create list from the Treap.
  """
  @spec to_list(%{}) :: list()

  def to_list(treap), do: to_list_helper(treap, [])

  defp to_list_helper(:leaf, acc), do: acc
  defp to_list_helper(%{x: x, y: y, left: left, right: right}, acc),
       do: Enum.concat([acc, [{x, y}], to_list_helper(left, acc), to_list_helper(right, acc)])

  @doc """
  Search a node in the given Treap.
  """
  @spec search(%{}, any) :: %{} | nil

  def search(:leaf, _), do: nil
  def search(%{x: x, y: y, left: left, right: right}, value) do
    cond do
      x == value -> %{x: x, y: y, left: left, right: right}
      value != x -> merge(search(left, value), search(right, value))
    end
  end

  @doc """
  Get the size of the Treap.
  """
  @spec size(%{}) :: integer

  def size(treap), do: size_counter(treap, 0)

  defp size_counter(nil, acc), do: acc
  defp size_counter(:leaf, acc), do: acc
  defp size_counter(%{x: _, y: _, left: left, right: right}, acc),
       do: acc + 1 + size_counter(left, acc) + size_counter(right, acc)
end