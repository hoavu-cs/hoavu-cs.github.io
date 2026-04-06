---
title: Breadth-First Search (BFS) and Dijkstra's Algorithm
parent: DSA
nav_order: 12
layout: default
permalink: /dsa/bfs-dijkstra/
---

# Breadth-First Search (BFS) and Dijkstra's Algorithm

**Breadth-First Search (BFS)** is a graph traversal algorithm that explores vertices level by level, starting from a source vertex. It visits all vertices at distance $d$ before visiting any vertex at distance $d+1$.

BFS is particularly useful for finding shortest paths in **unweighted** graphs, where all edges have equal weight.

## Breadth-First Search (BFS)

The BFS algorithm uses a **queue** to explore vertices in order of their distance from the source.

**Algorithm:**

```
1. Initialize: dist[v] = ∞ for all v, dist[source] = 0
2. Create queue Q, enqueue source
3. While Q is not empty:
   a. Dequeue vertex u
   b. For each neighbor v of u:
      i. If dist[v] = ∞:
         - dist[v] = dist[u] + 1
         - parent[v] = u
         - enqueue v
```

### Example

Consider the following unweighted graph:

<script type="text/tikz">
\begin{tikzpicture}[->, >=stealth, thick,
    every node/.style={circle, draw, minimum size=8mm, inner sep=1pt, font=\sffamily}]
  \node (1) at (0, 1.5)   {1};
  \node (2) at (1.5, 1.5) {2};
  \node (3) at (3, 1.5)   {3};
  \node (4) at (4.5, 1.5) {4};
  \node (5) at (0.75, 0)  {5};
  \node (6) at (2.25, 0)  {6};
  \node (7) at (3.75, 0)  {7};
  \draw[->] (1) -- (2);
  \draw[->] (1) -- (5);
  \draw[->] (2) -- (3);
  \draw[->] (2) -- (6);
  \draw[->] (3) -- (4);
  \draw[->] (3) -- (7);
  \draw[->] (5) -- (6);
  \draw[->] (6) -- (7);
  \draw[->] (5) to[bend right=50] (7);
\end{tikzpicture}
</script>

Running BFS from vertex 1 proceeds in waves, where each wave processes all vertices at the same distance. Here's how the algorithm evolves:

**Step 0:** Initialize with source vertex. Queue contains only vertex 1 at distance 0.

<script type="text/tikz">
\begin{tikzpicture}[->, >=stealth, thick,
    every node/.style={circle, draw, minimum size=8mm, inner sep=1pt, font=\sffamily},
    lbl/.style={draw=none, fill=none, font=\small\sffamily}]
  \node[fill=blue!25] (1) at (0, 1.5)   {1};
  \node (2) at (1.5, 1.5) {2};
  \node (3) at (3, 1.5)   {3};
  \node (4) at (4.5, 1.5) {4};
  \node (5) at (0.75, 0)  {5};
  \node (6) at (2.25, 0)  {6};
  \node (7) at (3.75, 0)  {7};
  \draw[->] (1) -- (2);
  \draw[->] (1) -- (5);
  \draw[->] (2) -- (3);
  \draw[->] (2) -- (6);
  \draw[->] (3) -- (4);
  \draw[->] (3) -- (7);
  \draw[->] (5) -- (6);
  \draw[->] (6) -- (7);
  \draw[->] (5) to[bend right=50] (7);
  \node[lbl] at (-0.6, 3) {Queue: [1]};
\end{tikzpicture}
</script>

**Step 1:** Process vertex 1. Discover neighbors 2 and 5 (distance 1). Queue now contains all vertices at distance 1.

<script type="text/tikz">
\begin{tikzpicture}[->, >=stealth, thick,
    every node/.style={circle, draw, minimum size=8mm, inner sep=1pt, font=\sffamily},
    lbl/.style={draw=none, fill=none, font=\small\sffamily}]
  \node[fill=blue!25] (1) at (0, 1.5)   {1};
  \node[fill=green!25] (2) at (1.5, 1.5) {2};
  \node (3) at (3, 1.5)   {3};
  \node (4) at (4.5, 1.5) {4};
  \node[fill=green!25] (5) at (0.75, 0)  {5};
  \node (6) at (2.25, 0)  {6};
  \node (7) at (3.75, 0)  {7};
  \draw[->] (1) -- (2);
  \draw[->] (1) -- (5);
  \draw[->] (2) -- (3);
  \draw[->] (2) -- (6);
  \draw[->] (3) -- (4);
  \draw[->] (3) -- (7);
  \draw[->] (5) -- (6);
  \draw[->] (6) -- (7);
  \draw[->] (5) to[bend right=50] (7);
  \node[lbl] at (1.1, 3) {Queue: [2, 5]};
\end{tikzpicture}
</script>

**Step 2:** Process vertices 2 and then 5 (distance 1). Queue now contains vertices 3, 6, and 7 (distance 2).

