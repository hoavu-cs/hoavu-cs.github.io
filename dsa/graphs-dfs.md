---
title: Graph Representations and Depth First Search (DFS)
parent: DSA
nav_order: 10
layout: default
permalink: /dsa/graphs-dfs/
---

# Graph Representations and Depth First Search (DFS)

A **graph** $G = (V, E)$ is a set of vertices $V$ and edges $E$. A graph can be directed or undirected, weighted or unweighted. Let $n = \|V\|$ and $m = \|E\|$.

We study graphs because they powerfully model many real-world problems that encode pairwise relationships. For example, the internet can be modeled as a graph where each webpage is a vertex and an edge from page $A$ to page $B$ indicates that $A$ links to $B$. Similarly, a social network can be modeled as a graph where each person is a vertex and an edge between two vertices indicates that the two people are friends. There are biological networks, transportation networks, and many more. Graph algorithms are fundamental tools for analyzing these complex systems.

Graphs come in four main types depending on whether edges are directed and whether they carry weights.

**Undirected, Unweighted** — edges have no direction and no weight. Models symmetric relationships (e.g., friendship).

<script type="text/tikz">
\begin{tikzpicture}[thick,
    every node/.style={circle, draw, minimum size=8mm, inner sep=1pt, font=\sffamily}]
  \node (1) at (0,0) {1};
  \node (2) at (2,0) {2};
  \node (3) at (1,-1.5) {3};
  \node (4) at (3,-1.5) {4};
  \draw (1) -- (2);
  \draw (1) -- (3);
  \draw (2) -- (3);
  \draw (2) -- (4);
\end{tikzpicture}
</script>

**Undirected, Weighted** — edges have weights but no direction. Models symmetric relationships with costs (e.g., road distances).

<script type="text/tikz">
\begin{tikzpicture}[thick,
    every node/.style={circle, draw, minimum size=8mm, inner sep=1pt, font=\sffamily},
    lbl/.style={draw=none, fill=white, minimum size=0, inner sep=2pt, font=\small\sffamily}]
  \node (1) at (0,0) {1};
  \node (2) at (2,0) {2};
  \node (3) at (1,-1.5) {3};
  \node (4) at (3,-1.5) {4};
  \draw (1) -- node[lbl] {4} (2);
  \draw (1) -- node[lbl] {2} (3);
  \draw (2) -- node[lbl] {7} (3);
  \draw (2) -- node[lbl] {1} (4);
\end{tikzpicture}
</script>

**Directed, Unweighted** — edges have direction but no weight. Models one-way relationships (e.g., following on social media).

<script type="text/tikz">
\begin{tikzpicture}[->, >=stealth, thick,
    every node/.style={circle, draw, minimum size=8mm, inner sep=1pt, font=\sffamily}]
  \node (1) at (0,0) {1};
  \node (2) at (2,0) {2};
  \node (3) at (1,-1.5) {3};
  \node (4) at (3,-1.5) {4};
  \draw[->] (1) -- (2);
  \draw[->] (1) -- (3);
  \draw[->] (3) -- (2);
  \draw[->] (2) -- (4);
\end{tikzpicture}
</script>

**Directed, Weighted** — edges have both direction and weight. Models one-way relationships with costs (e.g., flight routes with prices).

<script type="text/tikz">
\begin{tikzpicture}[->, >=stealth, thick,
    every node/.style={circle, draw, minimum size=8mm, inner sep=1pt, font=\sffamily},
    lbl/.style={draw=none, fill=white, minimum size=0, inner sep=2pt, font=\small\sffamily}]
  \node (1) at (0,0) {1};
  \node (2) at (2,0) {2};
  \node (3) at (1,-1.5) {3};
  \node (4) at (3,-1.5) {4};
  \draw[->] (1) -- node[lbl] {2} (2);
  \draw[->] (1) -- node[lbl] {$-1$} (3);
  \draw[->] (3) -- node[lbl] {0} (2);
  \draw[->] (2) -- node[lbl] {1} (4);
\end{tikzpicture}
</script>

<div class="sectionlecturebox">
Graph Representations
</div>

There are two common ways to represent a graph: **adjacency matrix** and **adjacency list**.

### Adjacency Matrix

An adjacency matrix is an $n \times n$ matrix $A$ where $A[i, j] = 1$ if there is an edge from vertex $i$ to vertex $j$. If the graph is weighted, $A[i, j]$ stores the edge weight. If there is no edge, $A[i, j] = \emptyset$. For an undirected graph, $A[i, j] = A[j, i]$.

**Example:** 

<script type="text/tikz">
\begin{tikzpicture}[->, >=stealth, thick,
    every node/.style={circle, draw, minimum size=8mm, inner sep=1pt, font=\sffamily},
    lbl/.style={draw=none, fill=white, minimum size=0, inner sep=2pt, font=\small\sffamily}]
  \node (1) at (0,0) {1};
  \node (2) at (2,0) {2};
  \node (3) at (1,-1.5) {3};
  \node (4) at (3,-1.5) {4};
  \draw[->] (1) -- node[lbl] {2} (2);
  \draw[->] (1) -- node[lbl] {$-1$} (3);
  \draw[->] (3) -- node[lbl] {0} (2);
  \draw[->] (2) -- node[lbl] {1} (4);
