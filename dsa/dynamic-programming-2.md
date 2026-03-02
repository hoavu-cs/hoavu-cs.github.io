---
title: Dynamic Programming Part 2 (LCS, Knapsack)
parent: DSA
nav_order: 6
layout: default
permalink: /dsa/dynamic-programming-2/
---

# Dynamic Programming Part 2 (LCS, Knapsack)

<div class="sectionlecturebox">
Longest Common Subsequence
</div>

A subsequence is obtained by deleting some characters (possibly none) without changing the order of the remaining characters.
Given two strings $A[1 \ldots n]$ and $B[1 \ldots m]$, the **longest common subsequence (LCS)** is the longest sequence that is a subsequence of both $A$ and $B$. 

**Example:** Let $A = \text{ABCBDAB}$ and $B = \text{BDCAB}$. One LCS is $\text{BCAB}$ (length 4).  Another LCS of length 4 is $\text{BDAB}$.

**Contrast with substrings:** A substring must be contiguous. A subsequence need not be.

### DP Formulation

Define the DP table as follows:

$$
LCS[i, j] = \text{length of the LCS of } A[1 \ldots i] \text{ and } B[1 \ldots j].
$$

### Example Table

For $A = \text{ABCB}$ and $B = \text{BCB}$:

|       |   | B | C | B |
|-------|---|---|---|---|
|       | 0 | 0 | 0 | 0 |
| **A** | 0 | 0 | 0 | 0 |
| **B** | 0 | 1 | 1 | 1 |
| **C** | 0 | 1 | 2 | 2 |
| **B** | 0 | 1 | 2 | 3 |

The LCS has length 3, which is $\text{BCB}$.

Consider the LCS of $A[1 \ldots i]$ and $B[1 \ldots j]$. There are two cases:

- **Case 1: $A[i] = B[j]$.**
  We can match the last characters $A[i]$ and $B[j]$ to extend the LCS of $A[1 \ldots i-1]$ and $B[1 \ldots j-1]$. This gives us a subsequent of length $LCS[i-1, j-1] + 1$.

- **Case 2: $A[i] \ne B[j]$.**
  The last characters do not match, so the LCS cannot end with both $A[i]$ and $B[j]$. The LCS must exclude $A[i]$ or $B[j]$. In this case, $LCS[i, j]$ is the maximum of $LCS[i-1, j]$ and $LCS[i, j-1]$.

This gives the recurrence:

$$
LCS[i, j] = \begin{cases}
LCS[i-1, j-1] + 1 & \text{if } A[i] = B[j] \\
\max(LCS[i-1, j],\ LCS[i, j-1]) & \text{if } A[i] \ne B[j]
\end{cases}
$$

**Base cases:** $LCS[i, 0] = 0$ for all $i$ and $LCS[0, j] = 0$ for all $j$ since the LCS of any string with the empty string is an empty string.

**Filling order:** $LCS[i, j]$ depends on $LCS[i-1, j-1]$, $LCS[i-1, j]$, and $LCS[i, j-1]$, i.e., values from the row above and the column to the left. We can fill the table row by row, left to right.

The final answer is $LCS[n, m]$. Obviously, the running time is $O(nm)$. We can also reconstruct the LCS string by tracing back through the table.



### Julia Implementation

```julia
using OffsetArrays

function lcs(A::String, B::String)
    n, m = length(A), length(B)
    L = OffsetArray(zeros(Int, n + 1, m + 1), 0:n, 0:m)

    for i in 1:n
        for j in 1:m
            if A[i] == B[j]
                L[i, j] = L[i - 1, j - 1] + 1
            else
                L[i, j] = max(L[i - 1, j], L[i, j - 1])
            end
        end
    end

    # Reconstruct the LCS string
    lcs_str = ""
    i, j = n, m
    while i > 0 && j > 0
        if A[i] == B[j]
            lcs_str = string(A[i]) * lcs_str  # prepend character to LCS
            i -= 1
            j -= 1
        elseif L[i - 1, j] > L[i, j - 1]
            i -= 1
        else
            j -= 1
        end
    end

    return L[n, m], lcs_str
end
```



<div class="sectionlecturebox">
0/1 Knapsack: Value-Based (Maximize Value)
</div>

You have $n$ items. Item $i$ has weight $w[i]$ and value $v[i]$. You have a knapsack of capacity $W$. Each item can either be taken or left behind (0/1). The goal is to choose a subset of items with total weight $\le W$ that maximizes total value. **For now, let us assume that weights and values are positive integers.**

This models many real-world problems where you have a limited resource (weight, time, money) and want to maximize some benefit (value, profit, utility).

**Example:** Suppose $W = 10$ and the items are:

| Item | Weight | Value |
|------|--------|-------|
| 1    | 2      | 6     |
| 2    | 5      | 9     |
| 3    | 4      | 5     |
| 4    | 3      | 7     |

Taking items 1, 2, and 4 gives weight $2 + 5 + 3 = 10$ and value $6 + 9 + 7 = 22$. One strategy would be to rank items by value-to-weight ratio and take the best ones until the knapsack is full. However, this greedy approach does not always yield the optimal solution. 

For examples, consider $W = 40$ with items $ \lbrace (w[i], v[i]) \rbrace = \lbrace (20, 100), (20, 100), (25, 150) \rbrace$. The greedy approach would take the last item first since it has the best value-to-weight ratio which gives value 150. However, the optimal solution is to take the first two items for a total value of 200.

