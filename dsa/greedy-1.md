---
title: Greedy Algorithms 1
parent: DSA
nav_order: 9
layout: default
permalink: /dsa/greedy-1/
---

# Greedy Algorithms 1

Greedy algorithms, informally, are algorithms that aim to find solutions by performing a series of steps each of which is greedy in some sense.

<div class="sectionlecturebox">Storing Files on Tape</div>

## Problem

You have $n$ files with sizes $s_1, s_2, \ldots, s_n$ stored sequentially on a tape. Because tape access is sequential, reading file $i$ requires reading all files before it first. If the files are stored in some order $\sigma$ (a permutation of $\{1, \ldots, n\}$), the cost to retrieve file $\sigma(j)$ is:

$$\text{cost}(\sigma(j)) = \sum_{k=1}^{j} s_{\sigma(k)}$$

Assuming each file is equally likely to be requested, the **total expected retrieval cost** is:

$$C(\sigma) = \sum_{j=1}^{n} \sum_{k=1}^{j} s_{\sigma(k)} = \sum_{j=1}^{n} (n - j + 1) \cdot s_{\sigma(j)}$$

**Goal:** Find a permutation $\sigma$ that minimizes $C(\sigma)$.

**Example.** Three files with sizes $[1, 2, 3]$. Two orderings:

- Order $[1, 2, 3]$: retrieval costs are $1,\ 1+2,\ 1+2+3$, total $= 1 + 3 + 6 = 10$.
- Order $[3, 2, 1]$: retrieval costs are $3,\ 3+2,\ 3+2+1$, total $= 3 + 5 + 6 = 14$.

The ordering matters significantly. The objective is to find one that minimizes the cost.

## Greedy Solution

**Claim.** Sort the files in **increasing order of size** (smallest first).

**Intuition:** A small file placed early contributes its size to the cost of every subsequent retrieval. Placing larger files later reduces how often their large sizes are counted.

## Proof of Optimality (Exchange Argument)

Suppose an optimal ordering $\sigma$ has two adjacent files $\sigma(j) = a$ and $\sigma(j+1) = b$ with $s_a > s_b$ (a larger file appears before a smaller one). We show swapping them does not increase the cost.

The total cost contributed by just these two files in the original order is:

$$C_{\text{before}} = (n - j + 1) \cdot s_a + (n - j) \cdot s_b$$

After swapping ($b$ before $a$):

$$C_{\text{after}} = (n - j + 1) \cdot s_b + (n - j) \cdot s_a$$

The difference is:

$$C_{\text{before}} - C_{\text{after}} = (n - j + 1)(s_a - s_b) - (n - j)(s_a - s_b) = s_a - s_b > 0$$

So $C_{\text{after}} < C_{\text{before}}$: swapping reduces the cost. Therefore any ordering with an inversion (a larger file before a smaller one) is suboptimal, and the unique optimal ordering is non-decreasing by file size. 


**Another proof.** Consider swapping two adjacent files $a$ (at position $j$) and $b$ (at position $j+1$). After the swap:

- The cost to read $a$ **increases** by $s_b$ (since $b$ now precedes $a$).
- The cost to read $b$ **decreases** by $s_a$ (since $b$ no longer has to skip over $a$).
- All other files are unaffected.

The net change in total cost is $s_b - s_a$. The swap is beneficial when $s_b - s_a < 0$, i.e., $s_b < s_a$. So whenever a larger file precedes a smaller one, swapping them strictly decreases the total cost. The unique ordering with no such inversion is non-decreasing by file size. 

## Algorithm

```julia
function min_tape_cost(sizes)
    sort!(sizes)
    n = length(sizes)
    total = 0
    for (j, s) in enumerate(sizes)
        total += (n - j + 1) * s
    end
    return total
end
```

**Time complexity:** $O(n \log n)$ dominated by sorting.

---

<div class="sectionlecturebox">Storing Files on Tape: Files with Access Probabilities</div>

## Problem

Each file $i$ now has a size $s_i$ and an access probability $p_i > 0$, where $\sum_{i=1}^{n} p_i = 1$. The **expected retrieval cost** is:

$$C(\sigma) = \sum_{j=1}^{n} p_{\sigma(j)} \cdot \sum_{k=1}^{j} s_{\sigma(k)}$$

**Goal:** find the ordering $\sigma$ minimizing $C(\sigma)$.

**Example.** Two files: $(s_1, p_1) = (10, 0.1)$ and $(s_2, p_2) = (1, 0.9)$.

- Order $[1, 2]$: $C = 0.1 \cdot 10 + 0.9 \cdot (10 + 1) = 1 + 9.9 = 10.9$.
- Order $[2, 1]$: $C = 0.9 \cdot 1 + 0.1 \cdot (1 + 10) = 0.9 + 1.1 = 2.0$.

Even though file 1 is larger, file 2 should go first because it is accessed much more frequently.

## Greedy Solution

**Claim.** Sort files in **increasing order of $s_i / p_i$** (size-to-probability ratio).

## Proof of Optimality (Exchange Argument)

Consider two adjacent files $a = \sigma(j)$ and $b = \sigma(j+1)$. Let $P$ be the cumulative size of all files before position $j$ (the same in both orderings). Their combined contribution to $C(\sigma)$ is:

$$C_{\text{before}} = p_a(P + s_a) + p_b(P + s_a + s_b) = (p_a + p_b)P + p_a s_a + p_b s_a + p_b s_b$$

After swapping ($b$ before $a$):

$$C_{\text{after}} = p_b(P + s_b) + p_a(P + s_b + s_a) = (p_a + p_b)P + p_b s_b + p_a s_b + p_a s_a$$

The difference:

$$C_{\text{before}} - C_{\text{after}} = p_b s_a - p_a s_b$$

Swapping is beneficial when $C_{\text{before}} > C_{\text{after}}$, i.e., when $p_b s_a > p_a s_b$, or equivalently:

$$\frac{s_a}{p_a} > \frac{s_b}{p_b}$$

So if file $a$ has a larger ratio than file $b$, we should move $b$ first. The optimal ordering is therefore **non-decreasing by $s_i / p_i$**. 

**Another proof.** Consider swapping two adjacent files $a$ (at position $j$) and $b$ (at position $j+1$). After the swap:

- The cost to read $a$ **increases** by $s_b$, contributing $+p_a s_b$ to the total expected cost.
- The cost to read $b$ **decreases** by $s_a$, contributing $-p_b s_a$ to the total expected cost.
- All other files are unaffected.

The net change in total expected cost is $p_a s_b - p_b s_a$. The swap is beneficial when $p_a s_b - p_b s_a < 0$, i.e., $p_b s_a > p_a s_b$, or equivalently $s_a / p_a > s_b / p_b$. So whenever a file with a larger $s/p$ ratio precedes one with a smaller ratio, swapping them strictly decreases the cost. The unique ordering with no such inversion is non-decreasing by $s_i / p_i$. 

## Algorithm

```julia
function min_tape_cost_weighted(files)
    # files is a vector of (size, probability) pairs, probabilities sum to 1
    sort!(files, by = x -> x[1] / x[2])
    total = 0.0
    prefix = 0
    for (s, p) in files
        prefix += s
        total += p * prefix
    end
    return total
end
```

**Time complexity:** $O(n \log n)$ for sorting.
