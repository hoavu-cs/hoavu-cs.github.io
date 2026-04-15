---
title: Floyd-Warshall Algorithm
parent: DSA
nav_order: 15
layout: default
permalink: /dsa/floyd-warshall/
---

# Floyd-Warshall Algorithm

Dijkstra and Bellman-Ford compute shortest paths from a **single source**. The **Floyd-Warshall algorithm** solves the **all-pairs shortest paths** problem: it finds the shortest distance between every pair of vertices in $O(n^3)$ time using dynamic programming.

It handles negative-weight edges but, like Bellman-Ford, assumes no negative-weight cycles. A negative cycle is detected if any diagonal entry $D[i][i]$ becomes negative after the algorithm finishes.

<div class="sectionlecturebox">
Algorithm
</div>

Define $D^{(k)}[i][j]$ as the length of the shortest path from $i$ to $j$ whose **intermediate vertices** all belong to $\{1, 2, \ldots, k\}$.

**Base case ($k = 0$):** No intermediate vertices are allowed, so

$$D^{(0)}[i][j] = \begin{cases} 0 & i = j \\ w(i,j) & \text{edge } (i,j) \text{ exists} \\ \infty & \text{otherwise.} \end{cases}$$

**Recurrence:** When we allow vertex $k$ as an intermediate, the shortest path from $i$ to $j$ either
1. does **not** pass through $k$: $D^{(k-1)}[i][j]$, or
2. **passes through** $k$: $D^{(k-1)}[i][k] + D^{(k-1)}[k][j]$.

$$D^{(k)}[i][j] = \min\!\bigl(D^{(k-1)}[i][j],\; D^{(k-1)}[i][k] + D^{(k-1)}[k][j]\bigr).$$

After processing all $n$ vertices the matrix $D^{(n)}$ holds the true shortest-path distances.

```
function floyd_warshall(n, w)
    D = copy of w   # D[i][i] = 0, D[i][j] = w(i,j) or ∞

    for k = 1 to n
        for i = 1 to n
            for j = 1 to n
                if D[i][k] + D[k][j] < D[i][j]
                    D[i][j] = D[i][k] + D[k][j]
                end
            end
        end
    end

    # Negative-cycle check
    for i = 1 to n
        if D[i][i] < 0
            report "negative cycle detected"
        end
    end

    return D
end
```

The in-place update (overwriting $D^{(k-1)}$ with $D^{(k)}$) is correct because the entries $D[i][k]$ and $D[k][j]$ are not changed during the $k$-th outer iteration: the only way vertex $k$ could shorten $D[i][k]$ or $D[k][j]$ is through itself as an intermediate, but that would require $D[k][k] < 0$, i.e., a negative cycle.

<div class="sectionlecturebox">
Example
</div>

Consider the following graph (source does not matter for all-pairs):

<script type="text/tikz">
\begin{tikzpicture}[->, >=stealth, thick,
    every node/.style={circle, draw, minimum size=8mm, inner sep=1pt, font=\sffamily},
    lbl/.style={draw=none, fill=white, minimum size=0, inner sep=2pt, font=\small\sffamily}]
  \node (1) at (0,   0)   {1};
  \node (2) at (3,   1.5) {2};
  \node (3) at (3,  -1.5) {3};
  \node (4) at (6,   0)   {4};
  \draw[->] (1) -- (2);
  \draw[->] (1) -- (3);
  \draw[->] (2) -- (4);
  \draw[->] (3) -- (2);
  \draw[->] (3) -- (4);
  \draw[->] (4) to[bend left=25] (1);
  \node[lbl] at (1.2,  1.0) {10};
  \node[lbl] at (1.2, -1.0) {5};
  \node[lbl] at (4.8,  1.0) {2};
  \node[lbl] at (3.5,  0)   {3};
  \node[lbl] at (4.8, -1.0) {1};
  \node[lbl] at (3,   -0.6) {4};
\end{tikzpicture}
</script>

**$D^{(0)}$ — direct edges only:**

| | 1 | 2 | 3 | 4 |
|:-:|:-:|:-:|:-:|:-:|
| **1** | 0 | 10 | 5 | ∞ |
| **2** | ∞ | 0 | ∞ | 2 |
| **3** | ∞ | 3 | 0 | 1 |
| **4** | 4 | ∞ | ∞ | 0 |

**$D^{(1)}$ — allow vertex 1 as intermediate:**

