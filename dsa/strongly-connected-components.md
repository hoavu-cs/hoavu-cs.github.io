---
title: Strongly Connected Components (SCC)
parent: DSA
nav_order: 11
layout: default
permalink: /dsa/strongly-connected-components/
---

# Strongly Connected Components (SCC)

A **strongly connected component (SCC)** of a directed graph is a maximal set of vertices $S \subseteq V$ such that for every pair of vertices $u, v \in S$, there is a directed path from $u$ to $v$ and from $v$ to $u$.

We want to compute these **strongly connected components** of a directed graph.

<script type="text/tikz">
\begin{tikzpicture}[->, >=stealth, thick,
    every node/.style={circle, draw, minimum size=8mm, inner sep=1pt, font=\sffamily},
    lbl/.style={draw=none, fill=none, font=\small\sffamily}]
  \node[fill=blue!25]   (1)  at (0,    1.5)   {1};
  \node[fill=blue!25]   (2)  at (1.5,  1.0)   {2};
  \node[fill=blue!25]   (3)  at (1.5, -1.0)   {3};
  \node[fill=blue!25]   (4)  at (0,    -1.5)  {4};
  \node[fill=blue!25]   (5)  at (-1.5, 0)     {5};
  \node[fill=green!30]  (6)  at (4,    1.2)   {6};
  \node[fill=green!30]  (7)  at (6.5,  1.8)   {7};
  \node[fill=green!30]  (8)  at (6.5, -1.8)   {8};
  \node[fill=green!30]  (9)  at (4,    -1.2)  {9};
  \node[fill=orange!35] (10) at (10.5, 0.8)   {10};
  \node[fill=orange!35] (11) at (10.5, -0.8)  {11};
  \node[fill=red!25]    (12) at (15,   0)     {12};
  \node[fill=red!25]    (13) at (16,   1)     {13};
  \node[fill=red!25]    (14) at (16,  -1)     {14};
  \draw[->] (1) -- (2);
  \draw[->] (2) -- (3);
  \draw[->] (3) -- (4);
  \draw[->] (4) -- (2);
  \draw[->] (4) -- (5);
  \draw[->] (5) -- (1);
  \draw[->] (6) -- (7);
  \draw[->] (7) -- (8);
  \draw[->] (8) -- (6);
  \draw[->] (8) -- (9);
  \draw[->] (9) -- (6);
  \draw[->] (10) to[bend left=25] (11);
  \draw[->] (11) to[bend left=25] (10);
  \draw[->] (12) to[bend left=25] (13);
  \draw[->] (13) to[bend left=25] (14);
  \draw[->] (14) to[bend left=25] (12);
  \draw[->] (5) to[bend right=20] (6);
  \draw[->] (9) -- (10);
  \draw[->] (11) to[bend left=20] (13);
  \draw[->] (2) -- (9);
  \draw[->] (7) to[bend left=40] (12);
  \draw[dashed, rounded corners=10pt] (-2.7,-2.3) rectangle (2.7,2.3);
  \draw[dashed, rounded corners=10pt] (2.8,-2.3) rectangle (7.9,2.3);
  \draw[dashed, rounded corners=10pt] (9.3,-1.7) rectangle (11.9,1.7);
  \draw[dashed, rounded corners=10pt] (13.8,-1.8) rectangle (17.3,1.8);
  \node[lbl] at (-0.6,  2.8) {SCC $A$};
  \node[lbl] at (5.4,   2.8) {SCC $B$};
  \node[lbl] at (10.55, 2.2)  {SCC $C$};
  \node[lbl] at (15.5,  2.2)  {SCC $D$};
\end{tikzpicture}
</script>

---

Recall that a directed acyclic graph (DAG) is a directed graph with no directed cycles.

**Observation 1**: If we contract each SCC into a single vertex, the resulting **contracted graph** is a DAG.

**Proof:** Suppose for contradiction the contracted graph has a directed cycle $X_1 \to X_2 \to \cdots \to X_k \to X_1$. Then every vertex in $X_1$ can reach every vertex in $X_k$ (through $X_2, \ldots, X_{k-1}$), and vice versa. This makes $X_1 \cup \cdots \cup X_k$ strongly connected, contradicting the maximality of each $X_i$ as an SCC.

