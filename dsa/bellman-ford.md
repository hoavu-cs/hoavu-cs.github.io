---
title: Bellman-Ford Algorithm
parent: DSA
nav_order: 14
layout: default
permalink: /dsa/bellman-ford/
---

# Bellman-Ford Algorithm

Dijkstra's algorithm fails when the graph contains **negative-weight edges**: once a vertex is finalised, a later negative-cost shortcut could still improve its distance, but Dijkstra never revisits finalised vertices.

In general, we might run into a **negative cycle** — a cycle where continuously looping through it reduces the total path length without bound.
To avoid this, we define a path as a walk without repeated vertices (also known as a simple path).

The **Bellman-Ford algorithm** relaxes *all* edges in each of $n-1$ rounds. Any shortest path in a graph with $n$ vertices is a simple path, so it uses at most $n-1$ edges. 

<div class="sectionlecturebox">
Algorithm
</div>

```
function bellman_ford(graph, source)
    for each vertex v
        dist[v] = ∞
        parent[v] = 0
    end
    dist[source] = 0

    for i = 1 to n-1
        for each edge (u, v) with weight w
            if dist[u] + w < dist[v]      # edge (u,v) is tense
                dist[v]   = dist[u] + w
                parent[v] = u
            end
        end
    end

    # Negative-cycle check
    for each edge (u, v) with weight w
        if dist[u] + w < dist[v]
            report "negative cycle reachable from source"
        end
    end

    return dist, parent
end
```

**Example.** We run Bellman-Ford from source vertex 1 on the graph below. The negative edge $2 \to 3$ (weight $-4$) makes the path $1 \to 2 \to 3 \to 4$ cheaper than the direct edge $1 \to 4$, but it takes two rounds for this improvement to propagate all the way to vertex 4.

**Round 0: Initialise.**
dist[1] $= 0$, dist[v] $= \infty$ for all other $v$.

<script type="text/tikz">
\begin{tikzpicture}[->, >=stealth, thick,
    every node/.style={circle, draw, minimum size=8mm, inner sep=1pt, font=\sffamily},
    lbl/.style={draw=none, fill=white, minimum size=0, inner sep=2pt, font=\small\sffamily}]
  \node[fill=orange!30] (1) at (0,   0)   {1};
  \node                 (2) at (2,   1.2) {2};
  \node                 (3) at (4,   1.2) {3};
  \node                 (4) at (6,   0)   {4};
  \draw[->] (1) -- (2);
  \draw[->] (2) -- (3);
  \draw[->] (3) -- (4);
  \draw[->] (1) to[bend right=30] (4);
  \node[lbl] at (0.8,  1.0) {2};
  \node[lbl] at (3,    1.6) {-4};
  \node[lbl] at (5.2,  1.0) {1};
  \node[lbl] at (3,   -0.7) {8};
  \node[lbl] at (0,   -0.9) {dist=0};
  \node[lbl] at (2,    2.2) {dist=inf};
  \node[lbl] at (4,    2.2) {dist=inf};
  \node[lbl] at (6,   -0.9) {dist=inf};
\end{tikzpicture}
</script>

**Round 1.**
Relax $1 \to 2$: dist[2] $= 2$. Relax $1 \to 4$: dist[4] $= 8$. Edges $2 \to 3$ and $3 \to 4$ have no effect since dist[2] $= \infty$ and dist[3] $= \infty$ at the start of this round.

<script type="text/tikz">
\begin{tikzpicture}[->, >=stealth, thick,
    every node/.style={circle, draw, minimum size=8mm, inner sep=1pt, font=\sffamily},
    lbl/.style={draw=none, fill=white, minimum size=0, inner sep=2pt, font=\small\sffamily}]
  \node[fill=green!25]  (1) at (0,   0)   {1};
  \node[fill=orange!30] (2) at (2,   1.2) {2};
  \node                 (3) at (4,   1.2) {3};
  \node[fill=orange!30] (4) at (6,   0)   {4};
  \draw[->, line width=2pt] (1) -- (2);
  \draw[->]                 (2) -- (3);
  \draw[->]                 (3) -- (4);
  \draw[->, line width=2pt] (1) to[bend right=30] (4);
  \node[lbl] at (0.8,  1.0) {2};
  \node[lbl] at (3,    1.6) {-4};
  \node[lbl] at (5.2,  1.0) {1};
  \node[lbl] at (3,   -0.7) {8};
  \node[lbl] at (0,   -0.9) {dist=0};
  \node[lbl] at (2,    2.2) {dist=2};
  \node[lbl] at (4,    2.2) {dist=inf};
  \node[lbl] at (6,   -0.9) {dist=8};
\end{tikzpicture}
</script>

**Round 2.**
Relax $2 \to 3$: dist[3] $= 2 + (-4) = -2$. No other edge improves.

