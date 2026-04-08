---
title: Dijkstra's Algorithm
parent: DSA
nav_order: 13
layout: default
permalink: /dsa/dijkstra/
---

# Dijkstra's Algorithm

BFS finds shortest paths in unweighted graphs. When edges have weights, we need a generalisation. **Dijkstra's algorithm** finds shortest paths from a source vertex in a weighted directed graph with **non-negative** edge weights.

The algorithm maintains a tentative distance `dist[v]` for each vertex, initialized to $\infty$ for all vertices except the source, which is $0$. It repeatedly picks the vertex with the smallest tentative distance, finalises it, and propagates its distance to neighbours.

<div class="sectionlecturebox">
Tense Edges and Relaxation
</div>

We say an edge $(u, v)$ with weight $w(u,v)$ is **tense** if

$$
\text{dist}[u] + w(u, v) < \text{dist}[v].
$$

A tense edge means we have found a shorter route to $v$ through $u$. We **relax** it by updating

$$
\text{dist}[v] \;:=\; \text{dist}[u] + w(u, v) 
$$

$$
\text{parent}[v] := u.
$$

<div class="sectionlecturebox">
Algorithm
</div>

The straightforward version keeps all unfinished vertices in a set $R$ and scans it to find the minimum each round.

```
function dijkstra(graph, source)
    for each vertex v in graph
        dist[v] = ∞
        parent[v] = 0
    end
    dist[source] = 0

    R = {v | v in graph}
    while !isempty(R)
        u = vertex in R with minimum dist[u]
        remove u from R
        for each neighbor v of u
            if dist[u] + w(u, v) < dist[v]   # edge (u,v) is tense
                dist[v] = dist[u] + w(u, v)
                parent[v] = u
            end
        end
    end
    return dist, parent
end
```

**Example.** We run Dijkstra from source vertex 1 on the graph below. At each step: the extracted vertex is shown in **orange**, previously finalized vertices in **green**, and vertices currently in the priority queue in **yellow**. Bold edges indicate the relaxations performed in that step.

**Iteration 0: Initialise.**
Set dist[1] $= 0$, dist[v] $= \infty$ for all other $v$. Insert source into the priority queue. Priority queue: $\{(0,\, v_1)\}$.

<script type="text/tikz">
\begin{tikzpicture}[->, >=stealth, thick,
    every node/.style={circle, draw, minimum size=8mm, inner sep=1pt, font=\sffamily},
    lbl/.style={draw=none, fill=white, minimum size=0, inner sep=2pt, font=\small\sffamily}]
  \node[fill=orange!30] (1) at (0,   0)   {1};
  \node                 (2) at (3,   1.2) {2};
  \node                 (3) at (3,  -1.2) {3};
  \node                 (4) at (6,   0)   {4};
  \draw[->] (1) -- (2);
  \draw[->] (1) -- (3);
  \draw[->] (3) -- (2);
  \draw[->] (2) -- (4);
  \draw[->] (3) -- (4);
  \node[lbl] at (1.5,  0.75) {4};
  \node[lbl] at (1.35,-0.75) {2};
  \node[lbl] at (3.4,   0)   {1};
  \node[lbl] at (4.65, 0.75) {1};
  \node[lbl] at (4.35,-0.75) {5};
  \node[lbl] at (0,   -1.1) {dist=0};
  \node[lbl] at (3,    2.4) {dist=inf};
  \node[lbl] at (3,   -2.4) {dist=inf};
  \node[lbl] at (7.0,    0) {dist=inf};
\end{tikzpicture}
</script>

**Iteration 1: Extract vertex 1 (dist = 0).**
Relax $1 \to 2$ (weight 4): dist[2] $= 4$. Relax $1 \to 3$ (weight 2): dist[3] $= 2$. Priority queue: $\{(2,\, v_3),\; (4,\, v_2)\}$.