### DP Formulation

Define the DP table as follows:

$$
K[i, c] = \text{maximum value achievable using items } 1 \ldots i \text{ with weight capacity } c.
$$

For item $i$ with capacity $c$, there are two choices:

- **Skip item $i$:** The capacity is unchanged and we still have the first $i-1$ items to consider, so this gives us value $K[i-1, c]$.
- **Take item $i$:** Only possible if $w[i] \le c$. We use $w[i]$ of the capacity and gain $v[i]$ in value, so $K[i, c] = K[i-1, c - w[i]] + v[i]$.

This gives the recurrence:

$$
K[i, c] = \begin{cases}
K[i-1, c] & \text{if } w[i] > c \\
\max\bigl(K[i-1, c],\ K[i-1, c - w[i]] + v[i]\bigr) & \text{if } w[i] \le c
\end{cases}
$$

**Base cases:** $K[0, c] = 0$ for all $c > 0$ (no items, no value) and $K[i, 0] = 0$ for all $i$ (no capacity, no value).

$K[i, c]$ depends only on row $i-1$, so we fill the table row by row and the final answer is at $K[n, W]$. The running time is $O(nW)$.

To reconstruct the items selected, we can trace back through the table starting from $K[n, W]$ and checking whether each item was included or not
by comparing $K[i, c]$ with $K[i-1, c]$. If they are equal, item $i$ was not included; if they differ, item $i$ was included and we reduce the capacity by $w[i]$ and continue tracing back.

### Julia Implementation

```julia
function knapsack(weights, values, W)
    n = length(weights)
    K = OffsetArray(zeros(Int, n + 1, W + 1), 0:n, 0:W)

    for i in 1:n
        for c in 0:W
            K[i, c] = K[i - 1, c]              # skip item i
            if weights[i] <= c
                K[i, c] = max(
                    K[i, c],
                    K[i - 1, c - weights[i]] + values[i]  # take item i
                )
            end
        end
    end

    # Reconstruct the items selected
    selected_items = []
    c = W
    for i in n:-1:1
        if K[i, c] != K[i - 1, c]  # item i was included
            push!(selected_items, i)
            c -= weights[i]
        end
    end

    return K[n, W], selected_items
end
```

<div class="sectionlecturebox">
0/1 Knapsack: Weight-Based (Minimize Weight)
</div>

We consider an alternative solution to the knapsack problem. This approach will later be beneficial when we try to approximate optimal solutions in running time that does not depend on the knapsack capacity $W$ (which will be presented later in the course when we talk about approximation algorithms for NP-hard problems). 

### DP Formulation

Instead of indexing by weight capacity, we now index by value. Let $V_{\max} = \sum_{i=1}^n v[i]$ be the maximum possible value.

Define the DP table as follows:

$$
M[i, u] = \text{minimum weight to achieve exactly value } u \text{ using items } 1 \ldots i.
$$

If it is impossible to achieve exactly value $u$ using items $1 \ldots i$, we set $M[i, u] = +\infty$. For item $i$ with target value $u$, there are two choices:

- **Skip item $i$:** $M[i, u] = M[i-1, u]$.
- **Take item $i$:** Only possible if $v[i] \le u$ (otherwise item $i$ alone already overshoots $u$, so we need value $u - v[i]$ from the remaining items). We add weight $w[i]$ and reduce the remaining value target: $M[i, u] = M[i-1, u - v[i]] + w[i]$.

This gives the recurrence:

$$
M[i, u] = \begin{cases}
M[i-1, u] & \text{if } v[i] > u \\
\min\bigl(M[i-1, u],\ M[i-1, u - v[i]] + w[i]\bigr) & \text{if } v[i] \le u
\end{cases}
$$

**Base cases:** $M[0, 0] = 0$ (zero items, zero value, zero weight) and $M[0, u] = +\infty$ for $u > 0$ (impossible to achieve positive value with no items).

Since $M[i, u]$ depends only on row $i-1$, so we fill the table row by row.

Finally, we go over all $u$ from $0$ to $V_{\max}$ and return the largest $u$ such that $M[n, u] \le W$. The running time would be $O(n \cdot V_{\max})$ where $V_{\max} = \sum_{i=1}^n v[i]$ since we need to fill a table of size $n \times V_{\max}$.


### Julia Implementation

```julia
function knapsack_weight(weights, values, W)
    n = length(weights)
    V_max = sum(values)
    M = OffsetArray(fill(typemax(Int) ÷ 2, n + 1, V_max + 1), 0:n, 0:V_max)  # ÷ 2 to avoid overflow
    M[0, 0] = 0

    for i in 1:n
        for u in 0:V_max
            M[i, u] = M[i - 1, u]              # skip item i
            if values[i] <= u && M[i - 1, u - values[i]] < typemax(Int) ÷ 2
                M[i, u] = min(
                    M[i, u],
                    M[i - 1, u - values[i]] + weights[i]  # take item i
                )
            end
        end
    end

    # Find maximum value achievable with total weight <= W
    best = 0
    for u in 0:V_max
        if M[n, u] <= W
            best = u
        end
    end

    return best
end
```

**Exercise:** Modify the implementation to also return which items are selected, similar to the traceback in the value-based version.

**Exercise:** In both knapsack variants, each item is taken at most once (0/1 knapsack). If items can be taken multiple times, how would the recurrence change? (This is called the **unbounded knapsack** problem.)