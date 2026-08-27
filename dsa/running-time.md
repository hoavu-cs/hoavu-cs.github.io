---
title: Running Time
parent: DSA
nav_order: 1
layout: default
permalink: /dsa/running-time/
---

# Running Time and Asymptotic Notation

Algorithms are the backbone of computer science. Broadly speaking, an algorithm is a precise, unambiguous set of instructions designed to solve a specific problem. Analyzing an algorithm typically involves two main components:

- Proving mathematically that the algorithm is correct.
- Evaluating its efficiency, such as running time and memory usage (algorithmic research also considers other models of computation and resources, including communication cost, privacy, and more).

In many ways, algorithms play a role in computer science similar to that of physics in engineering. They underpin a wide range of practical applications, from efficiently sorting large databases and scheduling tasks to finding the shortest path between two locations on a map.

<div class="sectionlecturebox">
Running Time
</div>

The running time is measured based on the number of basic machine instructions such as memory access and pairwise arithmetic operations. For example, consider the following line of code

```julia
A[i] = A[i] + 1
```

We have memory access operations (accessing `A[i]`) and a pairwise arithmetic operation. For the moment, let us adopt the following view: we approximate the running time by counting the number of instructions executed up to a constant factor.

Let us look at the following example that sorts an array `A[1:n]` of integers in increasing order. The algorithm is called selection sort. The idea is simple, scan through `A[1:n]` to find the smallest element and put it in `A[1]`, then scan through `A[2:n]` to find the smallest element and put it in `A[2]`, and so on.

```julia
function selection_sort!(A)
    n = length(A) # ln 1
    for j in 1:n-1 # ln 2
        min_idx = j # ln 3
        for k in j+1:n # ln 4
             # find the index of the smallest element in A[j...n]
            if A[min_idx] > A[k] # ln 5
                min_idx = k # ln 6
            end
        end
        A[j], A[min_idx] = A[min_idx], A[j]  # ln 7
    end
    return A
end
```

- Lines 1, 2, 3 and 6 each runs $n-1$ times.
- Lines 4, 5, and 6 each runs at most $(n-1) + (n-2) + (n-3) + \ldots + 1$ times.
- Line 7 runs $n-1$ times.

Recall that

$$
1+2+\ldots+n = n(n+1)/2.
$$

The total running time is therefore approximated by

$$
(n-1) + \frac{(n-1)n}{2} + 1 = O(n^2).
$$

We will define the big $O$ notation later. For now, think of this as saying that the running time grows quadratically as the input size $n$ increases.

**Exercise**: What is the running time of the following dummy function in terms of $n$?

```julia
# A dummy function
function dummy_algorithm(n)
    for j in 1:n
        x = 0
        for k in 1:2^j
            y = 1
        end
    end
end
```

Hint: use the geometric series formula below.

$$
\sum_{i=0}^{m} r^i = \frac{r^{m+1} - 1}{r-1}, \text{ for } r \neq 1.
$$

<div class="sectionlecturebox">
Asymptotic Notation
</div>

We often want to measure the growth of the running time as $n$ increases. For example, when $T(n) = n^2/2 + n/2 - 1$, the term $n^2$ dictates the growth in terms of $n$. We often use asymptotic notation to denote the running time to make our life easier. We use the notation $f(n) = O(g(n))$ to say that the growth of $f(n)$ is no more than the growth of $g(n)$.


**Definition**: We say $f(n) = O(g(n))$ if there exist constants $c > 0$ and $n_0$ such that $f(n) \le c \cdot g(n)$ for all $n \geq n_0$.


**Example**: $3n^2 + 5n + 10 = O(n^2)$. We can choose $c = 18$ and $n_0 = 1$. This is because for $n \geq 1$, it holds that

$$
3n^2 + 5n + 10 \leq 3n^2 + 5n^2 + 10 n^2 = 18 n^2.
$$

**Example**: $n^2= O(1.5^n)$. We can choose $c = 1$ and $n_0 = 14$. From $n = 14$ onward, it holds that $n^2 \le 1.5^n$.

![Big-O plot 1](/dsa/assets/running-time/bigO-fig1.png)

One can also use the limit approach to show that $f(n) = O(g(n))$. Specifically, if