<script type="text/tikz">
\begin{tikzpicture}[->, >=stealth, thick,
    every node/.style={circle, draw, minimum size=8mm, inner sep=1pt, font=\sffamily},
    lbl/.style={draw=none, fill=white, minimum size=0, inner sep=2pt, font=\small\sffamily}]
  \node[fill=orange!30] (1) at (0,   0)   {1};
  \node[fill=yellow!40] (2) at (3,   1.2) {2};
  \node[fill=yellow!40] (3) at (3,  -1.2) {3};
  \node                 (4) at (6,   0)   {4};
  \draw[->, line width=2pt] (1) -- (2);
  \draw[->, line width=2pt] (1) -- (3);
  \draw[->]                 (3) -- (2);
  \draw[->]                 (2) -- (4);
  \draw[->]                 (3) -- (4);
  \node[lbl] at (1.5,  0.75) {4};
  \node[lbl] at (1.35,-0.75) {2};
  \node[lbl] at (3.4,   0)   {1};
  \node[lbl] at (4.65, 0.75) {1};
  \node[lbl] at (4.35,-0.75) {5};
  \node[lbl] at (0,   -1.1) {dist=0};
  \node[lbl] at (3,    2.4) {dist=4};
  \node[lbl] at (3,   -2.4) {dist=2};
  \node[lbl] at (7.0,    0) {dist=inf};
\end{tikzpicture}
</script>

**Iteration 2: Extract vertex 3 (dist = 2).**
Relax $3 \to 2$ (weight 1): dist[2] $= \min(4,\; 2+1) = 3$. Relax $3 \to 4$ (weight 5): dist[4] $= 7$. Priority queue: $\{(3,\, v_2),\; (7,\, v_4)\}$.

<script type="text/tikz">
\begin{tikzpicture}[->, >=stealth, thick,
    every node/.style={circle, draw, minimum size=8mm, inner sep=1pt, font=\sffamily},
    lbl/.style={draw=none, fill=white, minimum size=0, inner sep=2pt, font=\small\sffamily}]
  \node[fill=green!25]  (1) at (0,   0)   {1};
  \node[fill=yellow!40] (2) at (3,   1.2) {2};
  \node[fill=orange!30] (3) at (3,  -1.2) {3};
  \node[fill=yellow!40] (4) at (6,   0)   {4};
  \draw[->]                 (1) -- (2);
  \draw[->]                 (1) -- (3);
  \draw[->, line width=2pt] (3) -- (2);
  \draw[->]                 (2) -- (4);
  \draw[->, line width=2pt] (3) -- (4);
  \node[lbl] at (1.5,  0.75) {4};
  \node[lbl] at (1.35,-0.75) {2};
  \node[lbl] at (3.4,   0)   {1};
  \node[lbl] at (4.65, 0.75) {1};
  \node[lbl] at (4.35,-0.75) {5};
  \node[lbl] at (0,   -1.1) {dist=0};
  \node[lbl] at (3,    2.4) {dist=3};
  \node[lbl] at (3,   -2.4) {dist=2};
  \node[lbl] at (7.0,    0) {dist=7};
\end{tikzpicture}
</script>

**Iteration 3: Extract vertex 2 (dist = 3).**
Relax $2 \to 4$ (weight 1): dist[4] $= \min(7,\; 3+1) = 4$. Priority queue: $\{(4,\, v_4)\}$.

<script type="text/tikz">
\begin{tikzpicture}[->, >=stealth, thick,
    every node/.style={circle, draw, minimum size=8mm, inner sep=1pt, font=\sffamily},
    lbl/.style={draw=none, fill=white, minimum size=0, inner sep=2pt, font=\small\sffamily}]
  \node[fill=green!25]  (1) at (0,   0)   {1};
  \node[fill=orange!30] (2) at (3,   1.2) {2};
  \node[fill=green!25]  (3) at (3,  -1.2) {3};
  \node[fill=yellow!40] (4) at (6,   0)   {4};
  \draw[->]                 (1) -- (2);
  \draw[->]                 (1) -- (3);
  \draw[->]                 (3) -- (2);
  \draw[->, line width=2pt] (2) -- (4);
  \draw[->]                 (3) -- (4);
  \node[lbl] at (1.5,  0.75) {4};
  \node[lbl] at (1.35,-0.75) {2};
  \node[lbl] at (3.4,   0)   {1};
  \node[lbl] at (4.65, 0.75) {1};
  \node[lbl] at (4.35,-0.75) {5};
  \node[lbl] at (0,   -1.1) {dist=0};
  \node[lbl] at (3,    2.4) {dist=3};
  \node[lbl] at (3,   -2.4) {dist=2};
  \node[lbl] at (7.0,    0) {dist=4};
\end{tikzpicture}
</script>

**Iteration 4: Extract vertex 4 (dist = 4).**
No outgoing edges. All vertices finalized. The bold edges show the shortest-path tree.

