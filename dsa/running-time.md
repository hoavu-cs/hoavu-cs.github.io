---
title: Running Time
parent: Data Structures
nav_order: 1
layout: default
permalink: /dsa/running-time/
---

Introduction
------------

Algorithms are the backbone of computer science. The study of algorithms predates computers (e.g., Euclid algorithm). An algorithm is a set of instructions to solve a particular problem. Analysis of algorithms consists of the following:

*   Mathematically prove that the described algorithm is correct.
*   Analyze its efficiency. In this course, we will focus on the running time. However, there are other measurements of efficiency such as memory use, communication (distributed algorithms), etc.

Algorithms to computer science is like physics to engineering. Some concrete applications: Efficiently sort a large database, scheduling tasks, finding the shortest path between two locations on a map, etc.

Running time and asymptotic notation
------------------------------------

The running time is measured based on the number of basic machine instructions such as memory access and pairwise arithmetic operations. For example, consider the following line of code \\\[ A\[i\] = A\[i\]+1. \\\] We have memory access operations (accessing \\(A\[i\]\\)) and a pairwise arithmetic operation. For the moment, let us adopt the following view: each line of the pseudo-code consists of a constant number of basic instructions. We want to count how many times these lines are executed in total. Let us look at the following example that sorts an array \\(A\[1 \\ldots n\]\\) of integers in increasing order. The algorithm is called selection sort. The idea is simple, scan through \\(A\[1 \\ldots n\]\\) to find the smallest element and put it in \\(A\[1\]\\), then scan through \\(A\[2 \\ldots n\]\\) to find the smallest element and put it in \\(A\[2\]\\), and so on.

    Selection sort, input: \(A[1 \ldots n]\)
    for j = 1,2,3,...,n-1
        min = j
        for k = j+1,...,n
            if A[min] > A[k]
                min = k
        swap A[j] and A[min]

*   Lines 1, 2, and 6 are executed \\(n-1\\) times.
*   Lines 3, 4, and 5 are executed at most \\(n-1, n-2, n-3, \\ldots, 1\\) times respectively.

Recall that \\(1+2+\\ldots+n = n(n+1)/2\\). The total running time is at most \\\[ T(n) = 3\\left(n-1 + \\sum\_{j=1}^{n-1} (n-j)\\right) = 3(n-1) + \\frac{3(n-1)n}{2}. \\\] What is the running time of the following dummy algorithm?

    A dummy algorithm
    for j = 1,2,3,...,n
        x = 0
        for k = 1,...,2^j
            y = 1

Asymptotic notation
-------------------

We often want to measure the growth of the running time as \\(n\\) increases. For example, when \\(T(n) = n^2/2 + n/2 - 1\\), the term \\(n^2\\) dictates the growth in terms of \\(n\\). We often use asymptotic notation to denote the running time to make our life easier. We use the notation \\(f(n) = O(g(n))\\) to say that the growth of \\(f(n)\\) is no more than the growth of \\(g(n)\\).

### Definition (Big O notation)

We say \\(f(n) = O(g(n))\\) if there exist constants \\(c\\) and \\(n\_0\\) such that \\(f(n) \\leq c(g(n))\\) for all \\(n \\geq n\_0\\). An equivalent definition is that \\\[ \\lim\_{n \\rightarrow \\infty} \\frac{f(n)}{g(n)} = d < \\infty \\\] (i.e., \\(d\\) is some constant). If \\(f(n) = O(g(n))\\), then \\(g(n) = \\Omega(f(n))\\) or equivalently \\(\\lim\_{n \\rightarrow \\infty} \\frac{g(n)}{f(n)} > 0\\). Let's consider some examples. I claim that \\(n^2/2 + n/2 - 1 = O(n^2)\\). One way to show this is as follows. For \\(n \\geq 1\\), \\\[ n^2/2 + n/2 - 1 \\leq n^2 + n^2 = 2 n^2. \\\] So in this case \\(c = 2\\) and \\(n\_0 = 1\\). Another way to show this is to use limit. \\\[ \\lim\_{n \\rightarrow \\infty} \\frac{n^2/2 + n/2 - 1}{n^2} = \\lim\_{n \\rightarrow \\infty} (1/2 + 1/(2n) - 1/(n^2)) = 1/2 < \\infty. \\\] So we say that the running time of selection sort is \\(O(n^2)\\). Let's look at another example: \\(n + 10 \\ln n = O(n)\\). We can plot \\(n\\) and \\(10 \\ln n\\) to see that \\(n > 10 \\ln n\\) for \\(n \\geq 40\\).