The contracted graph of the example above is:

<script type="text/tikz">
\begin{tikzpicture}[->, >=stealth, thick]
  \node[rectangle, draw, rounded corners=3pt, fill=blue!25,
        minimum width=1.6cm, minimum height=0.7cm, font=\sffamily, inner sep=4pt] (A) at (0, 0) {$A$};
  \node[rectangle, draw, rounded corners=3pt, fill=green!30,
        minimum width=1.6cm, minimum height=0.7cm, font=\sffamily, inner sep=4pt] (B) at (3, 0) {$B$};
  \node[rectangle, draw, rounded corners=3pt, fill=orange!35,
        minimum width=1.6cm, minimum height=0.7cm, font=\sffamily, inner sep=4pt] (C) at (6, 0) {$C$};
  \node[rectangle, draw, rounded corners=3pt, fill=red!25,
        minimum width=1.6cm, minimum height=0.7cm, font=\sffamily, inner sep=4pt] (D) at (9, 0) {$D$};
  \draw[->] (A) -- (B);
  \draw[->] (B) -- (C);
  \draw[->] (C) -- (D);
  \draw[->] (B) to[bend left=40] (D);
\end{tikzpicture}
</script>

The sink of the contracted graph is a component with no outgoing edges to other components in the contracted graph. The source of the contracted graph is a component with no incoming edges from other components in the contracted graph. Note that we might have more than one source or sink in the contracted graph.

For example, in the above, $D$ is a sink.

---

**Idea**: Identify a vertex in a sink SCC. Run DFS from that vertex which will only explore vertices in that sink SCC, allowing us to identify all vertices in that SCC. This is because there is no edge going out of a sink. Delete the vertices in that SCC from the graph and repeat the process on the remaining graph to identify all SCCs.

For example, if we run DFS from 13 in the example graph, we will visit 13, 14, and 12, which are exactly the vertices in the sink SCC $D$. Then we delete these vertices from the graph and repeat the process on the remaining graph to identify the other SCCs. The challenge is however how to efficiently find a vertex in a sink SCC without knowing the SCCs in advance.

---

**Observation 2:** If SCC $X$ is before SCC $Y$ in the contracted DAG (i.e., there is a path from $X$ to $Y$ in the contracted graph), then the maximum post number of any vertex in $X$ is greater than the maximum post number of any vertex in $Y$.

**Proof:** Consider a DFS traversal. There are two cases:

**Case 1: DFS enters $X$ before $Y$.** Since there is a path from $X$ to $Y$ in the contracted DAG, when DFS visits any vertex in $X$, it will eventually reach $Y$ (either directly or through intermediate components) before finishing that vertex. Therefore, all vertices in $Y$ are discovered and finished before any vertex in $X$ finishes. This means every vertex in $Y$ has a smaller post number than every vertex in $X$.

