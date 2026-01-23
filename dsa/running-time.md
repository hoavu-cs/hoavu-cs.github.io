---
title: Running Time
parent: Data Structures
nav_order: 1
layout: default
permalink: /dsa/running-time/
---



# Running Time and Asymptotic Notation

**Hoa T. Vu**  
*San Diego State University, hvu2@sdsu.edu*

---

## 1. Introduction

Algorithms are the backbone of computer science. The study of algorithms predates computers (e.g., Euclid algorithm). An algorithm is a set of instructions to solve a particular problem. Analysis of algorithms consists of the following:

- Mathematically prove that the described algorithm is correct.
- Analyze its efficiency. In this course, we will focus on the running time. However, there are other measurements of efficiency such as memory use, communication (distributed algorithms), etc.

Algorithms to computer science is like physics to engineering. Some concrete applications: Efficiently sort a large database, scheduling tasks, finding the shortest path between two locations on a map, etc.

---

## 2. Running Time and Asymptotic Notation

The running time is measured based on the number of basic machine instructions such as memory access and pairwise arithmetic operations. For example, consider the following line of code:

```
A[i] = A[i] + 1
```

We have memory access operations (accessing `A[i]`) and a pairwise arithmetic operation. For the moment, let us adopt the following view: each line of the pseudo-code consists of a constant number of basic instructions. We want to count how many times these lines are executed in total.

Let us look at the following example that sorts an array `A[1:n]` of integers in increasing order. The algorithm is called selection sort. The idea is simple: scan through `A[1:n]` to find the smallest element and put it in `A[1]`, then scan through `A[2:n]` to find the smallest element and put it in `A[2]`, and so on.

### Algorithm 1: Selection Sort

```julia
function selection_sort!(A)
    n = length(A)
    for j in 1:(n-1)
        min_idx = j
        for k in (j+1):n
            if A[min_idx] > A[k]
                min_idx = k
            end
        end
        A[j], A[min_idx] = A[min_idx], A[j]  # Swap
    end
    return A
end
```

**Analysis:**
- The outer loop (line with `for j`) runs `n-1` times.
- The inner loop runs at most `n-1, n-2, n-3, ..., 1` times respectively.

Recall that 1 + 2 + ... + n = n(n+1)/2. The total running time is at most:

$$T(n) = 3(n-1) + 3 \sum_{j=1}^{n-1} (n-j) = 3(n-1) + 3(n-1)n/2$$

### Algorithm 2: A Dummy Algorithm

What is the running time of the following dummy algorithm?

```julia
function dummy_algorithm(n)
    for j in 1:n
        x = 0
        for k in 1:(2^j)
            y = 1
        end
    end
end
```

---

## 3. Asymptotic Notation

We often want to measure the growth of the running time as *n* increases. For example, when T(n) = n²/2 + n/2 - 1, the term n² dictates the growth in terms of *n*. We often use asymptotic notation to denote the running time to make our life easier. We use the notation f(n) = O(g(n)) to say that the growth of f(n) is no more than the growth of g(n).

### Definition: Big-O Notation

We say **f(n) = O(g(n))** if there exist constants *c* and *n₀* such that f(n) ≤ c·g(n) for all n ≥ n₀. An equivalent definition is that:

$$\lim_{n \to \infty} \frac{f(n)}{g(n)} = d < \infty$$

(i.e., *d* is some constant). If f(n) = O(g(n)), then g(n) = Ω(f(n)) or equivalently:

$$\lim_{n \to \infty} \frac{g(n)}{f(n)} > 0$$

### Examples

**Example 1:** I claim that n²/2 + n/2 - 1 = O(n²).

One way to show this is as follows. For n ≥ 1:

$$\frac{n^2}{2} + \frac{n}{2} - 1 \leq n^2 + n^2 = 2n^2$$

So in this case c = 2 and n₀ = 1.

Another way to show this is to use limits:

$$\lim_{n \to \infty} \frac{n^2/2 + n/2 - 1}{n^2} = \lim_{n \to \infty} \left(\frac{1}{2} + \frac{1}{2n} - \frac{1}{n^2}\right) = \frac{1}{2} < \infty$$

So we say that the running time of selection sort is **O(n²)**.

**Example 2:** n + 10 ln n = O(n).

We can plot *n* and 10 ln n to see that n > 10 ln n for n ≥ 40. Thus, for n ≥ 40:

$$n + 10 \ln n \leq n + n = 2n$$

So in this case c = 2 and n₀ = 40.

We can also use the limit approach. Recall L'Hôpital's rule: if lim f'(n)/g'(n) exists, then lim f(n)/g(n) = lim f'(n)/g'(n). We have:

$$\lim_{n \to \infty} \frac{n + 10 \ln n}{n} = \lim_{n \to \infty} \frac{1 + 10(1/n)}{1} = 1 < \infty$$

**Exercise:** Show that log_a(n) = O(log_b(n)) for constants *a* and *b*. *Hint: use the change-of-base formula of logarithms.*

**Exercise:** Show that 2√n + n^(1/3) log₂ n = O(√n).

---

### Definition: Theta Notation

We use the Θ notation to denote "similar growth rate".

We say **f(n) = Θ(g(n))** if f(n) = O(g(n)) and g(n) = O(f(n)). An equivalent definition is that:

$$\lim_{n \to \infty} \frac{f(n)}{g(n)} = d$$

for some constant 0 < d < ∞.

### Examples

- I claim that 2n¹⁰⁰ + n⁹⁹ = Θ(n¹⁰⁰). To see this:
  $$\lim_{n \to \infty} \frac{2n^{100} - n^{99}}{n^{100}} = 2$$
  and 0 < 2 < ∞.

- **Exercise:** Show that n^1.99 = O(n²) but n^1.99 ≠ Θ(n²).

- **Exercise:** Show that if *n* is a power of 2, then 2 + 4 + 8 + ... + n = Θ(n²).

---

### Definition: Little-o and Little-ω Notation

Finally, *o* and *ω* are used to denote "strictly slower growth rate" and "strictly faster growth rate" respectively.

We say:
- **f(n) = o(g(n))** if:
  $$\lim_{n \to \infty} \frac{f(n)}{g(n)} = 0$$

- **f(n) = ω(g(n))** if:
  $$\lim_{n \to \infty} \frac{f(n)}{g(n)} = \infty$$

Note that f(n) = o(g(n)) is the same as g(n) = ω(f(n)).

### Examples

- I claim that log₂ n = o(n^0.1). To see this:
  $$\lim_{n \to \infty} \frac{\log_2 n}{n^{0.1}} = \frac{1}{\ln 2} \lim_{n \to \infty} \frac{\ln n}{n^{0.1}} = \frac{1}{\ln 2} \lim_{n \to \infty} \frac{1/n}{0.1 n^{-0.9}} = \frac{1}{\ln 2} \lim_{n \to \infty} \frac{10}{n^{0.1}} = 0$$

- I claim that 3ⁿ = ω(2ⁿ). To see this:
  $$\lim_{n \to \infty} \frac{3^n}{2^n} = \lim_{n \to \infty} \left(\frac{3}{2}\right)^n = \infty$$

---

## Summary

| Notation | Meaning |
|----------|---------|
| f(n) = O(g(n)) | f(n)'s growth is **at most** g(n)'s growth |
| f(n) = Ω(g(n)) | f(n)'s growth is **at least** g(n)'s growth |
| f(n) = Θ(g(n)) | f(n)'s growth is **the same as** g(n)'s growth |
| f(n) = o(g(n)) | f(n)'s growth is **strictly slower than** g(n)'s growth |
| f(n) = ω(g(n)) | f(n)'s growth is **strictly faster than** g(n)'s growth |

---

## Useful Facts

Some proofs are omitted and left as exercises.

- **A polynomial has the same growth rate as its most significant term.** E.g., 3n³ - n² + 100n = Θ(n³).