Only row 4 can improve (it has a direct edge to 1). $D[4][2] = \min(\infty,\, 4+10) = 14$; $D[4][3] = \min(\infty,\, 4+5) = 9$.

| | 1 | 2 | 3 | 4 |
|:-:|:-:|:-:|:-:|:-:|
| **1** | 0 | 10 | 5 | ∞ |
| **2** | ∞ | 0 | ∞ | 2 |
| **3** | ∞ | 3 | 0 | 1 |
| **4** | 4 | **14** | **9** | 0 |

**$D^{(2)}$ — allow vertices 1–2 as intermediates:**

Paths through vertex 2 extend via its outgoing edge $2\to 4$. $D[1][4] = \min(\infty,\, 10+2) = 12$.

| | 1 | 2 | 3 | 4 |
|:-:|:-:|:-:|:-:|:-:|
| **1** | 0 | 10 | 5 | **12** |
| **2** | ∞ | 0 | ∞ | 2 |
| **3** | ∞ | 3 | 0 | 1 |
| **4** | 4 | 14 | 9 | 0 |

**$D^{(3)}$ — allow vertices 1–3 as intermediates:**

Vertex 3 has outgoing edges to 2 and 4. $D[1][2] = \min(10,\, 5+3) = 8$; $D[1][4] = \min(12,\, 5+1) = 6$; $D[4][2] = \min(14,\, 9+3) = 12$.

| | 1 | 2 | 3 | 4 |
|:-:|:-:|:-:|:-:|:-:|
| **1** | 0 | **8** | 5 | **6** |
| **2** | ∞ | 0 | ∞ | 2 |
| **3** | ∞ | 3 | 0 | 1 |
| **4** | 4 | **12** | 9 | 0 |

**$D^{(4)}$ — allow all vertices as intermediates (final):**

Vertex 4 has an outgoing edge back to 1, unlocking paths from 2 and 3 to vertex 1. $D[2][1] = \min(\infty,\, 2+4) = 6$; $D[2][3] = \min(\infty,\, 2+9) = 11$; $D[3][1] = \min(\infty,\, 1+4) = 5$.

| | 1 | 2 | 3 | 4 |
|:-:|:-:|:-:|:-:|:-:|
| **1** | 0 | 8 | 5 | 6 |
| **2** | **6** | 0 | **11** | 2 |
| **3** | **5** | 3 | 0 | 1 |
| **4** | 4 | 12 | 9 | 0 |

The algorithm correctly discovers, for example, that the shortest path $2 \to 1$ (distance 6) goes $2 \to 4 \to 1$, and $3 \to 1$ (distance 5) goes $3 \to 4 \to 1$.

<div class="sectionlecturebox">
Correctness
</div>

**Claim.** $D^{(k)}[i][j]$ equals the weight of the shortest path from $i$ to $j$ using only vertices in $\{1, \ldots, k\}$ as intermediates.

**Proof by induction on $k$.** The base case $k=0$ holds by definition. For the inductive step, assume $D^{(k-1)}$ is correct. Any shortest path $P$ from $i$ to $j$ using intermediates in $\{1, \ldots, k\}$ either:

1. **Does not use vertex $k$:** intermediates lie in $\{1, \ldots, k-1\}$, so its weight equals $D^{(k-1)}[i][j]$.
2. **Uses vertex $k$:** split $P$ at the first occurrence of $k$ into $i \leadsto k$ and $k \leadsto j$. Assuming no negative cycle, $k$ appears at most once. Both sub-paths use only $\{1, \ldots, k-1\}$ as intermediates, so their weights are $D^{(k-1)}[i][k]$ and $D^{(k-1)}[k][j]$ by the hypothesis.

Taking the minimum of both cases gives the recurrence, completing the induction. $\square$

<div class="sectionlecturebox">
Running Time
</div>

Three nested loops each running $n$ iterations: $O(n^3)$ time, $O(n^2)$ space for the matrix.

<div class="sectionlecturebox">
Julia Implementation
</div>

```julia
function floyd_warshall(n, weights)
    # weights[i][j] = edge weight, Inf if no edge, 0 on diagonal
    D = [weights[i][j] for i in 1:n, j in 1:n]

    for k in 1:n
        for i in 1:n
            D[i][k] == Inf && continue
            for j in 1:n
                if D[i][k] + D[k][j] < D[i][j]
                    D[i][j] = D[i][k] + D[k][j]
                end
            end
        end
    end

    for i in 1:n
        D[i][i] < 0 && error("negative cycle detected")
    end

    return D
end
```