![Plot of n vs 10 ln n](https://yourwebsite.com/plot1.png)

Thus, for \\(n \\geq 40\\), we have \\\[ n + 10 \\ln n \\leq n + n = 2n. \\\] So in this case \\(c = 2\\) and \\(n\_0 = 40\\). We can also use limit approach, but before that recall L'Hospital's rule that if \\(\\lim f'(n)/g'(n)\\) exists then \\(\\lim f(n)/g(n) = \\lim f'(n)/g'(n)\\). We have \\\[ \\lim\_{n \\rightarrow \\infty} \\frac{n + 10 \\ln n}{n} = \\lim\_{n \\rightarrow \\infty} \\frac{1 + 10 (1/n)}{1} = 1 < \\infty. \\\] **Exercise**: Show that \\(\\log\_a n = O(\\log\_b n)\\) for constants \\(a\\) and \\(b\\). Hint: use the change-of-base formula of logarithmic. **Exercise**: Show that \\(2 \\sqrt{n} + n^{1/3} \\log\_2 n = O(\\sqrt{n})\\). We use the \\(\\Theta\\) notation to denote “similar growth rate.”

### Definition (Theta notation)

We say \\(f(n) = \\Theta(g(n))\\) if \\(f(n) = O(g(n))\\) and \\(g(n) = O(f(n))\\). An equivalent definition is that \\\[ \\lim\_{n \\rightarrow \\infty} \\frac{f(n)}{g(n)} = d \\\] for some constant \\(0 < d < \\infty\\). Let us consider some examples.

*   I claim that \\(2 n^{100} + n^{99} = \\Theta(n^{100})\\). To see this, \\\[ \\lim\_{n \\rightarrow \\infty} \\frac{2 n^{100} -n^{99}}{n^{100}} = 2 \\\] and \\(0 < 2 < \\infty\\).
*   **Exercise**: Show that \\(n^{1.99} = O(n^2)\\) but \\(n^{1.99} \\neq \\Theta(n^2)\\).
*   **Exercise**: Show that if \\(n\\) is a power of 2, then \\(2+4+8+\\ldots+n = \\Theta(n^2)\\).

Finally, \\(o\\) and \\(\\omega\\) are used to denote a “strictly slower growth rate” and “strictly faster growth rate” respectively.

### Definition (Little o and little omega)

We say

*   \\(f(n) = o(g(n))\\) if \\\[ \\lim\_{n \\rightarrow \\infty} \\frac{f(n)}{g(n)} = 0. \\\]
*   \\(f(n) = \\omega(g(n))\\) if \\\[ \\lim\_{n \\rightarrow \\infty} \\frac{f(n)}{g(n)} = \\infty. \\\]

Note that \\(f(n) = o(g(n))\\) is the same as \\(g(n) = \\omega(f(n))\\). Let's work on some examples.

*   I claim that \\(\\log\_2 n = o(n^{0.1})\\). To see this, \\\[ \\lim\_{n \\rightarrow \\infty} \\frac{\\log\_2 n}{n^{0.1}} = \\lim\_{n \\rightarrow \\infty} \\frac{\\ln n}{\\ln 2 \\times n^{0.1}} = \\frac{1}{\\ln 2}\\lim\_{n \\rightarrow \\infty} \\frac{\\ln n}{n^{0.1}} = \\frac{1}{\\ln 2}\\lim\_{n \\rightarrow \\infty} \\frac{1/n}{0.1 n^{-0.9}} = \\frac{1}{\\ln 2}\\lim\_{n \\rightarrow \\infty} \\frac{10}{n^{0.1}} = 0. \\\]
*   I claim that \\(3^n = \\omega(2^n)\\). To see this, \\\[ \\lim\_{n \\rightarrow \\infty} \\frac{3^n}{2^n} = \\lim\_{n \\rightarrow \\infty} (3/2)^n = \\infty. \\\]

To recap:

*   \\(f(n) = O(g(n))\\) means that \\(f(n)\\)’s growth is at most \\(g(n)\\)’s growth.
*   \\(f(n) = \\Omega(g(n))\\) means that \\(f(n)\\)’s growth is at least \\(g(n)\\)’s growth.
*   \\(f(n) = \\Theta(g(n))\\) means that \\(f(n)\\)’s growth is the same as \\(g(n)\\)’s growth.
*   \\(f(n) = o(g(n))\\) means that \\(f(n)\\)’s growth is strictly slower than \\(g(n)\\)’s growth.
*   \\(f(n) = \\omega(g(n))\\) means that \\(f(n)\\)’s growth is strictly faster than \\(g(n)\\)’s growth.

### Useful facts

Let us go over some useful facts. Some proofs are omitted and left as exercise.

*   A polynomial has the same growth rate as its most significant terms. E.g., \\(3n^3 - n^2 +100 n = \\Theta(n^3)\\).
*   A polynomial always grows faster than a poly-logarithmic. E.g., \\begin{align\*} n & = \\omega(\\log^{999} n), \\\\ n^{0.1} & = \\omega(\\log^{99} n), \\\\ n \\log^2 n & = o(n^{1.01}), \\ldots \\end{align\*}
*   An exponential function always grow faster than a polynomial function (as long as the base is larger than 1). E.g., \\begin{align\*} n^{99} & = o(2^n), \\\\ n^{10} & = o({1.01}^{2n}), \\ldots \\end{align\*}
*   For any constant \\(c\\), \\(1^c +2^c +\\ldots+n^c = \\Theta(n^{c+1})\\). E.g., \\(1^2 + 2^2 + \\ldots + n^2 = \\Theta(n^3)\\). Let's try to prove this. First, see that \\\[ 1^c + 2^c + \\ldots + n^c \\leq \\underbrace{n^c + n^c +\\ldots + n^c}\_{n \\text{ times}} \\leq n^{c+1} \\implies 1^c + 2^c + \\ldots + n^c = O(n^{c+1}). \\\] It remains to show that \\(1^c + \\ldots + n^c =\\Omega(n^{c+1}) \\). Here, we use a method called approximation by integrals.
    
    ![Approximation by integrals](https://yourwebsite.com/integrals.png)
    
    Note that the area under the boxes is given by \\(1^c + 2^c + \\ldots + n^c\\). This area is larger than the area under the curve \\(x^c\\) from \\(0\\) to \\(n\\). So \\\[ 1^c + 2^c + \\ldots + n^c \\geq \\int\_0^n x^c dx = \\frac{n^{c+1}}{c+1} \\implies 1^c + 2^c + \\ldots + n^c = \\Omega(n^{c+1}) \\text{, since \\(c\\) is a constant}. \\\]
*   For any constant \\(c\\), we have \\(c = O(1)\\).
*   If \\(a < b\\), then \\(a^n = o(b^n)\\). E.g., \\(2^n = o(3^n)\\).
*   **A common pitfall**. We have to be careful when dealing with sums where the number of terms is not fixed. For example, the following proof is **wrong**. \\\[ 1+2+3+\\ldots+n = O(1) + O(1) + \\ldots + O(1) = O(n). \\\] We showed that \\(1+2+\\ldots+n = n(n+1) = \\Theta(n^2)\\) which grows faster than \\(O(n)\\). What exactly went wrong here? For any constant \\(i\\), it is true that \\(i = O(1)\\); however, in the sum \\(\\sum\_{i=1}^n i\\), we can see that \\(i\\) is not a constant. It ranges over a set of values from \\(1\\) to \\(n\\) which depends on \\(n\\).