- **A polynomial always grows faster than a poly-logarithmic.** E.g.,
  - n = ω(log⁹⁹⁹ n)
  - n^0.1 = ω(log⁹⁹ n)
  - n log² n = o(n^1.01)

- **An exponential function always grows faster than a polynomial function** (as long as the base is larger than 1). E.g.,
  - n⁹⁹ = o(2ⁿ)
  - n¹⁰ = o(1.01^(2n))

- **For any constant c:** 1^c + 2^c + ... + n^c = Θ(n^(c+1)). E.g., 1² + 2² + ... + n² = Θ(n³).

  **Proof:** First, see that:
  $$1^c + 2^c + \ldots + n^c \leq \underbrace{n^c + n^c + \ldots + n^c}_{n \text{ times}} = n^{c+1}$$
  
  Thus 1^c + 2^c + ... + n^c = O(n^(c+1)).

  It remains to show that 1^c + ... + n^c = Ω(n^(c+1)). Here, we use a method called **approximation by integrals**. The area under the boxes is given by 1^c + 2^c + ... + n^c. This area is larger than the area under the curve x^c from 0 to n. So:
  $$1^c + 2^c + \ldots + n^c \geq \int_0^n x^c \, dx = \frac{n^{c+1}}{c+1}$$
  
  Thus 1^c + 2^c + ... + n^c = Ω(n^(c+1)), since *c* is a constant.

- **For any constant c:** c = O(1).

- **If a < b:** then aⁿ = o(bⁿ). E.g., 2ⁿ = o(3ⁿ).

---

## A Common Pitfall

We have to be careful when dealing with sums where the number of terms is not fixed. For example, the following proof is **WRONG**:

$$1 + 2 + 3 + \ldots + n = O(1) + O(1) + \ldots + O(1) = O(n)$$

We showed that 1 + 2 + ... + n = n(n+1)/2 = Θ(n²) which grows faster than O(n).

**What exactly went wrong here?** For any constant *i*, it is true that i = O(1); however, in the sum Σᵢ₌₁ⁿ i, we can see that *i* is not a constant. It ranges over a set of values from 1 to *n* which depends on *n*.# Running Time and Asymptotic Notation

**Hoa T. Vu**  
*San Diego State University, hvu2@sdsu.edu*

---

## 1. Introduction

Algorithms are the backbone of computer science. The study of algorithms predates computers (e.g., Euclid algorithm). An algorithm is a set of instructions to solve a particular problem. Analysis of algorithms consists of the following:

- Mathematically prove that the described algorithm is correct.
- Analyze its efficiency. In this course, we will focus on the running time. However, there are other measurements of efficiency such as memory use, communication (distributed algorithms), etc.

Algorithms to computer science is like physics to engineering. Some concrete applications: Efficiently sort a large database, scheduling tasks, finding the shortest path between two locations on a map, etc.

---

## 2. Running Time and Asymptotic Notation

The running time is measured based on the number of basic machine instructions such as memory access and pairwise arithmetic operations. For example, consider the following line of code:

```
A[i] = A[i] + 1
```

We have memory access operations (accessing `A[i]`) and a pairwise arithmetic operation. For the moment, let us adopt the following view: each line of the pseudo-code consists of a constant number of basic instructions. We want to count how many times these lines are executed in total.

Let us look at the following example that sorts an array `A[1:n]` of integers in increasing order. The algorithm is called selection sort. The idea is simple: scan through `A[1:n]` to find the smallest element and put it in `A[1]`, then scan through `A[2:n]` to find the smallest element and put it in `A[2]`, and so on.

### Algorithm 1: Selection Sort

```julia
function selection_sort!(A)
    n = length(A)
    for j in 1:(n-1)
        min_idx = j
        for k in (j+1):n
            if A[min_idx] > A[k]
                min_idx = k
            end
        end
        A[j], A[min_idx] = A[min_idx], A[j]  # Swap
    end
    return A
end
```

**Analysis:**
- The outer loop (line with `for j`) runs `n-1` times.
- The inner loop runs at most `n-1, n-2, n-3, ..., 1` times respectively.

