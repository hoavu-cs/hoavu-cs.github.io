---
title: Dynamic Programming Part 1 (Fibonacci, Shortest Path in DAG, LIS, Edit Distance)
parent: DSA
nav_order: 5
layout: default
permalink: /dsa/dynamic-programming-1/
---

# Dynamic Programming Part 1 (Fibonacci, Shortest Path in DAG, LIS, Edit Distance)

## Introduction

One may think of dynamic programming as recursion with memoization.



<div class="sectionlecturebox">
Fibonacci Sequence
</div>

The Fibonacci sequence is defined as follows. $F_0 = 0, F_1 = 1$. For $i > 1$, $F_i = F_{i-1} + F_{i-2}$. So the sequence goes like this $0, 1, 1, 2, 3, 5, 8, 13, \ldots$

This suggests a recursive algorithm:

```julia
function fibonacci(i)
    if i == 0
        return 0
    elseif i == 1
        return 1
    else
        return fibonacci(i - 1) + fibonacci(i - 2)
    end
end
```

The running time of this algorithm is

$$
T(n) = T(n-1) + T(n-2) + O(1) \ge 2T(n-2) + c.
$$

**Exercise:** Use recursion tree method to show that the running time is $\Omega(2^n)$.

Why is the above algorithm wasteful? That's because there is a lot of repeated computation. For example, the recursion tree for `fibonacci(5)` looks like this:

```
                            fib(5)
                 ┌────────────┴────────────┐
              fib(4)                      fib(3)
         ┌──────┴──────┐            ┌──────┴──────┐
      fib(3)         fib(2)      fib(2)         fib(1)
     ┌───┴───┐      ┌───┴───┐   ┌───┴───┐
  fib(2)  fib(1) fib(1) fib(0) fib(1) fib(0)
  ┌──┴──┐
fib(1) fib(0)
```

Notice how `fib(3)` is computed twice, `fib(2)` is computed three times, and so on. We can avoid this repeated computation by storing previously computed values.

### Top-Down (Memoization)

We try to avoid repeated computation by checking if the computation has been done before.

```julia
function compute_fibonacci(n)
    F = fill(nothing, n + 1)  # F[1] stores F_0, ..., F[n+1] stores F_n

    function fib(i)
        if i == 0
            return 0
        elseif i == 1
            return 1
        else
            if isnothing(F[i])      # F[i-1] not yet computed
                fib(i - 1)
            end
            if isnothing(F[i - 1])  # F[i-2] not yet computed
                fib(i - 2)
            end
            F[i + 1] = F[i] + F[i - 1]
            return F[i + 1]
        end
    end

    return fib(n)
end
```

### Bottom-Up

We can also fill the array $F$ bottom up deliberately.

```julia
function fibonacci_bottom_up(n)
    F = zeros(Int, n + 1)  
    F[1] = 0  
    F[2] = 1  
    for i in 2:n
        F[i + 1] = F[i] + F[i - 1]
    end
    return F[n + 1]
end
```

The running time is $O(n)$ (assuming additions take constant time) which is a great improvement over naive recursion.
There are a few things that we should consider when designing a dynamic programming algorithm:
- Define the dynamic programming table.
- What are the base cases?
- How to fill the table?


<div class="sectionlecturebox">
Shortest Path in Directed Acyclic Graphs
</div>

We will talk more about graphs and related terminology later. For now, think of a graph as a set of vertices/nodes $V$ and a set of edges $E$ connecting them. A directed graph is a graph where each edge has a direction. Often we use $n = \lvert V \rvert$ and $m = \lvert E \rvert$.

We consider a directed graph in topological order. For simplicity, assume we have vertices $v_1, v_2, \ldots, v_n$ and directed edges in the graph only go from $v_i$ to $v_j$ where $i < j$. Note that this graph has no cycle (why?).

We are also given an array $W$ where $W[v_i, v_j]$ is the length of edge $v_i \to v_j$. Furthermore, $\text{incoming}(v_i)$ is the list of all vertices that have an edge going toward $v_i$.

For example, consider the following DAG with 6 vertices $v_1, v_2, \ldots, v_6$ (already in topological order) and edge weights as shown.

