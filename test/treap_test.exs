defmodule TreapTest do
  use ExUnit.Case
  use ExUnitProperties
  doctest Treap

  test "test merge_1 for 1000 elements" do
    [t | treaps] = for n <- 1..1000, do: Treap.new_treap(n)
    merged_treaps = List.foldl(treaps, t, fn e, acc -> Treap.merge(e, acc) end)
    assert Treap.size(merged_treaps) == 1000
  end

  test "test split_1 for 1000 elements" do
    [t | treaps] = for n <- 1..1000, do: Treap.new_treap(n)
    merged_treaps = List.foldl(treaps, t, fn e, acc -> Treap.merge(e, acc) end)
    assert Treap.size(merged_treaps) == 1000
    spliced_treaps = Treap.split(1, merged_treaps)
    assert Treap.search(Enum.at(spliced_treaps, 0), 1) == nil
    assert Treap.search(Enum.at(spliced_treaps, 1), 1) != nil
    assert Treap.size(Enum.at(spliced_treaps, 1)) == 1000
  end

  test "test split_2 for 1000 elements" do
    [t | treaps] = Enum.shuffle(for n <- 1..1000, do: Treap.new_treap(n))
    merged_treaps = List.foldl(treaps, t, fn e, acc -> Treap.merge(e, acc) end)
    assert Treap.size(merged_treaps) == 1000
    spliced_treaps = Treap.split(5, merged_treaps)
    assert Treap.search(Enum.at(spliced_treaps, 0), 5) == nil
    assert Treap.search(Enum.at(spliced_treaps, 1), 5) != nil
    assert Treap.size(Enum.at(spliced_treaps, 0)) == 4
    assert Treap.size(Enum.at(spliced_treaps, 1)) == 1000 - 4
  end

  test "test from_list_1" do
    lst = Enum.shuffle(for n <- 1..1000, do: n)
    treap = Treap.from_list(lst)
    assert Treap.size(treap) == length(lst)
  end

  property "test from_list_2" do
    check all list <- list_of(integer()),
          list != [] do
      treap = Treap.from_list(list)
      assert Treap.size(treap) == length(list)
    end
  end

  test "test to_list_1" do
    lst = Enum.shuffle(for n <- 1..1000, do: n)
    treap = Treap.from_list(lst)
    result = Treap.to_list(treap)
    assert length(result) == Treap.size(treap)
  end

  property "test to_list_2" do
    check all list <- list_of(integer()),
          list != [] do
      treap = Treap.from_list(list)
      result = Treap.to_list(treap)
      assert length(result) == Treap.size(treap)
    end
  end

  test "test delete_1" do
    del_number = Enum.random(1..1000)
    lst = Enum.shuffle(for n <- 1..1000, do: n)
    treap = Treap.from_list(lst)
    new_treap = Treap.remove(treap, del_number)
    assert Treap.size(treap) > Treap.size(new_treap)
    assert Treap.search(new_treap, del_number) == nil
  end

  property "test delete_2" do
    check all list <- list_of(integer()),
          list != [] do
      treap = Treap.from_list(list)
      deleted = Treap.remove(treap, Enum.at(list, 0))
      size = if deleted != :leaf do Treap.size(deleted) else 0 end
      assert size < Treap.size(treap)
    end
  end

  test "test insert_1" do
    insert_number = Enum.random(1..1000)
    lst = Enum.shuffle(for n <- 1..1000, do: n)
    treap = Treap.from_list(lst)
    new_treap = Treap.insert(treap, insert_number)
    assert Treap.size(treap) + 1 == Treap.size(new_treap)
    assert Treap.search(new_treap, insert_number) != nil
  end

  property "test insert_2" do
    check all list <- list_of(integer()),
          list != [] do
      treap = Treap.from_list(list)
      updated_treap = Treap.insert(treap, Enum.random(1..100))
      size = if updated_treap != :leaf do Treap.size(updated_treap) else 0 end
      assert size == Treap.size(treap) + 1
    end
  end

  test "test search_1" do
    find_node = Enum.random(1..1000)
    lst = Enum.shuffle(for n <- 1..1000, do: n)
    treap = Treap.from_list(lst)
    result = Treap.search(treap, find_node)
    assert result != nil
    assert result.x == find_node
  end

  property "test search_2" do
    check all list <- list_of(integer()),
          list != [] do
      find_node = Enum.at(list, 0)
      treap = Treap.from_list(list)
      result = Treap.search(treap, find_node)
      assert result != nil
      assert result.x == find_node
    end
  end
end
