defmodule BinarySearchTreeTest do
  use ExUnit.Case, async: true
  use ExUnitProperties
  doctest BinarySearchTree

  test "test from_list_1" do
    lst = Enum.shuffle(for n <- 1..100, do: n)
    bst = BinarySearchTree.from_list(lst)
    assert BinarySearchTree.size(bst) == length(lst)
  end

  property "test from_list_2" do
    check all list <- list_of(integer()),
          list != [] do
      bst = BinarySearchTree.from_list(list)
      assert BinarySearchTree.size(bst) == length(list)
    end
  end

  test "test to_list_1" do
    lst = Enum.shuffle(for n <- 1..100, do: n)
    bst = BinarySearchTree.from_list(lst)
    result = BinarySearchTree.to_list(bst)
    assert length(result) == BinarySearchTree.size(bst)
  end

  property "test to_list_2" do
    check all list <- list_of(integer()),
          list != [] do
      bst = BinarySearchTree.from_list(list)
      result = BinarySearchTree.to_list(bst)
      assert length(result) == BinarySearchTree.size(bst)
    end
  end

  test "test delete_1" do
    del_number = Enum.random(1..100)
    lst = Enum.shuffle(for n <- 1..100, do: n)
    bst = BinarySearchTree.from_list(lst)
    new_bst = BinarySearchTree.delete_node(bst, del_number)
    assert BinarySearchTree.size(bst) == BinarySearchTree.size(new_bst) + 1
    assert List.first(BinarySearchTree.to_list(bst) -- BinarySearchTree.to_list(new_bst)) == del_number
  end

  property "test delete_2" do
    check all list <- list_of(integer()),
          list != [] do
      bst = BinarySearchTree.from_list(list)
      deleted = BinarySearchTree.delete_node(bst, Enum.at(list, 0))
      size = if deleted != :leaf do BinarySearchTree.size(deleted) else 0 end
      assert size == BinarySearchTree.size(bst) - 1
    end
  end

  test "test insert_1" do
    insert_number = Enum.random(1..100)
    lst = Enum.shuffle(for n <- 1..100, do: n)
    bst = BinarySearchTree.from_list(lst)
    new_bst = BinarySearchTree.insert(bst, insert_number)
    assert BinarySearchTree.size(bst) + 1 == BinarySearchTree.size(new_bst)
    assert List.first(BinarySearchTree.to_list(new_bst) -- BinarySearchTree.to_list(bst)) == insert_number
  end

  property "test insert_2" do
    check all list <- list_of(integer()),
          list != [] do
      bst = BinarySearchTree.from_list(list)
      inserted = BinarySearchTree.insert(bst, Enum.random(1..100))
      size = if inserted != :leaf do BinarySearchTree.size(inserted) else 0 end
      assert size == BinarySearchTree.size(bst) + 1
    end
  end

  test "test search_1" do
    find_node = Enum.random(1..100)
    lst = Enum.shuffle(for n <- 1..100, do: n)
    bst = BinarySearchTree.from_list(lst)
    result = BinarySearchTree.search(bst, find_node)
    assert result != nil
    assert result.value == find_node
  end

  property "test search_2" do
    check all list <- list_of(integer()),
          list != [] do
      find_node = Enum.at(list, 0)
      bst = BinarySearchTree.from_list(list)
      result = BinarySearchTree.search(bst, find_node)
      assert result != nil
      assert result.value == find_node
    end
  end
end