\end{tikzpicture}
</script>


The adjacency matrix for this graph is:

$$
A = \begin{bmatrix}
\emptyset & 2 & -1 & \emptyset \\
\emptyset & \emptyset & \emptyset & 1 \\
\emptyset & 0 & \emptyset & \emptyset \\
\emptyset & \emptyset & \emptyset & \emptyset
\end{bmatrix}
$$

In Julia, using `Inf` for no edge:

```julia
A = [
    Inf   2.0  -1.0  Inf;
    Inf   Inf   Inf   1.0;
    Inf   0.0   Inf   Inf;
    Inf   Inf   Inf   Inf
]
```

- **Space:** $O(n^2)$ — expensive for large sparse graphs.
- **Edge lookup:** $O(1)$.

### Adjacency List

An adjacency list stores, for each vertex, a list of its neighbors. For weighted graphs, each entry is a pair $(v, w)$ where $v$ is the neighbor and $w$ is the edge weight.

**Example:** For the same graph:

$$
\begin{aligned}
L[1] &= \{(2,\ 2),\ (3,\ {-1})\} \\
L[2] &= \{(4,\ 1)\} \\
L[3] &= \{(2,\ 0)\} \\
L[4] &= \emptyset
\end{aligned}
$$

In Julia:

```julia
L = [
    [(2, 2), (3, -1)],  # neighbors of vertex 1
    [(4, 1)],           # neighbors of vertex 2
    [(2, 0)],           # neighbors of vertex 3
    []                  # neighbors of vertex 4
]
```

- **Space:** $O(n + m)$ — efficient for large sparse graphs.
- **Edge lookup:** $O(d)$ where $d$ is the degree of the vertex.



<div class="sectionlecturebox">
Depth-First Search (DFS)
</div>

Depth-First Search (DFS) is a graph traversal algorithm. Starting from a source vertex, it explores as far as possible along each branch before backtracking.

The template for DFS is:

```julia
visited = falses(n)

function visit(adj, s)
    visited[s] = true # mark s as visited
    # iterate over neighbors of s and visit unvisited neighbors
    for neighbor in adj[s]
        v = if istuple(neighbor) then neighbor[1] else neighbor
        if !visited[v]
            visit(adj, v)
        end
    end
end
```

### Running Time

Every vertex is visited at most once: $O(n)$ total calls to `visit`. Inside each call, we iterate over the neighbors of $s$. Summed over all vertices, this is the total number of edges: $O(m)$. So the overall running time is $O(n + m)$.

### Reachability

To find all vertices reachable from a source $s$, simply call `visit(G, s)`. Afterward, every vertex $v$ with `visited[v] = true` is reachable from $s$.

<div class="sectionlecturebox">
Connected Components
</div>

A **connected component** of an undirected graph is a maximal set of vertices such that there is a path between any two vertices in the set.

**Key observation:** calling `visit(s)` marks every vertex reachable from $s$ as visited — which is exactly the connected component containing $s$. So to find all components, we scan through all vertices and start a fresh DFS from each one that hasn't been reached yet.

```julia
counter = 0
for each vertex v in V:
    if not visited[v]:
        counter = counter + 1
        visit(G, v)
```

Each call to `visit` marks an entire component. The final value of `counter` is the number of connected components. Since every vertex and edge is touched at most once across all DFS calls, the total running time is still $O(n + m)$.

```julia
function connected_components(n, adj)
    visited = falses(n)
    component = zeros(Int, n)
    num_components = 0

    function visit(s)
        visited[s] = true
        component[s] = num_components
        for v in adj[s]
            if !visited[v]
                visit(v)
            end
        end
    end

    for s in 1:n
        if !visited[s]
            num_components += 1
            visit(s)
        end
    end

    return num_components, component
end
```

<div class="sectionlecturebox">
Topological Sorting
</div>

A **topological sorting** of a directed graph is a linear ordering of its vertices such that for every directed edge $u \to v$, vertex $u$ comes before $v$ in the ordering. Topological sorting is only possible if the graph is a **Directed Acyclic Graph (DAG)**.

**Example:** Consider the following DAG representing task dependencies (an edge $u \to v$ means task $u$ must be completed before task $v$):

<script type="text/tikz">
\begin{tikzpicture}[->, >=stealth, thick,
    every node/.style={circle, draw, minimum size=8mm, inner sep=1pt, font=\sffamily}]
  \node (a) at (0, 0)   {$a$};
  \node (b) at (2, 1)   {$b$};
  \node (c) at (2, -1)  {$c$};
  \node (d) at (4, 1)   {$d$};
  \node (e) at (4, -1)  {$e$};
  \node (f) at (6, 0)   {$f$};
  \draw[->] (a) -- (b);
  \draw[->] (a) -- (c);
  \draw[->] (b) -- (d);
  \draw[->] (c) -- (e);
  \draw[->] (d) -- (f);
  \draw[->] (e) -- (f);
  \draw[->] (b) -- (e);