<script type="text/tikz">
\begin{tikzpicture}[->, >=stealth, thick,
    every node/.style={circle, draw, minimum size=8mm, inner sep=1pt, font=\sffamily},
    lbl/.style={draw=none, fill=none, font=\small\sffamily}]
  \node (1) at (0, 1.5)   {1};
  \node[fill=green!25] (2) at (1.5, 1.5) {2};
  \node[fill=red!25] (3) at (3, 1.5)   {3};
  \node (4) at (4.5, 1.5) {4};
  \node[fill=green!25] (5) at (0.75, 0)  {5};
  \node[fill=red!25] (6) at (2.25, 0)  {6};
  \node[fill=red!25] (7) at (3.75, 0)  {7};
  \draw[->] (1) -- (2);
  \draw[->] (1) -- (5);
  \draw[->] (2) -- (3);
  \draw[->] (2) -- (6);
  \draw[->] (3) -- (4);
  \draw[->] (3) -- (7);
  \draw[->] (5) -- (6);
  \draw[->] (6) -- (7);
  \draw[->] (5) to[bend right=50] (7);
  \node[lbl] at (2.5, 3) {Queue: [5, 3, 6]};
\end{tikzpicture}
</script>

**Step 3:** Process vertex 3, 6, and 7 (distance 3). Queue now contains vertex 4 (distance 4).

<script type="text/tikz">
\begin{tikzpicture}[->, >=stealth, thick,
    every node/.style={circle, draw, minimum size=8mm, inner sep=1pt, font=\sffamily},
    lbl/.style={draw=none, fill=none, font=\small\sffamily}]
  \node (1) at (0, 1.5)   {1};
  \node (2) at (1.5, 1.5) {2};
  \node[fill=red!25] (3) at (3, 1.5)   {3};
  \node[fill=yellow!50] (4) at (4.5, 1.5) {4};
  \node (5) at (0.75, 0)  {5};
  \node[fill=red!25] (6) at (2.25, 0)  {6};
  \node[fill=red!25]  (7) at (3.75, 0)  {7};
  \draw[->] (1) -- (2);
  \draw[->] (1) -- (5);
  \draw[->] (2) -- (3);
  \draw[->] (2) -- (6);
  \draw[->] (3) -- (4);
  \draw[->] (3) -- (7);
  \draw[->] (5) -- (6);
  \draw[->] (6) -- (7);
  \draw[->] (5) to[bend right=50] (7);
  \node[lbl] at (3.5, 3) {Queue: [4]};
\end{tikzpicture}
</script>


The shortest path distances from vertex 1 are:
$$\text{dist} = [0, 1, 2, 3, 1, 2, 3]$$

### Running Time

Each vertex is enqueued and dequeued at most once: $O(n)$. For each vertex, we iterate over its neighbors, which totals $O(m)$ across all vertices. The overall running time is $O(n + m)$.

### Julia Implementation

```julia
function bfs(n, adj, source)
    dist = fill(Inf, n)
    parent = zeros(Int, n)
    dist[source] = 0
    
    queue = Int[source]
    head = 1
    
    while head <= length(queue)
        u = queue[head]
        head += 1
        
        for v in adj[u]
            if dist[v] == Inf
                dist[v] = dist[u] + 1
                parent[v] = u
                push!(queue, v)
            end
        end
    end
    
    return dist, parent
end
```

### Shortest Path Reconstruction

The shortest paths from a source form a **shortest-path tree** rooted at the source. This is because if the shortest path from $s$ to $v$ goes through $u$, then the prefix of that path from $s$ to $u$ must also be a shortest path from $s$ to $u$ for if there is a shorter path from $s$ to $u$, then concatenating that shorter path with the edge from $u$ to $v$ would give a path from $s$ to $v$ shorter than the supposed shortest path, which is a contradiction.

The shortest-path tree for our BFS example (with source vertex 1) consists of the parent edges:

<script type="text/tikz">
\begin{tikzpicture}[->, >=stealth, thick,
    every node/.style={circle, draw, minimum size=8mm, inner sep=1pt, font=\sffamily}]
  \node (1) at (0, 1.5)   {1};
  \node (2) at (1.5, 1.5) {2};
  \node (3) at (3, 1.5)   {3};
  \node (4) at (4.5, 1.5) {4};
  \node (5) at (0.75, 0)  {5};
  \node (6) at (2.25, 0)  {6};
  \node (7) at (3.75, 0)  {7};
  \draw[->, thick, blue] (1) -- (2);
  \draw[->, thick, blue] (1) -- (5);
  \draw[->, thick, blue] (2) -- (3);
  \draw[->, thick, blue] (2) -- (6);
  \draw[->, thick, blue] (3) -- (4);
  \draw[->, thick, blue] (5) to[bend right=50] (7);
  \node[draw=none, fill=none, font=\small\sffamily] at (2.25, -1) {Shortest-Path Tree};
\end{tikzpicture}
</script>

The tree contains only the edges used to discover each vertex for the first time:
- $1 \to 2$ (dist[2] = 1, parent[2] = 1)
- $1 \to 5$ (dist[5] = 1, parent[5] = 1)
- $2 \to 3$ (dist[3] = 2, parent[3] = 2)
- $2 \to 6$ (dist[6] = 2, parent[6] = 2)
- $5 \to 7$ (dist[7] = 3, parent[7] = 5)
- $3 \to 4$ (dist[4] = 3, parent[4] = 3)

