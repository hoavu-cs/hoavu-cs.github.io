---
title: Divide and Conquer Part 2 (Majority Element, Strassen's Algorithm)
parent: DSA
nav_order: 3
layout: default
permalink: /dsa/divide-and-conquer-2/
---

# Divide and Conquer Part 2 (Majority Element, Strassen's Algorithm)

<div class="sectionlecturebox">
Finding the Majority
</div>

Consider an array $A[1:n]$ of elements that are not necessarily numbers. We assume that we can compare any two elements to determine whether they are equal.

An element is called a **majority element** if it occurs **strictly more than $n/2$ times** in $A$; our goal is to return the majority element if one exists.
A naive algorithm is the following: for each element $A[i]$, scan through the entire array and count how many times it appears. If any element appears more than $n/2$ times, return it. This approach is correct but runs in $O(n^2)$ time.

---

### A Divide-and-Conquer Algorithm

**Claim:** Let $L, R$ be a partition of $A$. If $A$ has a majority element, then that element must be the majority of **either $L$ or $R$**.

**Proof.**  
Suppose $A$ has a majority element $z$, but $z$ is neither the majority of $L$ nor the majority of $R$.

$$
\text{count}(z, L) + \text{count}(z, R) \leq \frac{|L|}{2} + \frac{|R|}{2} = \frac{n}{2},
$$

which contradicts the assumption that $z$ is the majority element of $A$. Hence, $z$ must be the majority of either $L$ or $R$. $\square$

---

We recursively find the majority elements of the left half $L$ and right half $R$, denoted by $x$ and $y$, respectively. Finally, we check whether $x$ or $y$ is the majority element of $A$ by counting their occurrences in $A$. If either $x$ or $y$ appears more than $n/2$ times, we return that element. Otherwise, we conclude that $A$ has no majority element.

```julia
function majority(A)
    n = length(A)
    if n == 0
        return nothing  # no majority
    elseif n == 1
        return A[1]
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

We can do better by reducing the problem size more aggressively. The key idea is to pair up elements and discard pairs that contain different elements, since at most one of them can be the majority element. Let us try something like this.
Suppose $A = [a,b,a,a,c,c,a,a]$. We can pair up every two elements. If the two elements are equal, we keep one copy in $B$; if they are different, we discard both. In this case, we get pairs $(a,b)$, $(a,a)$, $(c,c)$, and $(a,a)$. The resulting array is $B = [a, c, a]$. We observe that if $a$ is the majority element of $A$, then it must also be the majority element of $B$.

The converse is not necessarily true: for example $A=[a,a,b,c,c,d]$ gives $B=[a]$, where $a$ is the majority of $B$ but not of $A$.

To see why this is the case, let $m$ be the majority element of $A$. Consider the pairs formed from $A$:

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

Below is the description of the algorithm given this idea.

1. **Handle the odd-length case.**

   If $n$ is odd, check whether $A[1]$ is the majority element by counting its occurrences in $A$. If it occurs more than $\frac{n}{2}$ times, return $A[1]$. Otherwise, discard $A[1]$. Since it is not the majority, removing it does **not** change whether a majority exists.
   This counting step takes $O(n)$ time. After discarding $A[1]$, the array has even length.

   We note that if we discard $A[1]$, if $A$ has a majority element, it remains the majority element in the reduced array. Some non-majority element may become the majority after discarding $A[1]$, but we will verify the candidate at the end so this is not a problem.

2. **Pair up elements and build a reduced array $B$.**

   Now assume $n$ is even. Pair up elements as:
   $$
   (A[1], A[2]),\ (A[3], A[4]),\ \ldots,\ (A[n-1], A[n]).
   $$
   For each pair: If the two elements are equal, keep **one** copy in a new array $B$. If the two elements are different, discard both.

3. **Recurse on $B$.**

   Recursively compute
   $$
   m \leftarrow \texttt{majority}(B).
   $$
   If the recursive call returns “no-majority,” then return “no-majority” for $A$ as well.

4. **Verify the candidate in the original array.**

   Count the number of occurrences of $m$ in the original array $A$ (before we discarded $A[1]$ if $n$ was odd).  If $m$ appears more than $\frac{n}{2}$ times, return $m$. Otherwise, return “no-majority.”

Since the pairing and verification steps take $O(n)$ time, and the recursive call is on an array of size at most $\frac{n}{2}$, the recurrence is
$$
T(n) = T\!\left(\frac{n}{2}\right) + O(n),
$$
which solves to $T(n) = O(n)$.

---

The algorithm's Julia implementation is as follows:

```julia
function majority_fast(A)
    n = length(A)
    if n == 0
        return nothing  # no majority
    elseif n == 1
        return A[1]
    end

    # take care of the case A has an odd number of elements
    C = nothing
    if n % 2 == 1
        count = sum(1 for a in A if a == A[1])
        if count > n/2
            return A[1]
        end

        C = @view A[2:end]
    else
        C = A
    end

    k = length(C)
    
    B = Vector{eltype(A)}() # reduced array B 
    for i in 1:2:k
        if C[i] == C[i+1]
            push!(B, C[i])
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

---

<div class="sectionlecturebox">
Strassen's Algorithm for Matrix Multiplication
</div>

Given two $n \times n$ matrices $X$ and $Y$. The $(i,j)$ entry (where $i,j \in \{1,\ldots,n\}$) of the product matrix $Z = XY$ is defined as

$$
Z_{ij} =\sum_{k=1}^n X_{ik} Y_{kj}.
$$

In other words, $Z_{ij}$ is computed by taking the dot product of the $i$-th row of $X$ with the $j$-th column of $Y$. For simplicity, we will assume that $n$ is a power of 2; otherwise, we can pad the matrices with zeros to the next power of 2.

What is the running time of the naive algorithm which computes each entry of $C$ using the above formula? There are $n^2$ entries to compute, each of which takes $O(n)$ time. Hence, the running time is $O(n^3)$.

We now describe a more clever algorithm by Strassen. The first observation (which is not hard to prove but we will just assume) is that matrix multiplication can be done blockwise.

$$
\begin{bmatrix}
A & B\\
C & D
\end{bmatrix}  \cdot
\begin{bmatrix}
E & F\\
G & H
\end{bmatrix} =
\begin{bmatrix}
AE + BG & AF + BH\\
CE + DG & CF + DH
\end{bmatrix}   
$$

**Exercise** Check that it's true for this example where we use blocks of size 2.

$$
\begin{bmatrix}
1 & 2 & 3 & 2\\
5 & 2 & 1 & 0 \\
1 & 1 & 1 & 0 \\
2 & 3 & 5 & 7
\end{bmatrix}  \cdot
\begin{bmatrix}
1 & 0 & 0 & 1\\
1 & 1 & 2 & 1 \\
1 & 2 & 3 & 4 \\
5 & 6 & 7 & 8
\end{bmatrix} = \ldots
$$

Let $T(n)$ be the time to multiply two $n \times n$ matrices. Note that $T(n) \geq \Omega(n^2)$ because just reading the input takes $\Omega(n^2)$ time. The above approach yields the following recurrence:

$$ T(n)=8T(n/2) + O(n^2). $$

This is because:

- We need to compute 8 different $(n/2) \times (n/2)$ matrix multiplications.
- Adding them up (e.g., $AE + BG$) takes $O(n^2)$ time.

Applying the Master theorem, this gives us $O(n^3)$, which is not any better than the naive algorithm.

Strassen's insight is that we can reduce the number of $(n/2) \times (n/2)$ matrix multiplications from 8 to 7 by doing some clever additions and subtractions.

- $P_1 = A(F-H)$.
- $P_2 = (A+B)H$.
- $P_3 = (C+D)E$.
- $P_4 = D(G-E)$.
- $P_5 = (A+D)(E+H)$.
- $P_6 = (B-D)(G+H)$.
- $P_7 = (A-C)(E+F)$.

To compute $P_1$, we observe that $F-H$ can be computed in $O(n^2)$ time since we need to do $(n/2)^2 = O(n^2)$ subtractions. So, $P_1 = A(F-H)$ can be computed in $T(n/2) + O(n^2) = T(n/2)$ time. Other $P_i$'s can be computed similarly.

Recall that the output matrix looks like this:

$$
\begin{bmatrix}
AE + BG & AF + BH\\
CE + DG & CF + DH
\end{bmatrix}   
$$

Now, compute the following blocks using $P_1, \ldots, P_7$:

- $AE+BG = P_5+ P_4 - P_2 + P_6$.
- $AF + BH = P_1 + P_2$.
- $CE + DG = P_3 + P_4$.
- $CF + DH = P_1 + P_5 - P_3 - P_7$.

Alright, the new recurrence is:

$$
T(n) = {7T(n/2)} + {O(n^2)}.
$$

By the Master theorem, this leads to $T(n) = O(n^{\log_2 7} ) \approx O(n^{2.81})$.

## Julia Implementation

Here is a Julia implementation of Strassen's algorithm for matrix multiplication. In practice, this algorithm is not preferred due to its large constant factors and numerical instability, and there are better algorithms for sparse matrices. However, it is a beautiful example of how divide-and-conquer can be used to achieve a better asymptotic running time. The topic of fast matrix multiplication is still an active area of research, and the current best algorithm runs in $O(n^{2.3728596})$ time (as of 2024).

```julia
"""
    Strassen's Matrix Multiplication
    Assumes square matrices of size n x n where n is a power of 2.
    If not, pad with zeros to the next power of 2.

"""
function strassen(A::AbstractMatrix, B::AbstractMatrix)
    n = size(A, 1) 
    # Base case: switch to standard multiplication
    if n <= 32 
        return A * B
    end
    
    mid = n ÷ 2
    # Use views to avoid copies during splitting
    A11, A12 = @view(A[1:mid, 1:mid]), @view(A[1:mid, mid+1:end])
    A21, A22 = @view(A[mid+1:end, 1:mid]), @view(A[mid+1:end, mid+1:end])
    
    B11, B12 = @view(B[1:mid, 1:mid]), @view(B[1:mid, mid+1:end])
    B21, B22 = @view(B[mid+1:end, 1:mid]), @view(B[mid+1:end, mid+1:end])
    
    # Strassen's 7 Products
    P1 = strassen(A11, B12 - B22)
    P2 = strassen(A11 + A12, B22)
    P3 = strassen(A21 + A22, B11)
    P4 = strassen(A22, B21 - B11)
    P5 = strassen(A11 + A22, B11 + B22)
    P6 = strassen(A12 - A22, B21 + B22)
    P7 = strassen(A11 - A21, B11 + B12)
    
    # Result quadrants
    C = Matrix{eltype(A)}(undef, n, n)
    C[1:mid, 1:mid] .= P5 + P4 - P2 + P6
    C[1:mid, mid+1:end] .= P1 + P2
    C[mid+1:end, 1:mid] .= P3 + P4
    C[mid+1:end, mid+1:end] .= P1 + P5 - P3 - P7
    
    return C
end
```
