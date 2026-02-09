---
title: Divide and Conquer Part 3 (Karatsuba's Algorithm, Linear Time Selection)
parent: DSA
nav_order: 4
layout: default
permalink: /dsa/divide-and-conquer-3/
---

# Divide and Conquer Part 3 (Karatsuba's Algorithm, Linear Time Selection)

<div class="sectionlecturebox">
Karatsuba's Algorithm for Integer Multiplication
</div>

Consider multiplying two $n$-digit integers $x$ and $y$. Typically, if $x$ and $y$ are 32-bit or 64-bit integers, we can multiply them in constant time using built-in hardware instructions since most CPU architectures support fixed-size integer arithmetic.

However, for very large integers (e.g., with millions of digits), the running time of multiplication becomes significant. The grade-school algorithm for multiplying two $n$-digit numbers runs in $O(n^2)$ time. Can we do better?


We represent integers in binary. Split each $n$-bit number into two halves of $x_1$ and $x_0$ with $m = \lfloor n/2 \rfloor$ bits for $x_1$ and $n - m$ bits for $x_0$. Similarly for $y$. Then we can write

$$
x = x_1 \cdot 2^{m} + x_0, \quad y = y_1 \cdot 2^{m} + y_0,
$$

where $x_1, x_0, y_1, y_0$ are roughly $n/2$-bit numbers. For example, if $x = 1011_2$ (11 in decimal), then $x_1 = 10_2$  and $x_0 = 11_2$.

Expanding the product directly gives

$$
x \cdot y = x_1 y_1 \cdot 2^{2m} + (x_1 y_0 + x_0 y_1) \cdot 2^{m} + x_0 y_0.
$$

This requires **four** multiplications of $n/2$-bit numbers: $x_1 y_1$, $x_1 y_0$, $x_0 y_1$, and $x_0 y_0$. The additions and shifts (multiplication by $2^m$ is just a left shift) take $O(n)$ time. The recurrence is

$$
T(n) = 4T(n/2) + O(n),
$$

which by the Master theorem gives $T(n) = O(n^2)$. No improvement over the naive method.


### Karatsuba's Trick


Karatsuba's key observation is that the middle coefficient $x_1 y_0 + x_0 y_1$ can be obtained using only **one** additional multiplication instead of two. Define

$$
P_1 = x_1 y_1, \quad P_2 = x_0 y_0, \quad P_3 = (x_1 + x_0)(y_1 + y_0).
$$

Then

$$
x_1 y_0 + x_0 y_1 = P_3 - P_1 - P_2,
$$

since $(x_1 + x_0)(y_1 + y_0) = x_1 y_1 + x_1 y_0 + x_0 y_1 + x_0 y_0$. Therefore,

$$
x \cdot y = P_1 \cdot 2^{2m} + (P_3 - P_1 - P_2) \cdot 2^{m} + P_2.
$$

We now only need **three** multiplications of roughly $n/2$-bit numbers ($P_1, P_2, P_3$), plus $O(n)$ work for additions and shifts. The recurrence becomes

$$
T(n) = 3T(n/2) + O(n).
$$

By the Master theorem ($a = 3$, $b = 2$, $d = 1$; since $\log_2 3 \approx 1.585 > 1$), we get

$$
\boxed{T(n) = O(n^{\log_2 3}) \approx O(n^{1.585})}.
$$

This is a significant improvement over $O(n^2)$ for large $n$.

**Exercise:** Verify that $P_3 - P_1 - P_2 = x_1 y_0 + x_0 y_1$ by expanding $P_3$.

### Julia Implementation

```julia
function karatsuba(x::BigInt, y::BigInt)
    # Base case: use built-in multiplication for small numbers
    if x < 4 || y < 4
        return x * y
    end

    n = max(ndigits(x, base=2), ndigits(y, base=2))
    m = n ÷ 2

    # Split x = x1 * 2^m + x0, y = y1 * 2^m + y0
    x1, x0 = x >> m, x & ((BigInt(1) << m) - 1)
    y1, y0 = y >> m, y & ((BigInt(1) << m) - 1)

    # Three recursive multiplications
    P1 = karatsuba(x1, y1)
    P2 = karatsuba(x0, y0)
    P3 = karatsuba(x1 + x0, y1 + y0)

    return (P1 << 2m) + ((P3 - P1 - P2) << m) + P2
end
```

<div class="sectionlecturebox">
Linear Time Selection
</div>

Given an unsorted array $A[1:n]$ and an integer $k$ ($1 \le k \le n$), the **selection problem** asks to find the $k$-th smallest element in $A$. For example, the $1$-st smallest is the minimum, the $n$-th smallest is the maximum, and the $\lceil n/2 \rceil$-th smallest is the median.

A simple approach is to sort $A$ in $O(n \log n)$ time and return $A[k]$. Can we do better?

### Quickselect

The idea behind quickselect is similar to quicksort. Pick a **pivot** element $p$ from $A$ and partition $A$ into three groups:

- $L$: elements less than $p$.
- $E$: elements equal to $p$.
- $G$: elements greater than $p$.

We have three cases: if $k \le \lvert L \rvert$, then the $k$-th smallest is in $L$; if $k \le \lvert L \rvert + \lvert E \rvert$, then the $k$-th smallest is $p$; otherwise, it is in $G$ and we need to find the $(k - \lvert L \rvert - \lvert E \rvert)$-th smallest in $G$. This gives the following recursive algorithm:


```julia
function quickselect(A, k)
    n = length(A)
    if n == 1
        return A[1]
    end

    p = A[rand(1:n)]  # random pivot

    L = [a for a in A if a < p]
    E = [a for a in A if a == p]
    G = [a for a in A if a > p]

    if k ≤ length(L)
        return quickselect(L, k)
    elseif k ≤ length(L) + length(E)
        return p
    else
        return quickselect(G, k - length(L) - length(E))
    end
end
```


With a random pivot, quickselect runs in $O(n)$ time in expectation. To see this, note that the pivot is equally likely to be any of the $n$ elements. With probability $1/2$, the pivot is between the $n/4$-th and $3n/4$-th smallest elements, which means that both $L$ and $G$ have at most $3n/4$ elements. Thus, in expectation, the recursive call is on an array of size at most $3n/4$, giving the recurrence

$$
T(n) = T(3n/4) + O(n),
$$
which solves to $T(n) = O(n)$.


### Median of Medians

The **median-of-medians** algorithm (also known as BFPRT, after Blum, Floyd, Pratt, Rivest, and Tarjan) selects a pivot that guarantees a good split every time. The algorithm proceeds as follows:

1. **Divide** $A$ into groups of 5. If the number of elements is not a multiple of 5, pad a few $\infty$'s to the last group.
2. **Find the median** of each group (by brute force, since each group has at most 5 elements).
3. **Recursively find the median** of these $\lceil n/5 \rceil$ medians. Call this $p$.
4. **Use $p$ as the pivot** to partition $A$ into $L$, $E$, $G$ and recurse as in quickselect.


### Analysis

<div class="lecturebox">
<b>Claim:</b> At least $\frac{3n}{10} - 6$ elements are less than $p$, and at least $\frac{3n}{10} - 6$ elements are greater than $p$.
</div>

**Proof sketch.** There are $\lceil n/5 \rceil$ groups, so there are $\lceil n/5 \rceil$ medians. The pivot $p$ is the median of these medians, so at least half of the medians are $\le p$. For each such median, at least 3 out of 5 elements in its group are $\le p$ (the median itself and the two elements smaller than it). This gives at least

$$
3 \left\lfloor \frac{1}{2} \left\lceil \frac{n}{5} \right\rceil \right\rfloor \approx \frac{3n}{10} 
$$

elements that are $\le p$. By a symmetric argument, at least $\frac{3n}{10}$ elements are $\ge p$. $\square$

This means the recursive call (step 4) is on an array of size at most

$$
\approx  \frac{7n}{10}.
$$

The recurrence for the running time is therefore

$$
T(n) = T\!\left(\frac{n}{5}\right) + T\!\left(\frac{7n}{10} \right) + O(n).
$$

- $T(n/5)$: finding the median of the medians (step 3).
- $T(7n/10)$: the recursive selection on $L$ or $G$ (step 4).
- $O(n)$: partitioning and finding medians of groups of 5 (steps 1, 2, and the partition).

<div class="lecturebox">
<b>Claim:</b> $T(n) = O(n)$.
</div>

**Proof.** Let us draw the recursion tree. 
```
                                   T(n)
                      ┌─────────────┴─────────────┐
                   T(n/5)                      T(7n/10)
             ┌────────┴────────┐           ┌────────┴────────┐
          T(n/25)          T(7n/50)     T(7n/50)         T(49n/100)
          ...             ...             ...                ...

```
Let $c$ be some large enough constant. Note that the work done at the 0th recursion level is $cn$, the work done at the 1st recursion level is $c(n/5) + c(7n/10) = c(9n/10)$, the work done at the 2nd recursion level is $c(n/25) + c(7n/50) + c(7n/50) + c(49n/100) = c(81n/100) = c(9/10)^2 n$, and so on. 

Therefore, the running time is bounded by

$$
\text{running time} \le cn + c\left(\frac{9}{10}\right)n + c\left(\frac{9}{10}\right)^2 n + \cdots = cn \sum_{i=0}^{\infty} \left(\frac{9}{10}\right)^i = 10cn = O(n).
$$



**Exercise:** What happens if we use groups of 3 or 7 instead of 5? Write out the recurrence and determine whether the algorithm still runs in $O(n)$ time.


### Julia Implementation

```julia
function median_of_medians(A, k)
    n = length(A)
    if n ≤ 5
        return sort(A)[k]
    end

    # Step 1-2: Divide into groups of 5 and find each group's median
    medians = [sort(A[i:min(i+4, n)])[div(min(i+4, n) - i, 2) + 1]
               for i in 1:5:n]

    # Step 3: Recursively find the median of medians
    p = median_of_medians(medians, (length(medians) + 1) ÷ 2)

    # Step 4: Partition and recurse
    L = [a for a in A if a < p]
    E = [a for a in A if a == p]
    G = [a for a in A if a > p]

    if k ≤ length(L)
        return median_of_medians(L, k)
    elseif k ≤ length(L) + length(E)
        return p
    else
        return median_of_medians(G, k - length(L) - length(E))
    end
end
```