Note that edges $(3,7)$, $(5,6)$, $(6,7)$ are **not** in the tree because those vertices were already discovered via other paths.

**Example:** Reconstruct the shortest path from vertex 1 to vertex 4 in the BFS example.

After running BFS, the parent array is:
```
parent = [0, 1, 1, 2, 5, 2, 5]
         1  2  3  4  5  6  7  (vertex indices)
```

**Step 1:** Start at target vertex 4.

<script type="text/tikz">
\begin{tikzpicture}[->, >=stealth, thick,
    every node/.style={circle, draw, minimum size=8mm, inner sep=1pt, font=\sffamily},
    lbl/.style={draw=none, fill=none, font=\small\sffamily}]
  \node (1) at (0, 1.5)   {1};
  \node (2) at (1.5, 1.5) {2};
  \node (3) at (3, 1.5)   {3};
  \node[fill=red!25] (4) at (4.5, 1.5) {4};
  \node (5) at (0.75, 0)  {5};
  \node (6) at (2.25, 0)  {6};
  \node (7) at (3.75, 0)  {7};
  \draw[->] (1) -- (2);
  \draw[->] (1) -- (5);
  \draw[->] (2) -- (3);
  \draw[->] (2) -- (6);
  \draw[->] (3) -- (4);
  \draw[->] (3) -- (7);
  \draw[->] (5) -- (6);
  \draw[->] (6) -- (7);
  \draw[->] (5) to[bend right=50] (7);
  \node[lbl] at (5, 2) {parent[4] = 2}
  \node[lbl] at (5, 2.5) {path = [4]}
\end{tikzpicture}
</script>

**Step 2:** Move to parent of 4, which is vertex 2.

<script type="text/tikz">
\begin{tikzpicture}[->, >=stealth, thick,
    every node/.style={circle, draw, minimum size=8mm, inner sep=1pt, font=\sffamily},
    lbl/.style={draw=none, fill=none, font=\small\sffamily}]
  \node (1) at (0, 1.5)   {1};
  \node[fill=red!25] (2) at (1.5, 1.5) {2};
  \node (3) at (3, 1.5)   {3};
  \node (4) at (4.5, 1.5) {4};
  \node (5) at (0.75, 0)  {5};
  \node (6) at (2.25, 0)  {6};
  \node (7) at (3.75, 0)  {7};
  \draw[->] (1) -- (2);
  \draw[->] (1) -- (5);
  \draw[->] (2) -- (3);
  \draw[->] (2) -- (6);
  \draw[->] (3) -- (4);
  \draw[->] (3) -- (7);
  \draw[->] (5) -- (6);
  \draw[->] (6) -- (7);
  \draw[->] (5) to[bend right=50] (7);
  \node[lbl] at (5, 2) {parent[2] = 1}
  \node[lbl] at (5, 2.5) {path = [2, 4]}
\end{tikzpicture}
</script>

**Step 3:** Move to parent of 2, which is vertex 1 (the source).

<script type="text/tikz">
\begin{tikzpicture}[->, >=stealth, thick,
    every node/.style={circle, draw, minimum size=8mm, inner sep=1pt, font=\sffamily},
    lbl/.style={draw=none, fill=none, font=\small\sffamily}]
  \node[fill=red!25] (1) at (0, 1.5)   {1};
  \node (2) at (1.5, 1.5) {2};
  \node (3) at (3, 1.5)   {3};
  \node (4) at (4.5, 1.5) {4};
  \node (5) at (0.75, 0)  {5};
  \node (6) at (2.25, 0)  {6};
  \node (7) at (3.75, 0)  {7};
  \draw[->] (1) -- (2);
  \draw[->] (1) -- (5);
  \draw[->] (2) -- (3);
  \draw[->] (2) -- (6);
  \draw[->] (3) -- (4);
  \draw[->] (3) -- (7);
  \draw[->] (5) -- (6);
  \draw[->] (6) -- (7);
  \draw[->] (5) to[bend right=50] (7);
  \node[lbl] at (-1, 2) {parent[1] = 0 (source)}
  \node[lbl] at (-1, 2.5) {path = [1, 2, 4]}
\end{tikzpicture}
</script>

The shortest path from vertex 1 to vertex 4 is: **1 → 2 → 4**

```julia
function reconstruct_path(parent, source, target)
    if parent[target] == 0 && target != source
        return []  # No path exists
    end
    
    path = []
    current = target
    while current != 0
        pushfirst!(path, current)
        current = parent[current]
    end
    
    return path
end
```
---
### Running Time of BFS

Note that we push each vertex to the queue at most once when it is first discovered in BFS then it is marked as visited and never enqueued again. When we push a vertex to the queue, we process each of its outgoing edges to discover its neighbors and enqueue any that have not yet been visited. Hence, each edge is processed twice (in undirected graphs) or once (in directed graphs). The running time of BFS is therefore $O(V + E)$.

---