<script type="text/tikz">
\begin{tikzpicture}[>=stealth, thick,
    every node/.style={circle, draw, minimum size=8mm, inner sep=1pt},
    lbl/.style={draw=none, minimum size=0, fill=white, inner sep=1pt}]
  \node (v1) at (0,0) {$v_1$};
  \node (v2) at (2.5,0) {$v_2$};
  \node (v3) at (5,0) {$v_3$};
  \node (v4) at (7.5,0) {$v_4$};
  \node (v5) at (10,0) {$v_5$};
  \node (v6) at (12.5,0) {$v_6$};

  \draw[->] (v1) to[bend left=30] node[lbl, above] {2} (v2);
  \draw[->] (v2) to[bend left=30] node[lbl, above] {3} (v3);
  \draw[->] (v2) to[bend right=30] node[lbl, below] {4} (v4);
  \draw[->] (v3) to[bend left=30] node[lbl, above] {1} (v5);
  \draw[->] (v4) to[bend right=30] node[lbl, below] {2} (v5);
  \draw[->] (v5) to[bend left=30] node[lbl, above] {1} (v6);
  \draw[->] (v1) to[bend right=50] node[lbl, below] {6} (v4);
  \draw[->] (v1) to[bend left=50] node[lbl, above] {10} (v5);
\end{tikzpicture}
</script>

The input provides us with $\text{incoming}(v_i)$ that lists all vertices that have an edge going toward $v_i$.
For instance, $\text{incoming}(v_5) = \lbrace v_1, v_3, v_4 \rbrace$ with $W[v_1, v_5] = 10$, $W[v_3, v_5] = 1$, $W[v_4, v_5] = 2$. 



The goal is to compute $dist[1 \ldots n]$ where $dist[i]$ is the length of the shortest path from $v_1$ to $v_i$.

- Clearly, $dist[1] = 0$. The shortest path from $v_1$ to itself is just $v_1$.

- Consider any node $v_i$. The shortest path from $v_1$ to $v_i$ (denoted by $v_1 \leadsto v_i$) must go through some predecessor $v_j$ of $v_i$ (i.e., $j < i$ where there is an edge $v_j \to v_i$) and then go from $v_j$ to $v_i$ using the edge $v_j \to v_i$ (it is possible that $v_j = v_1$ if there is an edge from $v_1$ to $v_i$).

- If $v_1 \leadsto v_i$ goes through $v_j$ before going from $v_j$ to $v_i$ using the edge $v_j \to v_i$, then the length of that path would be the length of the shortest path $v_1 \leadsto v_j$ plus the length of the edge $v_j \to v_i$.

- Thus,

$$
dist[v_i] = \min_{j < i: v_j \to v_i \in E} (dist[v_j] + W[v_j, v_i]).
$$

For instance, $dist[v_5] = \min(dist[v_1] + 10, \; dist[v_3] + 1, \; dist[v_4] + 2)$. Since we rely on previously computed values to the left of $i$, we can fill the table from left to right.


We would also like to reconstruct the actual shortest paths. We observe that if the shortest path from $v_1$ to $v_i$ goes through $v_j$ right before $v_i$ (i.e., $v_1 \leadsto v_j \to v_i$), then the shortest path from $v_1$ to $v_j$ must be a subpath of the shortest path from $v_1$ to $v_i$. Hence, we can keep track of the predecessor of each vertex in the shortest path and reconstruct the path by backtracking.

For example, if the shortest path from $v_1$ to $v_{10}$ is $v_1 \to v_3 \to v_5 \to v_{10}$, then $\pi[10] = 5$, $\pi[5] = 3$, $\pi[3] = 1$, and $\pi[1] = 0$ (or some sentinel value). To reconstruct the path, we start from $v_{10}$ and keep going to its predecessor until we reach $v_1$.

### Julia Implementation

```julia
function shortest_path_dag(n, incoming, W)
    dist = fill(Inf, n)
    π = fill(0, n)  # π[i] = predecessor of v_i in the shortest path
    dist[1] = 0

    for i in 2:n
        for vj in incoming[i]
            if dist[vj] + W[vj, i] < dist[i]
                dist[i] = dist[vj] + W[vj, i]
                π[i] = vj
            end
        end
    end

    return dist, π
end
```

The outer loop executes $O(\lvert V \rvert)$ times. The inner loop iterates over incoming edges, and across all iterations, each edge is visited exactly once, contributing $O(\lvert E \rvert)$ total. Hence, the running time is $O(\lvert V \rvert + \lvert E \rvert)$.


<div class="sectionlecturebox">
Longest Increasing Subsequence
</div>

Given an array $A[1 \ldots n]$, what is the longest increasing subsequence (LIS) in $A$?

**Motivation**: This is one way to measure how sorted a database is. If the length of the LIS is close to $n$, then $A$ is nearly sorted.

Let us create a graph where node $i$ corresponds to $A[i]$. If $A[j] \le A[i]$ and $j \le i$, then create an edge $j \to i$ with length 1. Otherwise, $W(j, i) = \emptyset$. Note that this graph is also directed acyclic.

Clearly, an increasing subsequence corresponds to a directed path. Hence, the goal is to find the longest directed path in the graph we created.

Let $L[i]$ be the length of the longest path ending at vertex $i$ plus 1 (ie, this corresponds to the length of the longest increasing subsequence ending at $A[i]$). Again,