**Case 2: DFS enters $Y$ before $X$.** Since the contracted graph is a DAG with a path from $X$ to $Y$, there cannot be a path from $Y$ to $X$. If DFS starts in $Y$ and never reaches $X$ (which it can't, since no path exists from $Y$ to $X$), then $Y$ is fully explored before DFS ever visits $X$. In this case, all vertices in $Y$ finish before any vertex in $X$ is even discovered. Again, every vertex in $Y$ has a smaller post number than every vertex in $X$.

In both cases, we have $\max_{v \in X} \text{post}[v] > \max_{w \in Y} \text{post}[w]$.

---

If we run DFS on the above graph starting from vertex $1$ and at each step explore the next unvisited vertex in numerical order, the pre and post numbers of each vertex are as shown in the figure below:


<script type="text/tikz">
\begin{tikzpicture}[->, >=stealth, thick,
    every node/.style={circle, draw, minimum size=12mm, inner sep=2pt, font=\sffamily, align=center},
    lbl/.style={draw=none, fill=none, font=\small\sffamily}]
  \node[fill=blue!25]   (1)  at (0,    1.5)   {1\\[-3pt]{\tiny 1/28}};
  \node (2)  at (1.5,  1.0)   {2\\[-3pt]{\tiny 2/27}};
  \node (3)  at (1.5, -1.0)   {3\\[-3pt]{\tiny 3/26}};
  \node (4)  at (0,    -1.5)  {4\\[-3pt]{\tiny 4/25}};
  \node (5)  at (-1.5, 0)     {5\\[-3pt]{\tiny 5/24}};
  \node[fill=green!30]  (6)  at (4,    1.2)   {6\\[-3pt]{\tiny 6/23}};
  \node (7)  at (6.5,  1.8)   {7\\[-3pt]{\tiny 7/22}};
  \node (8)  at (6.5, -1.8)   {8\\[-3pt]{\tiny 8/21}};
  \node (9)  at (4,    -1.2)  {9\\[-3pt]{\tiny 9/20}};
  \node[fill=orange!35] (10) at (10.5, 0.8)   {10\\[-3pt]{\tiny 10/19}};
  \node (11) at (10.5, -0.8)  {11\\[-3pt]{\tiny 11/18}};
  \node (12) at (15,   0)     {12\\[-3pt]{\tiny 14/15}};
  \node[fill=red!25]    (13) at (16,   1)     {13\\[-3pt]{\tiny 12/17}};
  \node (14) at (16,  -1)     {14\\[-3pt]{\tiny 13/16}};
  % DFS tree edges (line width=3pt); non-tree edges use default thickness
  \draw[->, line width=3pt] (1) -- (2);
  \draw[->, line width=3pt] (2) -- (3);
  \draw[->, line width=3pt] (3) -- (4);
  \draw[->] (4) -- (2);
  \draw[->, line width=3pt] (4) -- (5);
  \draw[->] (5) -- (1);
  \draw[->, line width=3pt] (6) -- (7);
  \draw[->, line width=3pt] (7) -- (8);
  \draw[->] (8) -- (6);
  \draw[->, line width=3pt] (8) -- (9);
  \draw[->] (9) -- (6);
  \draw[->, line width=3pt] (10) to[bend left=25] (11);
  \draw[->] (11) to[bend left=25] (10);
  \draw[->] (12) to[bend left=25] (13);
  \draw[->, line width=3pt] (13) to[bend left=25] (14);
  \draw[->, line width=3pt] (14) to[bend left=25] (12);
  \draw[->, line width=3pt] (5) to[bend right=20] (6);
  \draw[->, line width=3pt] (9) -- (10);
  \draw[->, line width=3pt] (11) to[bend left=20] (13);
  \draw[->] (2) -- (9);
  \draw[->] (7) to[bend left=40] (12);
  \draw[dashed, rounded corners=10pt] (-2.7,-2.3) rectangle (2.7,2.3);
  \draw[dashed, rounded corners=10pt] (2.8,-2.6) rectangle (7.9,2.6);
  \draw[dashed, rounded corners=10pt] (9.3,-1.7) rectangle (11.9,1.7);
  \draw[dashed, rounded corners=10pt] (13.8,-1.8) rectangle (17.3,1.8);
  \node[lbl] at (-0.6,  2.8) {SCC $A$};
  \node[lbl] at (5.4,   3.1) {SCC $B$};
  \node[lbl] at (10.55, 2.2)  {SCC $C$};
  \node[lbl] at (15.5,  2.2)  {SCC $D$};
\end{tikzpicture}
</script>

---

This suggests that the vertex with the largest post number in a DFS of the original graph must lie in a source SCC of the contracted DAG. However, what we want is a vertex in a **sink** SCC of the contracted DAG. This is the third key observation.



**Observation 3:** If we reverse all edges in the original graph to get the transpose graph $G^T$, the SCCs stay the same. Furthermore, the sink SCCs of the original graph become source SCCs in $G^T$. 

---

This suggests the following algorithm:
1. Run DFS on $G$.
2. Run DFS on $G^T$ processing vertices in **decreasing** order of post numbers from step 1. Each DFS tree in this second pass is an SCC.

**Step 1:** DFS from vertex 1 (largest post number in $G$) on $G^T$ reaches only $\{1,2,3,4,5\}$ — SCC $A$ identified.

<script type="text/tikz">
\begin{tikzpicture}[->, >=stealth, thick,
    every node/.style={circle, draw, minimum size=8mm, inner sep=1pt, font=\sffamily},
    lbl/.style={draw=none, fill=none, font=\small\sffamily}]
  \node[fill=blue!25]  (1)  at (0,    1.5)   {1};
  \node[fill=blue!25]  (2)  at (1.5,  1.0)   {2};
  \node[fill=blue!25]  (3)  at (1.5, -1.0)   {3};
  \node[fill=blue!25]  (4)  at (0,    -1.5)  {4};
  \node[fill=blue!25]  (5)  at (-1.5, 0)     {5};
  \node (6)  at (4,    1.2)   {6};
  \node (7)  at (6.5,  1.8)   {7};
  \node (8)  at (6.5, -1.8)   {8};
  \node (9)  at (4,    -1.2)  {9};
  \node (10) at (10.5, 0.8)   {10};
  \node (11) at (10.5, -0.8)  {11};
  \node (12) at (15,   0)     {12};
  \node (13) at (16,   1)     {13};
  \node (14) at (16,  -1)     {14};
  \draw[->] (2) -- (1);
  \draw[->] (3) -- (2);
  \draw[->] (4) -- (3);
  \draw[->] (2) -- (4);
  \draw[->] (5) -- (4);
  \draw[->] (1) -- (5);
  \draw[->] (7) -- (6);
  \draw[->] (8) -- (7);
  \draw[->] (6) -- (8);
  \draw[->] (9) -- (8);
  \draw[->] (6) -- (9);
  \draw[->] (11) to[bend right=25] (10);
  \draw[->] (10) to[bend right=25] (11);
  \draw[->] (13) to[bend right=25] (12);
  \draw[->] (14) to[bend right=25] (13);
  \draw[->] (12) to[bend right=25] (14);
  \draw[->] (6) to[bend left=20] (5);
  \draw[->] (10) -- (9);
  \draw[->] (13) to[bend right=20] (11);
  \draw[->] (9) -- (2);
  \draw[->] (12) to[bend right=40] (7);
  \draw[dashed, rounded corners=10pt] (-2.7,-2.3) rectangle (2.7,2.3);
  \draw[dashed, rounded corners=10pt] (2.8,-2.3) rectangle (7.9,2.3);
  \draw[dashed, rounded corners=10pt] (9.3,-1.7) rectangle (11.9,1.7);
  \draw[dashed, rounded corners=10pt] (13.8,-1.8) rectangle (17.3,1.8);
  \node[lbl] at (-0.6,  2.8) {SCC $A$};
  \node[lbl] at (5.4,   2.8) {SCC $B$};
  \node[lbl] at (10.55, 2.2)  {SCC $C$};
  \node[lbl] at (15.5,  2.2)  {SCC $D$};
\end{tikzpicture}
</script>

**Step 2:** Remove SCC $A$. DFS from vertex 6 (next largest unvisited post number) reaches $\{6,7,8,9\}$ — SCC $B$ identified.

<script type="text/tikz">
\begin{tikzpicture}[->, >=stealth, thick,
    every node/.style={circle, draw, minimum size=8mm, inner sep=1pt, font=\sffamily},
    lbl/.style={draw=none, fill=none, font=\small\sffamily}]
  \node[fill=green!30] (6)  at (4,    1.2)   {6};
  \node[fill=green!30] (7)  at (6.5,  1.8)   {7};
  \node[fill=green!30] (8)  at (6.5, -1.8)   {8};
  \node[fill=green!30] (9)  at (4,    -1.2)  {9};
  \node (10) at (10.5, 0.8)   {10};
  \node (11) at (10.5, -0.8)  {11};
  \node (12) at (15,   0)     {12};
  \node (13) at (16,   1)     {13};
  \node (14) at (16,  -1)     {14};
  \draw[->] (7) -- (6);
  \draw[->] (8) -- (7);
  \draw[->] (6) -- (8);
  \draw[->] (9) -- (8);
  \draw[->] (6) -- (9);
  \draw[->] (11) to[bend right=25] (10);
  \draw[->] (10) to[bend right=25] (11);
  \draw[->] (13) to[bend right=25] (12);
  \draw[->] (14) to[bend right=25] (13);
  \draw[->] (12) to[bend right=25] (14);
  \draw[->] (10) -- (9);
  \draw[->] (13) to[bend right=20] (11);
  \draw[->] (12) to[bend right=40] (7);
  \draw[dashed, rounded corners=10pt] (2.8,-2.3) rectangle (7.9,2.3);
  \draw[dashed, rounded corners=10pt] (9.3,-1.7) rectangle (11.9,1.7);
  \draw[dashed, rounded corners=10pt] (13.8,-1.8) rectangle (17.3,1.8);
  \node[lbl] at (5.4,   2.8) {SCC $B$};
  \node[lbl] at (10.55, 2.2)  {SCC $C$};
  \node[lbl] at (15.5,  2.2)  {SCC $D$};
\end{tikzpicture}
</script>

**Step 3:** Remove SCC $B$. DFS from vertex 10 reaches $\{10,11\}$ — SCC $C$ identified.

<script type="text/tikz">
\begin{tikzpicture}[->, >=stealth, thick,
    every node/.style={circle, draw, minimum size=8mm, inner sep=1pt, font=\sffamily},
    lbl/.style={draw=none, fill=none, font=\small\sffamily}]
  \node[fill=orange!35] (10) at (10.5, 0.8)   {10};
  \node[fill=orange!35] (11) at (10.5, -0.8)  {11};
  \node (12) at (15,   0)     {12};
  \node (13) at (16,   1)     {13};
  \node (14) at (16,  -1)     {14};
  \draw[->] (11) to[bend right=25] (10);
  \draw[->] (10) to[bend right=25] (11);
  \draw[->] (13) to[bend right=25] (12);
  \draw[->] (14) to[bend right=25] (13);
  \draw[->] (12) to[bend right=25] (14);
  \draw[->] (13) to[bend right=20] (11);
  \draw[dashed, rounded corners=10pt] (9.3,-1.7) rectangle (11.9,1.7);
  \draw[dashed, rounded corners=10pt] (13.8,-1.8) rectangle (17.3,1.8);
  \node[lbl] at (10.55, 2.2)  {SCC $C$};
  \node[lbl] at (15.5,  2.2)  {SCC $D$};
\end{tikzpicture}
</script>

**Step 4:** Remove SCC $C$. DFS from vertex 13 reaches $\{12,13,14\}$ — SCC $D$ identified.

<script type="text/tikz">
\begin{tikzpicture}[->, >=stealth, thick,
    every node/.style={circle, draw, minimum size=8mm, inner sep=1pt, font=\sffamily},
    lbl/.style={draw=none, fill=none, font=\small\sffamily}]
  \node[fill=red!25] (12) at (15,   0)     {12};
  \node[fill=red!25] (13) at (16,   1)     {13};
  \node[fill=red!25] (14) at (16,  -1)     {14};
  \draw[->] (13) to[bend right=25] (12);
  \draw[->] (14) to[bend right=25] (13);
  \draw[->] (12) to[bend right=25] (14);
  \draw[dashed, rounded corners=10pt] (13.8,-1.8) rectangle (17.3,1.8);
  \node[lbl] at (15.5,  2.2)  {SCC $D$};
\end{tikzpicture}
</script>

The algorithm involves two DFSs and constructing $G^T$, all of which take $O(V+E)$ time, so the overall time complexity of finding all strongly connected components is $O(V+E)$.

---

To be concrete, the Julia implementation is shown below:

```julia
function strongly_connected_components(n, adj)
    # Step 1: DFS on G to get post order
    visited = falses(n)
    post_order = Int[]

    function dfs1(v)
        visited[v] = true
        for w in adj[v]
            if !visited[w]
                dfs1(w)
            end
        end
        push!(post_order, v)
    end

    for v in 1:n
        if !visited[v]
            dfs1(v)
        end
    end

    # Step 2: Build transpose graph G^T
    adj_t = [Int[] for _ in 1:n]
    for u in 1:n
        for v in adj[u]
            push!(adj_t[v], u)
        end
    end

    # Step 3: DFS on G^T in decreasing post order
    fill!(visited, false)
    scc_id = zeros(Int, n)
    num_scc = 0

    function dfs2(v, id)
        visited[v] = true
        scc_id[v] = id
        for w in adj_t[v]
            if !visited[w]
                dfs2(w, id)
            end
        end
    end

    for v in reverse(post_order)
        if !visited[v]
            num_scc += 1
            dfs2(v, num_scc)
        end
    end

    return num_scc, scc_id
end
```