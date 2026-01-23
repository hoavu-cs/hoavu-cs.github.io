---
title: Divide and Conquer Part 1
parent: DSA
nav_order: 2
layout: default
permalink: /dsa/divide-and-conquer-1/
---

# Divide and Conquer Part 1

## Introduction

Divide-and-conquer is a powerful algorithmic paradigm. The main ideas behind divide-and-conquer algorithms are as follows.

* Suppose we have a problem of size $n$. We break it into one or more sub-problems of size smaller than $n$ and solve them recursively.
* Combine the solutions of the sub-problems to solve the original problem.
* When $n$ is small enough (e.g., $\le 1$ or $\le 10$), the problem can be solved directly (base case).

## A Puzzle

Consider a $2^n$ by $2^n$ ($n \ge 1$) chessboard with one missing square. The task is to tile this board with L-shaped dominoes (2 by 2 with one square removed) such that no two dominoes overlap and no domino goes out of the board's boundary. See the figure below for an example.

<p align="center">
  <img src="/dsa/assets/tiling.png" width="400">
</p>


How do we go about solving this problem? One approach is to start with the simplest case that is 2-by-2. This case is trivial since we can orient the domino to avoid the missing square.

Consider the 4-by-4 case. Pause for a while and think about how you would reduce this to the trivial 2-by-2 case.

You can divide the board into four quadrants of size 2-by-2. One of these quadrants has a missing square and you know how to tile it. How about the other three? You can put an L-shaped tile in the center such that it overlaps the other three quadrants. Now, you are left with tiling four 2-by-2 quadrants, each of which has one missing square. Thus, we know how to do this for all 4-by-4 cases.

Can you generalize this to 8-by-8, 16-by-16, and so on?


## Binary Search

Let us consider the binary search algorithm. The input is a **sorted** array of numbers $A[1\ldots n]$ where $A[1] \le A[2] \le \ldots \le A[n]$ and a number $x$. We want to output true if $x$ is in $A$ and false otherwise.

The idea is simple: Look at the middle index $m = \lfloor n/2 \rfloor$.  If $x \le A[m]$, then if $x \in A$, it must be in the left half $A[1 \ldots m]$. Otherwise, if it is in $A$, it must be in the right half $A[m+1 \ldots n]$. So we can recursively search either the left half or the right half accordingly. Note that the size of the new sub-problem is now half of the size of the original problem, i.e., $n/2$ vs $n$.

```julia
function binary_search(A, x, i, j)
    # Check if x is in A[i...j]
    if i == j
        # Base case
        return A[i] == x
    else
        m = floor(Int, (i + j) / 2)
        if x <= A[m]
            return binary_search(A, x, i, m)
        else
            return binary_search(A, x, m+1, j)
        end
    end
end

# Initial call
binary_search(A, x, 1, length(A))
```

What is the running time? 