$$
\lim_{n \rightarrow \infty} \frac{f(n)}{g(n)} = \textup{constant}  < \infty
$$

**Example**: See that

$$
\lim_{n \rightarrow \infty} \frac{n^2/2 + n/2 - 1}{n^2} = \lim_{n \rightarrow \infty} (1/2 + 1/(2n) - 1/(n^2)) = 1/2.
$$

**Example**: $n + 10 \ln n = O(n)$. We can plot $n$ and $10 \ln n$ to see that $n > 10 \ln n$ for $n \ge 40$.

![Big-O plot 2](/dsa/assets/running-time/bigO-fig2.png)

Thus, for $n \ge 40$, we have

$$
n + 10 \ln n \leq n + n = 2n.
$$

So in this case $c = 2$ and $n_0 = 40$.

We could also use limit approach. But before that we need to recall L'hospital rule that if $\lim f'(n)/g'(n)$ exists then and $\lim f(n)/g(n) = \lim f'(n)/g'(n)$ (assuming the derivatives exist). We have

$$
\lim_{n \rightarrow  \infty} \frac{n + 10 \ln n}{n} = 
\lim_{n \rightarrow  \infty} \frac{1 + 10 (1/n)}{1} = 1 < \infty.
$$

**Exercise**: Show that $\log_a n = O(\log_b n)$ for constants $a$ and $b$. Hint: use the change-of-base formula of logarithmic.

**Exercise**: Show that $2 \sqrt{n}  + n^{1/3} \log_2 n = O(\sqrt{n})$.

**Definition:** $g(n) = \Omega(f(n))$ if $f(n) = O(g(n))$.

To summarize $f=O(g(n))$ means that $f(n)$ grows no faster than $g(n)$ and $f(n) = \Omega(g(n))$ means that $f(n)$ grows no slower than $g(n)$.

We now need a notation to denote "similar growth rate".

**Definition:** We say $f(n) = \Theta(g(n))$ if $f(n) = O(g(n))$ and $g(n) = O(f(n))$.

Let us consider some examples.

**Example:** I claim that $2 n^{100} + n^{99} = \Theta(n^{100})$. To see this,

$$
\lim_{n \rightarrow \infty} \frac{2 n^{100} -n^{99}}{n^{100}} = 2 \text{, and } \lim_{n \rightarrow \infty} \frac{n^{100}}{2 n^{100} - n^{99}} = \lim_{n \rightarrow \infty} \frac{1}{2 - 1/n} = \frac{1}{2}.
$$

This shows that $2 n^{100} + n^{99} = O(n^{100})$ and $n^{100} = O(2 n^{100} + n^{99})$ and therefore $2 n^{100} + n^{99} = \Theta(n^{100})$.
Specifically, if you want to use the limit rule to show that $f(n) = \Theta(g(n))$, you need to show that

$$
0 < \lim_{n \rightarrow \infty} \frac{f(n)}{g(n)} < \infty.
$$

This means neither $f(n)$ nor $g(n)$ grows strictly faster than the other.

**Exercise:** Show that $n^{1.99} = O(n^2)$ but $n^{1.99} \neq \Theta(n^2)$.

**Exercise:** Show that if $n$ is a power of 2, then $2+4+8+\ldots+n = \Theta(n^2)$.

Finally, $o$ and $\omega$ are used to denote a "strictly slower growth rate" and "strictly faster growth rate" respectively.

**Definition:** We say $f(n) = o(g(n))$ if for any constant $c > 0$, there exists a constant $n_0$ such that $f(n) < c \cdot g(n)$ for all $n \geq n_0$.

This can also be shown using limits. Specifically, $f(n) = o(g(n))$ if

$$
\lim_{n \rightarrow \infty} \frac{f(n)}{g(n)} = 0.
$$

This means that $f(n)$ grows strictly slower than $g(n)$.

**Definition:** We say $f(n) = \omega(g(n))$ if $g(n) = o(f(n))$.

This means that $f(n)$ grows strictly faster than $g(n)$. This can also be shown using limits. Specifically, $f(n) = \omega(g(n))$ if

$$
\lim_{n \rightarrow \infty} \frac{f(n)}{g(n)} = \infty.
$$

Let's work on some examples.

**Example:** I claim that $\log_2 n = o(n^{0.1})$. To see this,