- $L[1] = 1$ since the longest path ending at $v_1$ is just $v_1$ itself.

- Consider any node $i$. The longest path ending at $i$ must go through some $v_i$'s predecessor $v_j$ (i.e., $j < i$ where there is an edge $v_j \to v_i$) and then go from $v_j$ to $v_i$ using the edge $v_j \to v_i$. If $i$ has no predecessor, then the longest path ending at $i$ is just $i$ itself.

- Thus,

$$
L[i] = \begin{cases} \max_{j < i}(L[j] + 1) & \text{if there is some } j \text{ s.t } A[j] \le A[i] \\ 1 & \text{otherwise} \end{cases}
$$

### Julia Implementation

```julia
function lis(A)
    n = length(A)
    L = ones(Int, n)  # initialize all entries to 1

    for i in 2:n
        for j in 1:i-1
            if A[j] ≤ A[i] && L[j] + 1 > L[i]
                L[i] = L[j] + 1
            end
        end
    end

    return maximum(L)
end
```

The running time is $O(n^2)$.

<div class="sectionlecturebox">
Edit Distance
</div>

We are given 2 input strings $A$ and $B$ of length $n$ and $m$ respectively. What is the minimum number of insertions, deletions, and replacements to transform $A$ into $B$?

**Applications:** Comparing documents or DNA sequences.

**Example 1.** Consider $A = \text{TRACE}$ and $B = \text{CRAFT}$. Think of this process as placing gaps into the 2 strings to align them together. For example, the below corresponds to 1) Replace T with C, 2) Replace C with F, and 3) Replace E with T. There are 3 edits in total.

| T | R | A | C | E |
|---|---|---|---|---|
| C | R | A | F | T |

**Example 2.** Let's consider the same 2 strings, but a different alignment. The below corresponds to 1) Insert C, 2) Delete T, 3) Delete C, 4) Replace E with F, 5) Insert T. There are 5 edits in total.

| \_ | T | R | A | C | E | \_ |
|---|---|---|---|---|---|---|
| C | \_ | R | A | \_ | F | T |

The question is to place the gaps that correspond to the smallest number of edits which is the edit distance between $A$ and $B$.

### A DP Approach

We define the dynamic programming table as follows.

$$
ED[i,j] = \text{edit distance between } A[1 \ldots i] \text{ and } B[1 \ldots j].
$$

Consider the optimal gap placing. There are 3 cases for the last column:

- **Case 1: deleting $A[i]$ at the end.**
  The cost would be $ED[i-1, j] + 1$. This corresponds to first transform $A[1 \ldots i-1]$ to $B[1 \ldots j]$ and then delete $A[i]$ at the end.

- **Case 2: inserting $B[j]$ at the end.**
  The cost would be $ED[i, j-1] + 1$. This corresponds to first transform $A[1 \ldots i]$ to $B[1 \ldots j-1]$ and then insert $B[j]$ at the end.

- **Case 3: substituting $A[i]$ with $B[j]$.**
  The cost would be $ED[i-1, j-1] + \text{diff}(i, j)$ where

$$
\text{diff}(i, j) = \begin{cases} 1 & \text{if } A[i] \ne B[j] \\ 0 & \text{if } A[i] = B[j] \end{cases}.
$$

  This corresponds to first transform $A[1 \ldots i-1]$ to $B[1 \ldots j-1]$ and then replace $A[i]$ with $B[j]$ at the end if $A[i] \ne B[j]$.

We have the following recursive relationship:

$$
ED[i, j] = \min\{ED[i-1, j] + 1, \; ED[i, j-1] + 1, \; ED[i-1, j-1] + \text{diff}(i, j)\}.
$$

Base case: $ED[i, 0] = i$ and $ED[0, j] = j$ (Why?).

### Julia Implementation

```julia
function edit_distance(A::String, B::String)
    n, m = length(A), length(B)
    ED = zeros(Int, n + 1, m + 1)

    # Base cases
    for i in 0:n
        ED[i + 1, 1] = i
    end
    for j in 0:m
        ED[1, j + 1] = j
    end

    # Fill the table
    for i in 1:n
        for j in 1:m
            diff = A[i] == B[j] ? 0 : 1
            ED[i + 1, j + 1] = min(
                ED[i, j + 1] + 1,      # delete A[i]
                ED[i + 1, j] + 1,      # insert B[j]
                ED[i, j] + diff         # substitute
            )
        end
    end

    return ED[n + 1, m + 1]
end
```

The running time is $O(nm)$.

**Exercise:** Add code to reconstruct the actual edits (insertions, deletions, substitutions) that transform $A$ into $B$ with the minimum number of edits.