\end{tikzpicture}
</script>

One valid topological order is $a \to b \to c \to d \to e \to f$, where every edge points left-to-right:

<script type="text/tikz">
\begin{tikzpicture}[->, >=stealth, thick,
    every node/.style={circle, draw, minimum size=8mm, inner sep=1pt, font=\sffamily},
    lbl/.style={draw=none, minimum size=0, inner sep=1pt, font=\small\sffamily}]
  \node (a) at (0, 0)  {$a$};
  \node (b) at (2, 0)  {$b$};
  \node (c) at (4, 0)  {$c$};
  \node (d) at (6, 0)  {$d$};
  \node (e) at (8, 0)  {$e$};
  \node (f) at (10, 0) {$f$};
  \draw[->] (a) -- (b);
  \draw[->] (a) to[bend right=40] (c);
  \draw[->] (b) -- (d);
  \draw[->] (b) to[bend left=40] (e);
  \draw[->] (c) to[bend right=40] (e);
  \draw[->] (d) to[bend left=40] (f);
  \draw[->] (e) -- (f);
\end{tikzpicture}
</script>

The algorithm runs DFS and assigns each vertex a position equal to the order in which it *finishes* (i.e., after all its descendants have been visited). The first vertex to finish gets position 1, and so on. Vertices with higher positions come first in the topological order.

```julia
visited    = falses(n)
topo_order = Int[]

function visit(adj, s)
    visited[s] = true
    for (v, _) in adj[s]
        if !visited[v]
            visit(adj, v)
        end
    end
    pushfirst!(topo_order, s)   # prepend so earlier finishers end up at the back
end

for s in 1:n
    if !visited[s]
        visit(adj, s)
    end
end
```

**Correctness:** For any edge $u \to v$, when we visit $u$, if $v$ is not yet visited, we visit $v$ before finishing $u$, so $u$ will finished after $v$ and get a smaller position. 

If $v$ was already visited, then $u$ will finish after $v$ and get a smaller position. In either case, $u$ comes before $v$ in the topological order.

<div class="sectionlecturebox">
Detecting Cycles with Pre/Post Numbers
</div>

We classify edges of a directed graph using **pre** and **post** numbers: `pre[v]` is the time when we first visit $v$, and `post[v]` is the time when we finish visiting $v$.

```
time = 0

function visit(G, s):
    pre[s] = time;  time = time + 1
    visited[s] = true
    for each neighbor v of s:
        if not visited[v]:
            visit(G, v)
    post[s] = time;  time = time + 1
```

The pre/post intervals let us classify every edge $u \to v$:

| Edge type | Interval relationship |
|-----------|----------------------|
| **Tree edge** | $pre[u] < pre[v] < post[v] < post[u]$ |
| **Forward edge** | $pre[u] < pre[v] < post[v] < post[u]$ |
| **Back edge** | $pre[v] < pre[u] < post[u] < post[v]$ |
| **Cross edge** | $pre[v] < post[v] < pre[u] < post[u]$ |

A back edge $u \to v$ satisfies $post[u] < post[v]$.

**Claim:** A directed graph has a cycle if and only if DFS finds a back edge.

**Proof:** ($\Rightarrow$) Suppose there is a cycle $v_1 \to v_2 \to \cdots \to v_k \to v_1$. Assume we visit $v_1$ first among these. Since there is a path from $v_1$ to $v_k$, we visit $v_k$ before finishing $v_1$, so $post[v_k] < post[v_1]$. Therefore $v_k \to v_1$ is a back edge.

($\Leftarrow$) If there is a back edge $v \to u$, then $u$ is an ancestor of $v$ in the DFS tree, so there is a path from $u$ to $v$ in the graph. Together with $v \to u$, this forms a cycle. $\square$

To detect cycles, run DFS with pre/post numbers and then check:

```
for each edge u → v:
    if post[u] < post[v]:
        return "cycle found"
return "no cycle"
```

The overall running time is $O(n + m)$.


```julia
function dfs_prepost(n, adj)
    visited = falses(n)
    pre  = zeros(Int, n)
    post = zeros(Int, n)
    time = Ref(0)

    function visit(s)
        visited[s] = true
        pre[s] = time[]; time[] += 1
        for v in adj[s]
            if !visited[v]
                visit(v)
            end
        end
        post[s] = time[]; time[] += 1
    end

    for s in 1:n
        if !visited[s]
            visit(s)
        end
    end

    return pre, post
end

function has_cycle(n, adj)
    pre, post = dfs_prepost(n, adj)
    for u in 1:n
        for v in adj[u]
            if post[u] < post[v]
                return true
            end
        end
    end
    return false
end
```