<script type="text/tikz">
\begin{tikzpicture}[->, >=stealth, thick,
    every node/.style={circle, draw, minimum size=8mm, inner sep=1pt, font=\sffamily},
    lbl/.style={draw=none, fill=white, minimum size=0, inner sep=2pt, font=\small\sffamily}]
  \node[fill=green!25]  (1) at (0,   0)   {1};
  \node[fill=yellow!40] (2) at (2,   1.2) {2};
  \node[fill=orange!30] (3) at (4,   1.2) {3};
  \node[fill=yellow!40] (4) at (6,   0)   {4};
  \draw[->]                 (1) -- (2);
  \draw[->, line width=2pt] (2) -- (3);
  \draw[->]                 (3) -- (4);
  \draw[->]                 (1) to[bend right=30] (4);
  \node[lbl] at (0.8,  1.0) {2};
  \node[lbl] at (3,    1.6) {-4};
  \node[lbl] at (5.2,  1.0) {1};
  \node[lbl] at (3,   -0.7) {8};
  \node[lbl] at (0,   -0.9) {dist=0};
  \node[lbl] at (2,    2.2) {dist=2};
  \node[lbl] at (4,    2.2) {dist=-2};
  \node[lbl] at (6,   -0.9) {dist=8};
\end{tikzpicture}
</script>

**Round 3.**
Relax $3 \to 4$: dist[4] $= -2 + 1 = -1$, improving from 8. No other edge improves. Distances are now final.

<script type="text/tikz">
\begin{tikzpicture}[->, >=stealth, thick,
    every node/.style={circle, draw, minimum size=8mm, inner sep=1pt, font=\sffamily},
    lbl/.style={draw=none, fill=white, minimum size=0, inner sep=2pt, font=\small\sffamily}]
  \node[fill=green!25] (1) at (0,   0)   {1};
  \node[fill=green!25] (2) at (2,   1.2) {2};
  \node[fill=green!25] (3) at (4,   1.2) {3};
  \node[fill=green!25] (4) at (6,   0)   {4};
  \draw[->]                 (1) -- (2);
  \draw[->]                 (2) -- (3);
  \draw[->, line width=2pt] (3) -- (4);
  \draw[->]                 (1) to[bend right=30] (4);
  \node[lbl] at (0.8,  1.0) {2};
  \node[lbl] at (3,    1.6) {-4};
  \node[lbl] at (5.2,  1.0) {1};
  \node[lbl] at (3,   -0.7) {8};
  \node[lbl] at (0,   -0.9) {dist=0};
  \node[lbl] at (2,    2.2) {dist=2};
  \node[lbl] at (4,    2.2) {dist=-2};
  \node[lbl] at (6,   -0.9) {dist=-1};
\end{tikzpicture}
</script>

The direct edge $1 \to 4$ (weight 8) is beaten by the path $1 \to 2 \to 3 \to 4$ (weight $2 - 4 + 1 = -1$). Bellman-Ford discovers this in two waves: round 1 propagates to vertex 2, round 2 propagates to vertex 3 via the negative edge, and round 3 propagates to vertex 4.

<div class="sectionlecturebox">
Negative Cycle Detection
</div>

After $n-1$ rounds, perform one additional scan of all edges. If any edge $(u, v)$ is still tense, i.e., dist$[u] + w(u, v) <$ dist$[v]$ — then there is a negative-weight cycle reachable from the source. Along such a cycle, distances can be decreased indefinitely, so no finite shortest path exists.

<div class="sectionlecturebox">
Correctness
</div>

**Claim.** After round $k$, dist$[v]$ is at most the weight of the shortest path from $s$ to $v$ using at most $k$ edges.

**Proof by induction on $k$.** After round $0$, dist$[s] = 0$ and dist$[v] = \infty$ for $v \ne s$, matching the shortest paths using $0$ edges. Assume the claim holds after round $k-1$. In round $k$, consider any vertex $v$ and its shortest path $P$ using at most $k$ edges. Let $(u, v)$ be the last edge of $P$; then $P$ without its last edge is a path from $s$ to $u$ using at most $k-1$ edges. By the inductive hypothesis, dist$[u]$ after round $k-1$ is at most the weight of that sub-path. When we relax $(u, v)$ in round $k$:

$$\text{dist}[v] \;\leq\; \text{dist}[u] + w(u,v) \;\leq\; \text{weight of } P.$$

This holds for every shortest path using $\le k$ edges, completing the induction.

Since any simple shortest path has at most $n-1$ edges (more would imply a cycle, which is non-negative by assumption), running $n-1$ rounds gives the exact shortest-path distances. $\square$

<div class="sectionlecturebox">
Running Time
</div>

Each round scans all $m$ edges once. With $n - 1$ rounds, the total time is $O(nm)$.

This is slower than Dijkstra ($O((n+m)\log n)$), but Bellman-Ford handles negative edges and detects negative cycles, making it indispensable when those cases arise.

<div class="sectionlecturebox">
Julia Implementation
</div>

```julia
function bellman_ford(n, adj, source)
    # adj[u] is a list of (v, weight) pairs
    dist   = fill(Inf, n)
    parent = zeros(Int, n)
    dist[source] = 0.0

    for _ in 1:n-1
        updated = false
        for u in 1:n
            dist[u] == Inf && continue
            for (v, w) in adj[u]
                if dist[u] + w < dist[v]
                    dist[v]   = dist[u] + w
                    parent[v] = u
                    updated   = true
                end
            end
        end
        updated || break   # early exit if no update occurred
    end

    # Negative-cycle check
    for u in 1:n
        for (v, w) in adj[u]
            if dist[u] + w < dist[v]
                error("negative cycle reachable from source")
            end
        end
    end

    return dist, parent
end
```
