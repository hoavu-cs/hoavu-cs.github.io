---
title: Heap
parent: DSA
nav_order: 7
layout: default
permalink: /dsa/heap/
---

# Heap

A **heap** is a nearly complete binary tree that satisfies a *heap property*. It is one of the most useful data structures, serving as the backbone of efficient priority queues.

<div class="sectionlecturebox">
The Heap Property
</div>

We often use the terminology of max-heap and min-heap:

- **Max-heap**: every node's key is **greater than or equal to** the keys of its children. The largest element sits at the root.
- **Min-heap**: every node's key is **less than or equal to** the keys of its children. The smallest element sits at the root.


<b>Definition (Max-Heap Property)</b>: For every node $i$ other than the root, $A[\text{parent}(i)] \geq A[i]$.



<b>Definition (Min-Heap Property)</b>: For every node $i$ other than the root, $A[\text{parent}(i)] \leq A[i]$.


The two variants are symmetric: to turn a max-heap into a min-heap, we can either change the comparison direction or negate the keys. 

<div class="sectionlecturebox">
Array Representation
</div>

A heap on $n$ elements is stored in an array $A[1:n]$. The tree structure is implicit:

$$
\text{parent}(i) = \lfloor i/2 \rfloor, \quad
\text{left}(i) = 2i, \quad
\text{right}(i) = 2i + 1.
$$

For example, the max-heap $[16, 14, 10, 8, 7, 9, 3, 2, 4, 1]$ corresponds to the tree

```
            16
           /   \
         14    10
        /  \   /  \
       8    7 9    3
      / \  /
     2  4 1
```

**Key fact:** in a heap of $n$ elements, the leaves are the nodes at positions $\lfloor n/2 \rfloor + 1, \ldots, n$. To see this, a node at index $i$ has no child if $2i > n$, which is equivalent to $i > n/2$. So a node is internal (not a leaf) if and only if $i \le n/2$. Since $i$ is an integer, the last internal node is at index $\lfloor n/2 \rfloor$, and the first leaf is at index $\lfloor n/2 \rfloor + 1$.

<div class="sectionlecturebox">
Maintaining the Heap Property: <code>heapify</code>
</div>

`heapify` is the core subroutine. It assumes that the subtrees rooted at `left(i)` and `right(i)` are already valid max-heaps, and fixes a possible violation at node `i` by "floating" `A[i]` down the tree.

```julia
function heapify!(A, i)
    n = length(A)
    l = 2i
    r = 2i + 1
    largest = i

    if l <= n && A[l] > A[largest]
        largest = l
    end
    if r <= n && A[r] > A[largest]
        largest = r
    end

    if largest != i
        A[i], A[largest] = A[largest], A[i]   # swap
        heapify!(A, largest)                   # recurse on affected subtree
    end
end
```

**Running time of `heapify`:** The height of a heap on $n$ nodes is $h = \lfloor \log_2 n \rfloor$, so the recursion goes down at most $h$ levels, each doing $O(1)$ work. Therefore `heapify` runs in $O(\log n)$.


<div class="sectionlecturebox">
Building a Heap: <code>build_heap</code>
</div>

Given an arbitrary array $A[1:n]$, we can turn it into a max-heap in $O(n)$ time by calling `heapify` bottom-up on every internal node (leaves already satisfy the property trivially). Since the last internal node is at index $\lfloor n/2 \rfloor$, we call `heapify` on nodes $\lfloor n/2 \rfloor, \lfloor n/2 \rfloor - 1, \ldots, 1$.

```julia
function build_heap!(A)
    for i in div(length(A), 2):-1:1
        heapify!(A, i)
    end
end
```

**Why $O(n)$ and not $O(n \log n)$?** There are $O(n/2^{h+1})$ nodes at height $h$, and `heapify` at height $h$ costs $O(h)$. Summing over all heights:

$$
\sum_{h=0}^{\lfloor \log n \rfloor} \left\lceil \frac{n}{2^{h+1}} \right\rceil O(h)
= O\!\left(n \sum_{h=0}^{\infty} \frac{h}{2^h}\right) = O(n),
$$

using the fact that $\sum_{h=0}^{\infty} h \, x^h = \frac{x}{(1-x)^2}$ with $x = 1/2$.

<div class="sectionlecturebox">
Heap Operations
</div>

All operations below assume a max-heap. For a min-heap, flip the comparisons.

**Extract-max** removes and returns the maximum element (the root). After we remove the root, we move the last element to the root, shrink the array with `pop!`, and call `heapify` to restore the heap property.

```julia
function heap_extract_max!(A)
    max_val = A[1]
    A[1] = A[end]               # move last element to root
    pop!(A)                     # shrink the array
    heapify!(A, 1)              # restore heap property
    return max_val
end
```

Running time: $O(\log n)$ since `heapify` is called once.

---

**Increase-key** raises the value of $A[i]$ to `key` and restores the heap property by "bubbling" the node up.

```julia
function heap_increase_key!(A, i, key)
    if key < A[i]
        error("new key is smaller than current key")
    end
    A[i] = key
    while i > 1 && A[div(i, 2)] < A[i]
        A[i], A[div(i, 2)] = A[div(i, 2)], A[i] # Swap A[i] with its parent if A[i] is larger
        i = div(i, 2)
    end
end
```

Running time: $O(\log n)$ since the node travels at most $O(\log n)$ levels upward.

---

**Insert** adds a new key to the heap. We simply append a sentinel value $-\infty$ to the end of the array and call `increase-key` to set the correct value and restore the heap property.

```julia
function max_heap_insert!(A, key)
    push!(A, -Inf)              # extend array with sentinel
    heap_increase_key!(A, length(A), key)
end
```

Running time: $O(\log n)$ because `increase-key` is called once.


<div class="sectionlecturebox">
Heapsort
</div>

Heapsort sorts an array in $O(n \log n)$ time. The idea: build a max-heap, then repeatedly extract the maximum into a result array.

```julia
function heapsort(A)
    build_heap!(A)
    sorted = []
    while !isempty(A)
        push!(sorted, heap_extract_max!(A))
    end
    return sorted   # sorted in decreasing order
end
```

**Running time**: `build_heap` costs $O(n)$, and each of the $n$ calls to `heap_extract_max!` costs $O(\log n)$, giving $O(n \log n)$ total.

**Exercise:** Trace heapsort on the array $[3, 1, 4, 1, 5, 9, 2, 6]$. Write out the heap after each call to `heap_extract_max!`.

<div class="sectionlecturebox">
Priority Queue Application
</div>

A **priority queue** is an abstract data type that supports:

- `insert(key)` — add a new element.
- `extract_max()` / `extract_min()` — remove and return the element with the highest (or lowest) priority.
- `increase_key(i, key)` / `decrease_key(i, key)` — update a priority.

A heap implements all of these in $O(\log n)$, making it the standard concrete implementation of priority queues.

A classic application is **Dijkstra's shortest-path algorithm**: a min-heap stores vertices ordered by their current tentative distance, allowing the next closest vertex to be extracted in $O(\log n)$ and distances to be updated in $O(\log n)$.

**Exercise:** Suppose you are given a stream of integers and must always be able to report the $k$-th smallest element seen so far. Describe how to maintain a max-heap of size $k$ to solve this problem, and analyze the running time per element.
