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

Given two strings $A[1 \ldots n]$ and $B[1 \ldots m]$, the **longest common subsequence (LCS)** is the longest sequence that is a subsequence of both $A$ and $B$. A subsequence is obtained by deleting some characters (possibly none) without changing the order of the remaining characters.

**Example:** Let $A = \text{ABCBDAB}$ and $B = \text{BDCAB}$. One LCS is $\text{BCAB}$ (length 4).  Another LCS of length 4 is $\text{BDAB}$.

**Contrast with substrings:** A substring must be contiguous. A subsequence need not be.

### DP Formulation

Define the DP table as follows:

$$
LCS[i, j] = \text{length of the LCS of } A[1 \ldots i] \text{ and } B[1 \ldots j].
$$

Consider the LCS of $A[1 \ldots i]$ and $B[1 \ldots j]$. There are two cases:

- **Case 1: $A[i] = B[j]$.**
  The last character matches, so we can always extend the LCS of $A[1 \ldots i-1]$ and $B[1 \ldots j-1]$ by this matching character. Thus $LCS[i, j] = LCS[i-1, j-1] + 1$.

- **Case 2: $A[i] \ne B[j]$.**
  The last characters do not match, so the LCS cannot end with both $A[i]$ and $B[j]$. Either the LCS does not use $A[i]$ (so $LCS[i, j] = LCS[i-1, j]$), or the LCS does not use $B[j]$ (so $LCS[i, j] = LCS[i, j-1]$). We take the maximum.

This gives the recurrence:

$$
LCS[i, j] = \begin{cases}
LCS[i-1, j-1] + 1 & \text{if } A[i] = B[j] \\
\max(LCS[i-1, j],\ LCS[i, j-1]) & \text{if } A[i] \ne B[j]
\end{cases}
$$

**Base cases:** $LCS[i, 0] = 0$ for all $i$ (comparing with an empty string) and $LCS[0, j] = 0$ for all $j$.

**Filling order:** $LCS[i, j]$ depends on $LCS[i-1, j-1]$, $LCS[i-1, j]$, and $LCS[i, j-1]$, i.e., values from the row above and the column to the left. We can fill the table row by row, left to right.

**Answer:** $LCS[n, m]$.

**Running time:** $O(nm)$.

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

### Julia Implementation

```julia
function lcs(A::String, B::String)
    n, m = length(A), length(B)
    L = zeros(Int, n + 1, m + 1)

    for i in 1:n
        for j in 1:m
            if A[i] == B[j]
                L[i + 1, j + 1] = L[i, j] + 1
            else
                L[i + 1, j + 1] = max(L[i, j + 1], L[i + 1, j])
            end
        end
    end

    return L[n + 1, m + 1]
end
```

**Exercise:** Modify the implementation to reconstruct the actual LCS string, not just its length. 


<div class="sectionlecturebox">
0/1 Knapsack: Value-Based (Maximize Value)
</div>

You have $n$ items. Item $i$ has weight $w[i]$ and value $v[i]$. You have a knapsack of capacity $W$. Each item can either be taken or left behind (0/1). The goal is to choose a subset of items with total weight $\le W$ that maximizes total value.

**Example:** Suppose $W = 10$ and the items are:

| Item | Weight | Value |
|------|--------|-------|
| 1    | 2      | 6     |
| 2    | 5      | 9     |
| 3    | 4      | 5     |
| 4    | 3      | 7     |

Taking items 1, 2, and 4 gives weight $2 + 5 + 3 = 10$ and value $6 + 9 + 7 = 22$.

### DP Formulation

Define the DP table as follows:

$$
K[i, c] = \text{maximum value achievable using items } 1 \ldots i \text{ with weight capacity } c.
$$

For item $i$ with capacity $c$, there are two choices:

- **Skip item $i$:** The capacity is unchanged, so $K[i, c] = K[i-1, c]$.
- **Take item $i$:** Only possible if $w[i] \le c$. We use $w[i]$ of the capacity and gain $v[i]$ in value, so $K[i, c] = K[i-1, c - w[i]] + v[i]$.

This gives the recurrence:

$$
K[i, c] = \begin{cases}
K[i-1, c] & \text{if } w[i] > c \\
\max\bigl(K[i-1, c],\ K[i-1, c - w[i]] + v[i]\bigr) & \text{if } w[i] \le c
\end{cases}
$$

**Base cases:** $K[0, c] = 0$ for all $c$ (no items, no value) and $K[i, 0] = 0$ for all $i$ (no capacity, no value).

**Filling order:** $K[i, c]$ depends only on row $i-1$, so we fill the table row by row.

**Answer:** $K[n, W]$.

**Running time:** $O(nW)$.

### Julia Implementation

```julia
function knapsack_value(weights, values, W)
    n = length(weights)
    K = zeros(Int, n + 1, W + 1)

    for i in 1:n
        for c in 0:W
            K[i + 1, c + 1] = K[i, c + 1]             # skip item i
            if weights[i] <= c
                K[i + 1, c + 1] = max(
                    K[i + 1, c + 1],
                    K[i, c + 1 - weights[i]] + values[i]  # take item i
                )
            end
        end
    end

    return K[n + 1, W + 1]
end
```

