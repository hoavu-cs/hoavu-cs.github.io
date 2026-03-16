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

**Example.** Three files with sizes $[1, 2, 3]$. Two orderings:

- Order $[1, 2, 3]$ (i.e., $\sigma(1) = 1, \sigma(2) = 2, \sigma(3) = 3$): retrieval costs are $1,\ 1+2,\ 1+2+3$, total $= 1 + 3 + 6 = 10$.
- Order $[3, 2, 1]$ (i.e., $\sigma(1) = 3, \sigma(2) = 2, \sigma(3) = 1$): retrieval costs are $3,\ 3+2,\ 3+2+1$, total $= 3 + 5 + 6 = 14$.

As we see, the ordering matters in terms of the total retrieval cost. The objective is to find one that minimizes the cost. Assuming each file is equally likely to be requested, the **total retrieval cost** is:

$$C(\sigma) = \sum_{j=1}^{n} \sum_{k=1}^{j} s_{\sigma(k)} = \sum_{j=1}^{n} (n - j + 1) \cdot s_{\sigma(j)}$$

The second equality follows from counting how many times each file's size contributes to the total cost: file $\sigma(j)$ contributes to the cost of itself and all files that come after it, which is $n - j + 1$ times.

**Goal:** Find a permutation $\sigma$ that minimizes $C(\sigma)$. 




## Greedy Solution

**Claim.** Sorting files in **non-decreasing order of size** (smallest first) gives the optimal ordering.

**Intuition:** A small file placed early contributes its size to the cost of every subsequent retrieval. Placing larger files later reduces how often their large sizes are counted.

## Proof of Optimality (Exchange Argument)

Suppose an optimal ordering $\sigma$ has two adjacent files $\sigma(j) = a$ and $\sigma(j+1) = b$ with $s_a > s_b$ (a larger file appears before a smaller one). We show swapping them lowers the total cost. 

```
s_1, s_2, ..., s_{j-1}, s_a, s_b, s_{j+2}, ..., s_n
# swap a and b
s_1, s_2, ..., s_{j-1}, s_b, s_a, s_{j+2}, ..., s_n
```

Consider swapping two adjacent files $a$ (at position $j$) and $b$ (at position $j+1$). After the swap:

- The cost to read $a$ **increases** by $s_b$ (since $b$ now precedes $a$).
- The cost to read $b$ **decreases** by $s_a$ (since $b$ no longer has to skip over $a$).
- All other files are unaffected.

The net change in total cost is $s_b - s_a$. The swap is beneficial when $s_b - s_a < 0$, i.e., $s_b < s_a$. This leads to a contradiction since we assumed $\sigma$ is optimal, but swapping $a$ and $b$ would yield a lower cost. Hence, in the optimal ordering, there cannot be an adjacent pair of files where the larger file comes before the smaller one. Therefore, the optimal ordering is non-decreasing by size. The running time is simply $O(n \log n)$ dominated by sorting.

---

<div class="sectionlecturebox">Storing Files on Tape: Files with Access Probabilities</div>

## Problem

Each file $i$ now has a size $s_i$ and an access probability $p_i > 0$, where $\sum_{i=1}^{n} p_i = 1$. The **expected retrieval cost** is:

$$C(\sigma) = \sum_{j=1}^{n} p_{\sigma(j)} \cdot \sum_{k=1}^{j} s_{\sigma(k)}$$

That is, the cost to retrieve file $\sigma(j)$ is weighted by its access probability $p_{\sigma(j)}$.
Again, the goal is to find the ordering $\sigma$ minimizing $C(\sigma)$.

**Example.** Two files: $(s_1, p_1) = (10, 0.1)$ and $(s_2, p_2) = (1, 0.9)$.

- Order $[1, 2]$: $C = 0.1 \cdot 10 + 0.9 \cdot (10 + 1) = 1 + 9.9 = 10.9$.
- Order $[2, 1]$: $C = 0.9 \cdot 1 + 0.1 \cdot (1 + 10) = 0.9 + 1.1 = 2.0$.

Even though file 1 is larger, file 2 should go first because it is accessed much more frequently.

## Greedy Solution

**Claim.** Sorting files in **non-decreasing order of $s_i / p_i$** (size-to-probability ratio) gives the optimal ordering.

## Proof of Optimality (Exchange Argument)

Suppose in an optimal ordering, there are files $a = \sigma(j)$ and $b = \sigma(j+1)$ such that $s_a / p_a > s_b / p_b$. We show swapping them lowers the expected cost.
 Consider swapping two adjacent files $a$ (at position $j$) and $b$ (at position $j+1$). 

First, note that
$$
\frac{s_a}{p_a} > \frac{s_b}{p_b} \implies p_b s_a > p_a s_b \implies p_a s_b - p_b s_a < 0.
$$
 
 
 After the swap:

- The cost to read $a$ now **increases** by $s_b$, contributing $+p_a s_b$ to the total expected cost.
- The cost to read $b$ now **decreases** by $s_a$, contributing $-p_b s_a$ to the total expected cost.
- All other files are unaffected.

The net change in total expected cost is $p_a s_b - p_b s_a < 0$.  This leads to a contradiction since we assumed $\sigma$ is optimal. Hence, sorting by non-decreasing $s_i / p_i$ is optimal. The running time is again $O(n \log n)$ dominated by sorting.
