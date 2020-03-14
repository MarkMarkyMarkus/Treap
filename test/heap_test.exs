defmodule HeapTest do
  use ExUnit.Case, async: true
  use ExUnitProperties
  doctest Heap

  test "test from_list_1" do
    lst = Enum.shuffle(for n <- 1..100, do: n)
    heap = Heap.from_list(lst)
    assert heap.size == length(lst)
  end

  property "test from_list_2" do
    check all list <- list_of(integer()),
          list != [] do
      heap = Heap.from_list(list)
      assert heap.size == length(list)
    end
  end

  test "test to_list_1" do
    lst = Enum.shuffle(for n <- 1..100, do: n)
    heap = Heap.from_list(lst)
    result = Heap.to_list(heap)
    assert length(result) == heap.size
  end

  property "test to_list_2" do
    check all list <- list_of(integer()),
          list != [] do
      heap = Heap.from_list(list)
      result = Heap.to_list(heap)
      assert length(result) == heap.size
    end
  end

  test "test delete_1" do
    del_number = Enum.random(1..100)
    lst = Enum.shuffle(for n <- 1..100, do: n)
    heap = Heap.from_list(lst)
    new_heap = Heap.delete_node(heap, del_number)
    assert heap.size == new_heap.size + 1
    assert List.first(Heap.to_list(heap) -- Heap.to_list(new_heap)) == del_number
  end

  property "test delete_2" do
    check all list <- list_of(integer()),
          list != [] do
    heap = Heap.from_list(list)
    deleted = Heap.delete_node(heap, Enum.at(list, 0))
    size = if deleted != :leaf do deleted.size else 0 end
    assert size == heap.size - 1
    end
  end

  test "test insert_1" do
    insert_number = Enum.random(1..100)
    lst = Enum.shuffle(for n <- 1..100, do: n)
    heap = Heap.from_list(lst)
    new_heap = Heap.insert(heap, insert_number)
    assert heap.size + 1 == new_heap.size
    assert List.first(Heap.to_list(new_heap) -- Heap.to_list(heap)) == insert_number
  end

  property "test insert_2" do
    check all list <- list_of(integer()),
          list != [] do
      heap = Heap.from_list(list)
      inserted = Heap.insert(heap,  Enum.random(1..100))
      size = if inserted != :leaf do inserted.size else 0 end
      assert size > heap.size
    end
  end

  test "test get_max_1" do
    lst = Enum.shuffle(for n <- 1..100, do: n)
    heap = Heap.from_list(lst)
    max = Heap.get_max(heap)
    assert max != nil
    assert max == Enum.max(lst)
  end

  property "test get_max_2" do
    check all list <- list_of(integer()),
          list != [] do
      heap = Heap.from_list(list)
      max = Heap.get_max(heap)
      assert max != nil
      assert max == Enum.max(list)
    end
  end
end