**Reconstructing the solution:** To find which items are selected, trace back through the table. If $K[i, c] > K[i-1, c]$, then item $i$ was taken, and we move to $K[i-1, c - w[i]]$. Otherwise, item $i$ was skipped, and we move to $K[i-1, c]$.

```julia
function knapsack_value_with_items(weights, values, W)
    n = length(weights)
    K = zeros(Int, n + 1, W + 1)

    for i in 1:n
        for c in 0:W
            K[i + 1, c + 1] = K[i, c + 1]
            if weights[i] <= c
                K[i + 1, c + 1] = max(
                    K[i + 1, c + 1],
                    K[i, c + 1 - weights[i]] + values[i]
                )
            end
        end
    end

    # Traceback to find selected items
    selected = Int[]
    c = W
    for i in n:-1:1
        if K[i + 1, c + 1] != K[i, c + 1]  # item i was taken
            push!(selected, i)
            c -= weights[i]
        end
    end

    return K[n + 1, W + 1], reverse(selected)
end
```

**Exercise:** What happens if item weights and values are not integers? The $O(nW)$ algorithm no longer applies directly. Can you think of why?

<div class="sectionlecturebox">
0/1 Knapsack: Weight-Based (Minimize Weight)
</div>

Now consider the **dual** problem: given $n$ items with weights $w[i]$ and values $v[i]$, and a target value $V$, find the minimum total weight of a subset of items whose total value is **at least** $V$.

This formulation is useful when the knapsack capacity is flexible, but we have a minimum value requirement to meet (e.g., meeting a quota with as little resource as possible).

**Example:** Using the same items as before with target $V = 20$:

| Item | Weight | Value |
|------|--------|-------|
| 1    | 2      | 6     |
| 2    | 5      | 9     |
| 3    | 4      | 5     |
| 4    | 3      | 7     |

Taking items 1, 2, and 4 gives value $6 + 9 + 7 = 22 \ge 20$ with weight $2 + 5 + 3 = 10$.
Taking items 2 and 4 gives value $9 + 7 = 16 < 20$ — not enough.
Taking items 1, 2, and 4 achieves value 22, but can we do better? Items 1 and 2 and 3 give $6 + 9 + 5 = 20 \ge 20$ with weight $2 + 5 + 4 = 11$. So items 1, 2, 4 (weight 10) is better.

### DP Formulation

Instead of indexing by weight capacity, we now index by value. Let $V_{\max} = \sum_{i=1}^n v[i]$ be the maximum possible value.

Define the DP table as follows:

$$
M[i, u] = \text{minimum weight to achieve exactly value } u \text{ using items } 1 \ldots i.
$$

If it is impossible to achieve exactly value $u$ using items $1 \ldots i$, we set $M[i, u] = +\infty$.

For item $i$ with target value $u$, there are two choices:

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

**Filling order:** $M[i, u]$ depends only on row $i-1$, so we fill the table row by row.

**Answer:** $\displaystyle\min_{u \ge V} M[n, u]$, i.e., the minimum weight over all achievable values that meet the target $V$.

**Running time:** $O(n \cdot V_{\max})$ where $V_{\max} = \sum_{i=1}^n v[i]$.

### Comparison with Value-Based Knapsack

| | Value-Based | Weight-Based |
|---|---|---|
| **Goal** | Maximize value | Minimize weight |
| **Constraint** | Total weight $\le W$ | Total value $\ge V$ |
| **Table index** | Weight capacity $c \in [0, W]$ | Value target $u \in [0, V_{\max}]$ |
| **Table size** | $n \times W$ | $n \times V_{\max}$ |
| **Answer** | $K[n, W]$ | $\min_{u \ge V} M[n, u]$ |

When $W$ is large but values are small integers, the weight-based DP is more efficient. When $V_{\max}$ is large but weights are small integers, the value-based DP is more efficient.

### Julia Implementation

```julia
function knapsack_weight(weights, values, V)
    n = length(weights)
    V_max = sum(values)
    M = fill(typemax(Int) ÷ 2, n + 1, V_max + 1)  # ÷ 2 to avoid overflow
    M[1, 1] = 0  # M[0, 0] = 0 (1-indexed: row 1 = 0 items)

    for i in 1:n
        for u in 0:V_max
            M[i + 1, u + 1] = M[i, u + 1]             # skip item i
            if values[i] <= u && M[i, u + 1 - values[i]] < typemax(Int) ÷ 2
                M[i + 1, u + 1] = min(
                    M[i + 1, u + 1],
                    M[i, u + 1 - values[i]] + weights[i]  # take item i
                )
            end
        end
    end

    # Find minimum weight over all values >= V
    best = typemax(Int)
    for u in V:V_max
        best = min(best, M[n + 1, u + 1])
    end

    return best == typemax(Int) ? -1 : best  # -1 if no feasible solution
end
```

**Exercise:** Modify the implementation to also return which items are selected, similar to the traceback in the value-based version.

**Exercise:** In both knapsack variants, each item is taken at most once (0/1 knapsack). If items can be taken multiple times, how would the recurrence change? (This is called the **unbounded knapsack** problem.)