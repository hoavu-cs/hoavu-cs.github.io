---
title: Prefix Sum and Difference Array
parent: DSA
nav_order: 8
layout: default
permalink: /dsa/prefix-sum-difference-array/
---

# Prefix Sum and Difference Array

These two data structures are complementary: a **prefix sum array** turns range-sum *queries* into $O(1)$ lookups after $O(n)$ preprocessing; a **difference array** turns range-increment *updates* into $O(1)$ mutations after $O(n)$ preprocessing. Both reconstruct the original array via a single pass.

<div class="sectionlecturebox">
Prefix Sum
</div>

Given an array $A[1 \ldots n]$, define the prefix sum array $P[0 \ldots n]$ as

$$
P[0] = 0, \qquad P[i] = \sum_{k=1}^{i} A[k] \text{ for } i \ge 1.
$$

**Range-sum query.** The sum of $A[l \ldots r]$ is

$$
\text{sum}(l, r) = P[r] - P[l - 1].
$$

This follows directly from $P[r] = P[l-1] + A[l] + \cdots + A[r]$.

**Example.** Let $A = [3, 1, 4, 1, 5, 9, 2, 6]$.

| $i$    | 0 | 1 | 2 | 3 | 4 |  5 |  6 |  7 |  8 |
|--------|---|---|---|---|---|----|----|----|----|
| $A[i]$ |   | 3 | 1 | 4 | 1 |  5 |  9 |  2 |  6 |
| $P[i]$ | 0 | 3 | 4 | 8 | 9 | 14 | 23 | 25 | 31 |

Query $\text{sum}(3, 6) = P[6] - P[2] = 23 - 4 = 19$. Check: $4 + 1 + 5 + 9 = 19$. 

### Julia Implementation

```julia
using OffsetArrays

function build_prefix_sum(A)
    n = length(A)
    P = OffsetArray(zeros(Int, n + 1), 0:n)
    for i in 1:n
        P[i] = P[i - 1] + A[i]
    end
    return P
end

function range_sum(P, l, r)
    return P[r] - P[l - 1]
end
```

**Running time:** $O(n)$ to build $P$; $O(1)$ per query.

**Exercise** Given an array $A[1 \ldots n]$. Count the number of subarrays $A[l \ldots r]$ in which $\sum_{k=l}^r A[k] = r-l+1$. That is the sum of the subarray is equal to its length. Can you do it in $O(n)$ time?



<div class="sectionlecturebox">
Difference Array
</div>

The difference array is the inverse tool: it supports fast *range updates* at the cost of making point queries $O(n)$. For example, if we want to add a value $v$ to every element $A[l], A[l+1], \ldots, A[r]$, the naive approach is to loop through the range and increment each element, which takes $O(r-l+1)$ time. The difference array allows us to do this in $O(1)$ time. At the end, we can reconstruct the original array by taking the prefix sum of the difference array.

Given $A[1 \ldots n]$, the difference array $D[1 \ldots n]$ is defined as

$$
D[1] = A[1], \qquad D[i] = A[i] - A[i-1] \text{ for } i \ge 2.
$$

Equivalently, $A$ is the prefix sum of $D$: $A[i] = D[1] + D[2] + \cdots + D[i]$.

**Range update.** To add a value $v$ to every element $A[l], A[l+1], \ldots, A[r]$:

$$
D[l] \mathrel{+}= v, \qquad D[r+1] \mathrel{-}= v \quad (\text{if } r < n).
$$

After all updates, reconstruct $A$ by taking the prefix sum of $D$.

**Why this works.** Adding $v$ to $D[l]$ propagates forward to all $A[i]$ for $i \ge l$. Subtracting $v$ at $D[r+1]$ cancels it for all $A[i]$ with $i \ge r+1$. The net effect is that only $A[l \ldots r]$ is incremented by $v$.

**Example.** Start with $A = [0, 0, 0, 0, 0]$, so $D = [0, 0, 0, 0, 0]$.

- Add 3 to $A[2 \ldots 4]$: $D[2] \mathrel{+}= 3$, $D[5] \mathrel{-}= 3$ → $D = [0, 3, 0, 0, -3]$
- Add 1 to $A[1 \ldots 3]$: $D[1] \mathrel{+}= 1$, $D[4] \mathrel{-}= 1$ → $D = [1, 3, 0, -1, -3]$

Reconstruct $A$ (prefix sum of $D$): $A = [1, 4, 4, 3, 0]$.

Check: indices 2–4 were incremented by 3 (giving 3, 3, 3), then indices 1–3 by 1 (giving 1, 1, 1). So $A = [0{+}1,\ 0{+}3{+}1,\ 0{+}3{+}1,\ 0{+}3,\ 0] = [1, 4, 4, 3, 0]$. 

### Julia Implementation

```julia
function build_difference_array(A)
    n = length(A)
    D = copy(A)
    for i in n:-1:2
        D[i] -= A[i - 1]
    end
    return D
end

function range_update!(D, l, r, v)
    D[l] += v
    if r + 1 <= length(D)
        D[r + 1] -= v
    end
end

function reconstruct(D)
    A = copy(D)
    for i in 2:length(A)
        A[i] += A[i - 1]
    end
    return A
end
```

**Running time:** $O(n)$ to build; $O(1)$ per range update; $O(n)$ to reconstruct.

**Exercise** Karen, a coffee aficionado, wants to know the optimal temperature for brewing the perfect cup of coffee. Indeed, she has spent some time reading several recipe books.

She knows $n$ coffee recipes. The $i$th recipe suggests that coffee should be brewed between $l_i$ and $r_i$ degrees, inclusive, to achieve the optimal taste.

Karen thinks that a temperature is admissible if at least $k$ recipes recommend it.

Karen has a rather fickle mind, and so she asks $q$ questions. In each question, given that she only wants to prepare coffee with a temperature between $a$ and $b$, inclusive, can you tell her how many admissible integer temperatures fall within the range?

The input can be represented as follows:

```
n k q
l_1 r_1
l_2 r_2
...
l_n r_n
a_1 b_1
a_2 b_2
...
a_q b_q
```