Recall that 1 + 2 + ... + n = n(n+1)/2. The total running time is at most:

$$T(n) = 3(n-1) + 3 \sum_{j=1}^{n-1} (n-j) = 3(n-1) + 3(n-1)n/2$$

### Algorithm 2: A Dummy Algorithm

What is the running time of the following dummy algorithm?

```julia
function dummy_algorithm(n)
    for j in 1:n
        x = 0
        for k in 1:(2^j)
            y = 1
        end
    end
end
```

---

## 3. Asymptotic Notation

We often want to measure the growth of the running time as *n* increases. For example, when T(n) = n²/2 + n/2 - 1, the term n² dictates the growth in terms of *n*. We often use asymptotic notation to denote the running time to make our life easier. We use the notation f(n) = O(g(n)) to say that the growth of f(n) is no more than the growth of g(n).

### Definition: Big-O Notation

We say **f(n) = O(g(n))** if there exist constants *c* and *n₀* such that f(n) ≤ c·g(n) for all n ≥ n₀. An equivalent definition is that:

$$\lim_{n \to \infty} \frac{f(n)}{g(n)} = d < \infty$$

(i.e., *d* is some constant). If f(n) = O(g(n)), then g(n) = Ω(f(n)) or equivalently:

$$\lim_{n \to \infty} \frac{g(n)}{f(n)} > 0$$

### Examples

**Example 1:** I claim that n²/2 + n/2 - 1 = O(n²).

One way to show this is as follows. For n ≥ 1:

$$\frac{n^2}{2} + \frac{n}{2} - 1 \leq n^2 + n^2 = 2n^2$$

So in this case c = 2 and n₀ = 1.

Another way to show this is to use limits:

$$\lim_{n \to \infty} \frac{n^2/2 + n/2 - 1}{n^2} = \lim_{n \to \infty} \left(\frac{1}{2} + \frac{1}{2n} - \frac{1}{n^2}\right) = \frac{1}{2} < \infty$$

So we say that the running time of selection sort is **O(n²)**.

**Example 2:** n + 10 ln n = O(n).

We can plot *n* and 10 ln n to see that n > 10 ln n for n ≥ 40. Thus, for n ≥ 40:

$$n + 10 \ln n \leq n + n = 2n$$

So in this case c = 2 and n₀ = 40.

We can also use the limit approach. Recall L'Hôpital's rule: if lim f'(n)/g'(n) exists, then lim f(n)/g(n) = lim f'(n)/g'(n). We have:

$$\lim_{n \to \infty} \frac{n + 10 \ln n}{n} = \lim_{n \to \infty} \frac{1 + 10(1/n)}{1} = 1 < \infty$$

**Exercise:** Show that log_a(n) = O(log_b(n)) for constants *a* and *b*. *Hint: use the change-of-base formula of logarithms.*

**Exercise:** Show that 2√n + n^(1/3) log₂ n = O(√n).

---

### Definition: Theta Notation

We use the Θ notation to denote "similar growth rate".

We say **f(n) = Θ(g(n))** if f(n) = O(g(n)) and g(n) = O(f(n)). An equivalent definition is that:

$$\lim_{n \to \infty} \frac{f(n)}{g(n)} = d$$

for some constant 0 < d < ∞.

### Examples

- I claim that 2n¹⁰⁰ + n⁹⁹ = Θ(n¹⁰⁰). To see this:
  $$\lim_{n \to \infty} \frac{2n^{100} - n^{99}}{n^{100}} = 2$$
  and 0 < 2 < ∞.

- **Exercise:** Show that n^1.99 = O(n²) but n^1.99 ≠ Θ(n²).

- **Exercise:** Show that if *n* is a power of 2, then 2 + 4 + 8 + ... + n = Θ(n²).

---

### Definition: Little-o and Little-ω Notation

Finally, *o* and *ω* are used to denote "strictly slower growth rate" and "strictly faster growth rate" respectively.