<script type="text/tikz">
\begin{tikzpicture}[->, >=stealth, thick,
    every node/.style={circle, draw, minimum size=8mm, inner sep=1pt, font=\sffamily},
    lbl/.style={draw=none, fill=white, minimum size=0, inner sep=2pt, font=\small\sffamily}]
  \node[fill=green!25] (1) at (0,   0)   {1};
  \node[fill=green!25] (2) at (3,   1.2) {2};
  \node[fill=green!25] (3) at (3,  -1.2) {3};
  \node[fill=green!25] (4) at (6,   0)   {4};
  \draw[->]                 (1) -- (2);
  \draw[->, line width=2pt] (1) -- (3);
  \draw[->, line width=2pt] (3) -- (2);
  \draw[->, line width=2pt] (2) -- (4);
  \draw[->]                 (3) -- (4);
  \node[lbl] at (1.5,  0.75) {4};
  \node[lbl] at (1.35,-0.75) {2};
  \node[lbl] at (3.4,   0)   {1};
  \node[lbl] at (4.65, 0.75) {1};
  \node[lbl] at (4.35,-0.75) {5};
  \node[lbl] at (0,   -1.1) {dist=0};
  \node[lbl] at (3,    2.4) {dist=3};
  \node[lbl] at (3,   -2.4) {dist=2};
  \node[lbl] at (7.0,    0) {dist=4};
\end{tikzpicture}
</script>

The direct edge $1 \to 2$ has weight 4, but the path $1 \to 3 \to 2$ costs only $2 + 1 = 3$. Dijkstra finds this because it finalises vertex 3 (dist $= 2$) before vertex 2, allowing the relaxation $3 \to 2$ to lower dist$[2]$ from 4 to 3.

<div class="sectionlecturebox">
Correctness
</div>

**Invariant:** When a vertex $u$ is removed from $R$, $\text{dist}[u]$ is the true shortest-path distance from the source to $u$.

**Proof sketch (by induction on the order of removal).** The source is removed first with dist $= 0$, which is trivially correct. Suppose all previously removed vertices have correct distances. Let $u$ be the next vertex removed, with current distance $d$. Suppose for contradiction there is a shorter path $P$ from the source to $u$ of length $d' < d$. 

Recall that $R$ is the set of vertices not yet finalised (i.e., still in the priority queue) and  let $W=V\setminus R$ is the set of already-finalised vertices. Since $P$ is a path from the source to $u$  and $source \in W$, $u \in R$, there must be an edge $(x, u')$ on $P$ where $x \in W$ and $u' \in R$ is the first such edge along $P$.

Since $x$ is finalised, the induction hypothesis gives $dist[x] = $ true distance to $x$. Because $P$ passes through $x$ then $u'$,

$$\text{dist}[u'] \;\leq\; \text{dist}[x] + w(x, u') \;\leq\; \text{length of } P \text{ up to } u' \;\leq\; d' \;<\; d.$$

But $u'$ is still in the queue when $u$ is extracted, and Dijkstra always extracts the minimum. So $d \leq \text{dist}[u']$, giving $d \leq d' < d$, a contradiction. Hence no shorter path exists and dist$[u] = d$ is correct. $\square$

The non-negativity of weights is essential: a negative edge could create a shortcut discovered only after a vertex has been finalised, breaking the invariant.

<div class="sectionlecturebox">
Running Time
</div>

**Naive (linear scan):** Each of the $n$ iterations scans $R$ to find the minimum in $O(n)$ time and processes all outgoing edges. Total: $O(n^2 + m)$. Efficient when the graph is dense ($m \approx n^2$).

**With a priority queue:** Replace the linear scan with a binary min-heap. Each `extract-min` and `insert` costs $O(\log n)$.

Each vertex can be inserted into the priority queue multiple times (once per relaxation), but is effectively processed only when it is extracted with its true shortest distance. Later extractions for the same vertex will find dist$[u]$ already optimal and skip all edges. Total: $O((n + m) \log n)$.


<div class="sectionlecturebox">
Julia Implementation
</div>

```julia
using DataStructures: PriorityQueue, enqueue!, dequeue_pair!

function dijkstra(n, adj, source)
    # adj[u] is a list of (v, weight) pairs
    dist   = fill(Inf, n)
    parent = zeros(Int, n)
    dist[source] = 0.0

    pq = PriorityQueue{Int, Float64}()
    enqueue!(pq, source, 0.0)

    while !isempty(pq)
        u, d = dequeue_pair!(pq)
        d > dist[u] && continue   # stale entry

        for (v, w) in adj[u]
            if dist[u] + w < dist[v]
                dist[v]   = dist[u] + w
                parent[v] = u
                enqueue!(pq, v, dist[v])
            end
        end
    end

    return dist, parent
end
```