* We start with a search range of size $n$. The search range shrinks by half after each recursion level.
* In each recursion level, there is a constant (i.e., $O(1)$) amount of non-recursive work.
* The search range at recursion level $i$ is $n/2^i$. Solve for $n/2^i = 1$ gives $i = \log_2 n$.
* The running time is therefore $(\text{\# recursion levels}) \times (\text{non-recursive work per level}) = O(\log n) \times O(1) = O(\log n)$.

Often, binary search is implemented iteratively as it is simpler.

```julia
# Return the index of x in A if found, otherwise return -1
function binary_search(A, x)
    i, j = 1, length(A)
    while i < j
        m = floor(Int, (i + j) / 2)
        if x <= A[m]
            j = m
        else
            i = m + 1
        end
    end
    return (i <= length(A) && A[i] == x) ? i : -1
end
```

## Merge Sort

We now look at merge sort which runs in $O(n \log n)$ time. Recall that selection sort runs in $O(n^2)$ time so this is a significant improvement. First, let us look at the merge procedure that merges two sorted arrays $A$ and $B$.

```julia
function merge(A::AbstractVector{T}, B::AbstractVector{T}) where {T<:AbstractFloat}
    n, m = length(A), length(B)
    C = Vector{T}(undef, n + m)

    # Appending infinity to avoid checking boundary conditions
    A_sent = vcat(A, T(Inf))
    B_sent = vcat(B, T(Inf))

    j1 = j2 = 1
    for j in 1:(n + m)
        if A_sent[j1] <= B_sent[j2]
            C[j] = A_sent[j1]; j1 += 1
        else
            C[j] = B_sent[j2]; j2 += 1
        end
    end
    return C
end

```

The merge procedure above is correct because in each iteration, the smallest element among $A[j_1 \ldots n]$ and $B[j_2 \ldots m]$ will be appended to the end of $C$.

The running time is $O(n+m)$ because in each iteration, we increment $j_1$ or $j_2$ by 1 and we stop when $j_1=n$ and $j_2 =m$ and the running time per iteration is $O(1)$.

Now, we are ready to describe the divide-and-conquer merge sort. Suppose we want to sort $A[1 \ldots n]$. The idea is that we recursively sort $A[1 \ldots \lfloor n/2 \rfloor]$ and  $A[\lfloor n/2 \rfloor+1 \ldots n]$ separately and then merge them.

```julia
function merge_sort(A)
    n = length(A)
    if n <= 1
        return A
    else
        mid = floor(Int, n/2)
        L = merge_sort(A[1:mid])
        R = merge_sort(A[mid+1:end])
        C = merge(L, R)
        return C
    end
end
```

The correctness is pretty clear. After recursion, $L$ and $R$ are sorted left and right halves. We merge them to get the sorted array.

Define $T(n)$ as the running time of merge sort on an array of size $n$. Each recursion level does $O(n)$ non-recursive work and calls two sub-problem of half the size. Hence,
$$
T(n) = 2T(n/2) + O(n).
$$

We will show that $T(n)=O(n \log n)$. In fact, $T(n) = \Theta(n \log n)$ is a tighter statement. 

## Solving recurrences

### Recursion tree

A common way to solve recurrences is to use recursion trees. The idea is to draw a tree where each node corresponds to a call to the function. The running time is the total amount of non-recursive work in the tree.

**Example 1: Each level does the same amount of non-recursive work.** For example, consider the formula for merge sort: $T(n) = 2T(n/2) + O(n) \le 2T(n/2) + cn$ for some constant $c$. The non-recursive work for a node of size $n$ is $\le cn$.

```
                          n
                          |
              -----------------------------
              |                           |
             n/2                         n/2
              |                           |
        ---------------             ---------------
        |             |             |             |
       n/4           n/4           n/4           n/4
        |             |             |             |
     --------       --------      --------       --------
     |      |       |      |      |      |       |      |
    n/8    n/8     n/8    n/8     n/8    n/8     n/8    n/8
               ...

```

- **At the 0th level**, the amount of non-recursive work is

$$
c n.
$$

- **At the 1st level**, there are two subproblems of size $\frac{n}{2}$, each doing

$$
c\left(\frac{n}{2}\right)
$$

work.  
Thus, the total work at this level is

$$
2 \cdot c\left(\frac{n}{2}\right) = c n.
$$

- **At the 2nd level**, there are four subproblems of size $\frac{n}{4}$, each doing

$$
c\left(\frac{n}{4}\right)
$$

work.  
Hence, the total work at this level is

$$
4 \cdot c\left(\frac{n}{4}\right) = c n.
$$

- ...

At every level of the recursion tree, the total amount of non-recursive work is

$$
c n.
$$

There are at most $O(\log_2 n)$ levels until the recursion reaches the base case. Therefore, the total running time is

$$
\boxed{O(n \log n)}.
$$

This is an example where **each level performs the same amount of non-recursive work**, and the logarithmic depth of the recursion determines the overall running time.


**Example 2: The non-recursive work done at each level decreases exponentially.** For example, $T(n) = T(n/10) + T(n/5) + O(n^2)$.

```
                              n
                              |
              ---------------------------------
              |                               |
            n/10                            n/5
              |                               |
        ----------------               ----------------
        |              |               |              |
     n/100           n/50           n/50            n/25
        |              |               |              |
    --------        --------        --------        --------
    |      |        |      |        |      |        |      |
 n/1000  n/500   n/500   n/250   n/500   n/250   n/250   n/125
                    ...
```


- **At the 0th level**, the amount of non-recursive work is

$$
c n^2.
$$

- **At the 1st level**, the amount of non-recursive work is

$$
c\left(\left(\frac{n}{10}\right)^2 + \left(\frac{n}{5}\right)^2\right)
= c\left(\frac{1}{100} + \frac{1}{25}\right)n^2
= c\left(\frac{1}{20}\right)n^2.
$$

- **At the 2nd level**, the amount of non-recursive work is

$$
c\left(\left(\frac{n}{100}\right)^2 + \left(\frac{n}{50}\right)^2
+ \left(\frac{n}{50}\right)^2 + \left(\frac{n}{25}\right)^2\right)
= c\left(\frac{1}{400}\right)n^2
= c\left(\frac{1}{20}\right)^2 n^2.
$$

- **\ldots**

The non-recursive work done at level $i$ is

$$
c\left(\frac{1}{20}\right)^i n^2.
$$

Hence, the total running time is at most

$$
\sum_{i=0}^{\log_5 n} c\left(\frac{1}{20}\right)^i n^2
\le \sum_{i=0}^{\infty} c\left(\frac{1}{20}\right)^i n^2
= c n^2 \cdot \frac{1}{1 - \frac{1}{20}}
= \boxed{O(n^2)}.
$$

Here we recall the fact that for $r < 1$,

$$
\sum_{i=0}^{\infty} r^i = \frac{1}{1 - r}.
$$

For example,

$$
1 + \frac{1}{2} + \frac{1}{4} + \frac{1}{8} + \cdots = 2.
$$

Intuitively, the running time is dominated by the work done at the top level, since the work done at each level decreases exponentially.


**Example 3: The non-recursive work done at each level increases exponentially.** This is a slightly more tricky case, but the rule of thumb is that the work done at the deepest level will dominate the work done by all previous level. For example, consider the following recurrence (which comes up in Strassen's algorithm for matrix multiplication that we will cover later):

$$
T(n) = 7 T(n/2) + n^2.
$$

Let us again draw the recursion tree.


```
                                  n
                                  |
        -------------------------------------------------------
        |        |        |        |        |        |        |
      n/2      n/2      n/2      n/2      n/2      n/2      n/2
        |        |        |        |        |        |        |
   --------                     ...                        --------                           
   |      |                                                |       |
 n/4  ... n/4 (7 times)           ....                    n/4 ... n/4 (7 times)
                         ...

```

- **Level 0:**  
  The amount of non-recursive work is  
  $$
  c n^2.
  $$

- **Level 1:**  
  There are $7$ subproblems of size $\frac{n}{2}$, each doing  
  $$
  c\left(\frac{n}{2}\right)^2
  $$
  work.  
  Hence, the total work at this level is
  $$
  7c\left(\frac{n}{2}\right)^2
  = \frac{7}{4} c n^2.
  $$

- **Level 2:**  
  There are $7^2$ subproblems of size $\frac{n}{4}$, each doing  
  $$
  c\left(\frac{n}{4}\right)^2
  $$
  work.  
  Thus, the total work at this level is
  $$
  7^2 c\left(\frac{n}{4}\right)^2
  = \left(\frac{7}{4}\right)^2 c n^2.
  $$

- **Level $i$:**  
  The total work done at level $i$ is
  $$
  \left(\frac{7}{4}\right)^i c n^2.
  $$

The recursion has at most $\log_2 n$ levels. Evaluating the work at the deepest level gives
$$
O\!\left(n^2 \left(\frac{7}{4}\right)^{\log_2 n}\right).
$$

Using the identity $a^{\log_b n} = n^{\log_b a}$, we obtain
$$
O\!\left(n^2 \cdot n^{\log_2 \left(\frac{7}{4}\right)}\right)
= O\!\left(n^{2 + \log_2 \left(\frac{7}{4}\right)}\right).
$$

Numerically,
$$
2 + \log_2\!\left(\frac{7}{4}\right) \approx 2.807,
$$
so the final running time is
$$
\boxed{O\!\left(n^{2.807\ldots}\right)}.
$$


### Master theorem


**Master Theorem:** If the recurrence is in the following form
$$
T(n) = a T(n/b) + O(n^d).
$$
Then,
$$
T(n) = \begin{cases}
    O(n^d) & \text{if $d > \log_b a$} \\
    O(n^d \log n) & \text{if $d = \log_b a$} \\
    O(n^{\log_b} a) & \text{if $d < \log_b a$}.
    \end{cases}
$$


The proof is a formalization of the above examples. Read section 2.2 in the book for a proof.

**Exercise:** Solve the some previous recurrence using Master theorem

* Binary search $T(n) = T(n/2)+O(1)$,
* Merge sort $T(n) = 2T(n/2) +O(n)$,
* Strassen's algorithm (which we will cover later) $T(n) = 7 T(n/2) + O(n^2)$.

However, Master theorem cannot be used to solve something like this $T(n) = T(n/10) + T(n/5) + O(n^2)$ since it is not in the applicable form. We need to rely on recursion tree in these cases.

## Finding the Majority

Consider an array $A[1 \ldots n]$ of elements that are not necessarily numbers. We assume that we can compare any two elements to determine whether they are equal.

An element is called a **majority element** if it occurs **strictly more than $n/2$ times** in $A$. Our goal is to return the majority element if one exists.

---

### Naive Approach

A naive algorithm is the following: for each element $A[i]$, scan through the entire array and count how many times it appears. If any element appears more than $n/2$ times, return it.

This approach is correct but runs in

$$
O(n^2)
$$

time.

---

### A Divide-and-Conquer Algorithm

We now describe a more efficient divide-and-conquer algorithm.

If $A$ has an **odd** number of elements, we first check whether $A[1]$ is the majority element. If so, we return $A[1]$. Otherwise, we remove $A[1]$. Since $A[1]$ is not the majority, removing it does not affect the final answer. After this step, the array has an even number of elements.

Let

$$
L = A[1 \ldots n/2], \qquad R = A[n/2 + 1 \ldots n].
$$

---

**Claim:** If $A$ has a majority element, then that element must be the majority of **either $L$ or $R$**.

**Proof.**  
Suppose $A$ has a majority element $z$, but $z$ is neither the majority of $L$ nor the majority of $R$. Then $z$ occurs at most $n/4$ times in $L$ and at most $n/4$ times in $R$. Therefore, the total number of occurrences of $z$ in $A$ is at most

$$
\frac{n}{4} + \frac{n}{4} = \frac{n}{2},
$$

which contradicts the assumption that $z$ is the majority element of $A$. Hence, $z$ must be the majority of either $L$ or $R$. $\square$

---


We recursively find the majority elements of $L$ and $R$, denoted by $x$ and $y$, respectively. Finally, we check whether $x$ or $y$ is the majority element of $A$ by counting their occurrences in $A$.

If either $x$ or $y$ appears more than $n/2$ times, we return that element. Otherwise, we conclude that $A$ has no majority element.


```julia
function majority(A)
    n = length(A)
    if n == 0
        return nothing  # no majority
    end

    # take care of the case A has an odd number of elements
    if n % 2 == 1
        count = sum(1 for a in A if a == A[1])
        if count > n/2
            return A[1]
        else
            A = A[2:end]
            n = length(A)
        end
    end
    
    L = A[1:div(n,2)]
    R = A[div(n,2)+1:end]
    x = majority(L)
    y = majority(R)
    
    count_x = sum(1 for a in A if a == x)
    count_y = sum(1 for a in A if a == y)
    
    if count_x > n/2
        return x
    elseif count_y > n/2
        return y
    else
        return nothing  # no majority
    end
end
```

The running time is described by the recurrence $T(n) = 2T(n/2) + O(n)$ which is $O(n \log n)$ by the Master theorem.



### An Improved Divide and Conquer Algorithm

Let $A[1 \ldots n]$ be the input array.

1. **Handle the odd-length case (and base case).**

   If $n$ is odd:
   - Check whether $A[1]$ is the majority element by counting its occurrences in $A$.
   - If it occurs more than $\frac{n}{2}$ times, return $A[1]$.
   - Otherwise, discard $A[1]$. Since it is not the majority, removing it does **not** change whether a majority exists.

   This counting step takes $O(n)$ time. After discarding $A[1]$, the array has even length.  
   This also covers the base case $n = 1$.
   If $n = 0$, return “no-majority.”

2. **Pair up elements and build a reduced array $B$.**

   Now assume $n$ is even. Pair up elements as:
   $$
   (A[1], A[2]),\ (A[3], A[4]),\ \ldots,\ (A[n-1], A[n]).
   $$
   For each pair:
   - If the two elements are equal, keep **one** copy in a new array $B$.
   - If the two elements are different, discard both.

   Let $B$ be the resulting array of remaining elements.

3. **Recurse on $B$.**

   Recursively compute
   $$
   m \leftarrow \texttt{majority}(B).
   $$
   If the recursive call returns “no-majority,” then return “no-majority” for $A$ as well.

4. **Verify the candidate in the original array.**

   Count the number of occurrences of $m$ in the original array $A$.  
   - If $m$ appears more than $\frac{n}{2}$ times, return $m$.
   - Otherwise, return “no-majority.”

Since the pairing step scans $A$ once (i.e., $O(n)$ work), and the recursive call is on an array of size at most $\frac{n}{2}$, the recurrence is
$$
T(n) = T\!\left(\frac{n}{2}\right) + O(n),
$$
which solves to $T(n) = O(n)$.

---

**Correctness:** 
Consider the pairs formed from $A$:

- Let $x$ be the number of pairs that contain **two copies of $m$**, i.e., $(m,m)$.
- Let $y$ be the number of pairs that contain **exactly one copy of $m$**.
- Let $t$ be the number of pairs that contain **no copies of $m$**.

Since there are $n$ elements total and each pair contains two elements, the total number of pairs is $n/2$, and we have

$$
x + y + t = \frac{n}{2}.
$$

The total number of occurrences of $m$ in $A$ is

$$
2x + y,
$$

because:
- each of the $x$ pairs $(m,m)$ contributes $2$ occurrences of $m$,
- each of the $y$ pairs with exactly one $m$ contributes $1$ occurrence,
- the $t$ pairs contribute none.

Since $m$ is a majority element of $A$, it occurs **strictly more** than $\frac{n}{2}$ times:

$$
2x + y > \frac{n}{2}.
$$

Subtracting $x + y + t = \frac{n}{2}$ from this inequality, we obtain

$$
(2x + y) - (x + y + t) > 0,
$$

which simplifies to

$$
x > t.
$$


When forming the reduced list $B$:

- Each pair $(m,m)$ contributes **one** copy of $m$, so $m$ appears exactly $x$ times in $B$.
- Each pair with no copy of $m$ contributes **at most one** non-$m$ element to $B$:
  - if the two elements are equal, we keep one copy;
  - if the two elements are different, we discard both.

Therefore, the total size of $B$ satisfies

$$
|B| \le x + t,
$$

with $m$ appearing exactly $x$ times.

Since $x > t$, we have

$$
2x > x + t \ge |B|,
$$

and hence

$$
x > \frac{|B|}{2}.
$$

Thus, $m$ still appears **more than half** the time in $B$, so $m$ is also a majority element of $B$.

Therefore, the algorithm is **correct** and runs in **$O(n)$ time**.

This suggests the following algorithm

```julia
function majority_fast(A)
    n = length(A)
    if n == 0
        return nothing  # no majority
    end
    # take care of the case A has an odd number of elements
    if n % 2 == 1
        count = sum(1 for a in A if a == A[1])
        if count > n/2
            return A[1]
        else
            A = A[2:end]
            n = length(A)
        end
    end
    
    B = []
    for i in 1:2:n
        if A[i] == A[i+1]
            push!(B, A[i])
        end
    end
    
    x = majority_fast(B)
    if x !== nothing
        count_x = sum(1 for a in A if a == x)
        if count_x > n/2
            return x
        end
    end
    return nothing  # no majority
end
```