We say:
- **f(n) = o(g(n))** if:
  $$\lim_{n \to \infty} \frac{f(n)}{g(n)} = 0$$

- **f(n) = ω(g(n))** if:
  $$\lim_{n \to \infty} \frac{f(n)}{g(n)} = \infty$$

Note that f(n) = o(g(n)) is the same as g(n) = ω(f(n)).

### Examples

- I claim that log₂ n = o(n^0.1). To see this:
  $$\lim_{n \to \infty} \frac{\log_2 n}{n^{0.1}} = \frac{1}{\ln 2} \lim_{n \to \infty} \frac{\ln n}{n^{0.1}} = \frac{1}{\ln 2} \lim_{n \to \infty} \frac{1/n}{0.1 n^{-0.9}} = \frac{1}{\ln 2} \lim_{n \to \infty} \frac{10}{n^{0.1}} = 0$$

- I claim that 3ⁿ = ω(2ⁿ). To see this:
  $$\lim_{n \to \infty} \frac{3^n}{2^n} = \lim_{n \to \infty} \left(\frac{3}{2}\right)^n = \infty$$

---

## Summary

| Notation | Meaning |
|----------|---------|
| f(n) = O(g(n)) | f(n)'s growth is **at most** g(n)'s growth |
| f(n) = Ω(g(n)) | f(n)'s growth is **at least** g(n)'s growth |
| f(n) = Θ(g(n)) | f(n)'s growth is **the same as** g(n)'s growth |
| f(n) = o(g(n)) | f(n)'s growth is **strictly slower than** g(n)'s growth |
| f(n) = ω(g(n)) | f(n)'s growth is **strictly faster than** g(n)'s growth |

---

## Useful Facts

Some proofs are omitted and left as exercises.

- **A polynomial has the same growth rate as its most significant term.** E.g., 3n³ - n² + 100n = Θ(n³).

- **A polynomial always grows faster than a poly-logarithmic.** E.g.,
  - n = ω(log⁹⁹⁹ n)
  - n^0.1 = ω(log⁹⁹ n)
  - n log² n = o(n^1.01)

- **An exponential function always grows faster than a polynomial function** (as long as the base is larger than 1). E.g.,
  - n⁹⁹ = o(2ⁿ)
  - n¹⁰ = o(1.01^(2n))

- **For any constant c:** 1^c + 2^c + ... + n^c = Θ(n^(c+1)). E.g., 1² + 2² + ... + n² = Θ(n³).

  **Proof:** First, see that:
  $$1^c + 2^c + \ldots + n^c \leq \underbrace{n^c + n^c + \ldots + n^c}_{n \text{ times}} = n^{c+1}$$
  
  Thus 1^c + 2^c + ... + n^c = O(n^(c+1)).

  It remains to show that 1^c + ... + n^c = Ω(n^(c+1)). Here, we use a method called **approximation by integrals**. The area under the boxes is given by 1^c + 2^c + ... + n^c. This area is larger than the area under the curve x^c from 0 to n. So:
  $$1^c + 2^c + \ldots + n^c \geq \int_0^n x^c \, dx = \frac{n^{c+1}}{c+1}$$
  
  Thus 1^c + 2^c + ... + n^c = Ω(n^(c+1)), since *c* is a constant.

- **For any constant c:** c = O(1).

- **If a < b:** then aⁿ = o(bⁿ). E.g., 2ⁿ = o(3ⁿ).

---

## A Common Pitfall

We have to be careful when dealing with sums where the number of terms is not fixed. For example, the following proof is **WRONG**:

$$1 + 2 + 3 + \ldots + n = O(1) + O(1) + \ldots + O(1) = O(n)$$

We showed that 1 + 2 + ... + n = n(n+1)/2 = Θ(n²) which grows faster than O(n).

**What exactly went wrong here?** For any constant *i*, it is true that i = O(1); however, in the sum Σᵢ₌₁ⁿ i, we can see that *i* is not a constant. It ranges over a set of values from 1 to *n* which depends on *n*.