$$
\lim_{n \rightarrow \infty} \frac{\log_2 n}{n^{0.1}} =  \lim_{n \rightarrow \infty} \frac{\ln n}{\ln 2 \times   n^{0.1}} =  \frac{1}{\ln 2}\lim_{n \rightarrow \infty} \frac{\ln n}{   n^{0.1}} = \frac{1}{\ln 2}\lim_{n \rightarrow \infty} \frac{1/n}{0.1 n^{-0.9}} = \frac{1}{\ln 2}\lim_{n \rightarrow \infty} \frac{10}{n^{0.1}} = 0.
$$

**Example:** I claim that $3^n = \omega(2^n)$. To see this,

$$
\lim_{n \rightarrow \infty} \frac{3^n}{2^n} = \lim_{n \rightarrow \infty} (3/2)^n = \infty.
$$

To recap:

- $f(n) = O(g(n))$ means that $f(n)$'s growth is at most $g(n)$'s growth.
- $f(n) = \Omega(g(n))$ means that $f(n)$'s growth is at least $g(n)$'s growth.
- $f(n) = \Theta(g(n))$ means that $f(n)$'s growth is the same as $g(n)$'s growth.
- $f(n) = o(g(n))$ means that $f(n)$'s growth is strictly slower than $g(n)$'s growth.
- $f(n) = \omega(g(n))$ means that $f(n)$'s growth is strictly faster than $g(n)$'s growth.

<div class="sectionlecturebox">
Useful Facts
</div>

Let us go over some useful facts. Some proofs are omitted and left as exercise.

**Fact 1:** A polynomial has the same growth rate as its most significant terms. E.g., $3n^3 - n^2 +100 n = \Theta(n^3)$.
- A polynomial always grows faster than a poly-logarithmic. For example,

$$
\begin{align*}
n & = \omega(\log^{999} n), \\
n^{0.1} & = \omega(\log^{99} n), \\
n \log^2 n & = o(n^{1.01}), \ldots
\end{align*}
$$

**Fact 2:** An exponential function always grow faster than a polynomial function (as long as the base is larger than 1). For instance,

$$
\begin{align*}
n^{99} & = o(2^n), \\
n^{10} & = o({1.01}^{2n}), \ldots
\end{align*}
$$

**Fact 3:** For any constant $c$, $1^c +2^c +\ldots+n^c = \Theta(n^{c+1})$. E.g., $1^2 + 2^2 + \ldots + n^2 = \Theta(n^3)$. Let's try to prove this. First, see that

$$
1^c + 2^c + \ldots + n^c \leq \underbrace{n^c + n^c +\ldots + n^c}_{n \text{ times}} \leq n^{c+1} \implies 1^c + 2^c + \ldots + n^c = O(n^{c+1}).
$$

It remains to show that $1^c + \ldots + n^c =\Omega(n^{c+1})$. Here, we use a method called approximation by integrals. Let us take a look at the figure below.

![Approximation by integrals](/dsa/assets/running-time/integration-approximation.png)

Note that the area under the boxes is given by $1^c + 2^c + \ldots + n^c$ since the width of each box is $1$ and the height of the box at position $i$ is $i^c$. This area is larger than the area under the curve $x^c$ from $0$ to $n$. Hence,

$$
1^c + 2^c + \ldots + n^c \geq \int_0^n x^c dx = \frac{n^{c+1}}{c+1} \implies 1^c + 2^c + \ldots + n^c = \Omega(n^{c+1}).
$$

**Fact 4:** For any constant $c$, we have $c = O(1)$.

**Fact 5:** If $a < b$, then $a^n = o(b^n)$. E.g., $2^n = o(3^n)$.

**A common pitfall:** We have to be careful when dealing with sums where the number of terms is not fixed. For example, the following proof is **wrong**.

$$
1+2+3+\ldots+n = O(1) + O(1) + \ldots + O(1) = O(n).
$$

We showed that $1+2+\ldots+n = \frac{n(n+1)}{2} = \Theta(n^2)$ which grows faster than $O(n)$. What exactly went wrong here? For any constant $i$, it is true that $i = O(1)$; however, in the sum $\sum_{i=1}^n i$, we can see that $i$ is not a constant. It ranges over a set of values from $1$ to $n$ which depends on $n$.
