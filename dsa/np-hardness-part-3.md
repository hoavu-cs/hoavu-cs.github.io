---
title: NP-Hardness Part 3 (Clique, Vertex Cover)
parent: DSA
nav_order: 18
layout: default
permalink: /dsa/np-hardness-part-3/
---

# NP-Hardness Part 3 (Clique, Vertex Cover)

<div class="sectionlecturebox">
Clique
</div>

**Definition (Clique).** A **clique** in a graph $G = (V, E)$ is a set $S \subseteq V$ such that every pair of vertices in $S$ is connected by an edge. Equivalently, the subgraph induced by $S$ is a complete graph $K_{\lvert S \rvert}$. The **Clique** decision problem asks: given $G$ and an integer $k$, does $G$ contain a clique of size $\ge k$?

Clique is in NP: given a set $S$ as a certificate, verify $\lvert S \rvert \ge k$ and check all $\binom{\lvert S \rvert}{2}$ pairs for edges in $O(k^2)$ time.

<div class="sectionlecturebox">
Reduction: Independent Set $\le_p$ Clique 
</div>

**Complement graph.** The **complement** $\bar{G}$ of $G = (V, E)$ has vertex set $V$ and edge set $\bar{E} = \binom{V}{2} \setminus E$: an edge is present in $\bar{G}$ iff it is absent in $G$. Computing $\bar{G}$ from $G$ takes $O(V^2)$ time.

**Key observation.** $S \subseteq V$ is an independent set in $G$ $\iff$ $S$ is a clique in $\bar{G}$.

*Proof.* $S$ is an IS in $G$ $\iff$ for all distinct $u,v \in S$, $(u,v) \notin E$ $\iff$ for all distinct $u,v \in S$, $(u,v) \in \bar{E}$ $\iff$ $S$ is a clique in $\bar{G}$. $\square$

**Theorem.** Clique is NP-complete.

**Proof.** Clique $\in$ NP (shown above). For NP-hardness: given any instance $(G, k)$ of Independent Set, output $(\bar{G}, k)$ as the Clique instance. This reduction runs in $O(V^2)$ time. By the key observation, $G$ has an IS of size $k$ $\iff$ $\bar{G}$ has a clique of size $k$. Since Independent Set is NP-complete, so is Clique. $\square$

**Example.** The graph $G$ below (left) has edges $\{1\text{-}2,\,2\text{-}3,\,3\text{-}4,\,4\text{-}5,\,2\text{-}4,\,1\text{-}4\}$. The set $\{1,3,5\}$ (yellow) is an IS of size 3: none of those pairs share an edge. In the complement $\bar{G}$ (right), the missing edges $\{1\text{-}3,\,1\text{-}5,\,3\text{-}5\}$ are now present, making $\{1,3,5\}$ a 3-clique.

<script type="text/tikz">
\begin{tikzpicture}[thick,
    nd/.style={circle, draw, minimum size=10mm, inner sep=1pt, font=\small\sffamily},
    hi/.style={circle, draw, minimum size=10mm, inner sep=1pt, font=\small\sffamily, fill=yellow!60}]

  % Left: G
  \begin{scope}[xshift=0cm]
    \node[hi] (v1) at (0,    2.0) {1};
    \node[nd] (v2) at (1.9,  0.6) {2};
    \node[hi] (v3) at (1.2, -1.6) {3};
    \node[nd] (v4) at (-1.2,-1.6) {4};
    \node[hi] (v5) at (-1.9, 0.6) {5};
    \draw (v1)--(v2);
    \draw (v2)--(v3);
    \draw (v3)--(v4);
    \draw (v4)--(v5);
    \draw (v2)--(v4);
    \draw (v1)--(v4);
    \node[font=\sffamily] at (0,-2.8) {};
  \end{scope}

  % Right: G-bar
  \begin{scope}[xshift=6cm]
    \node[hi] (u1) at (0,    2.0) {1};
    \node[nd] (u2) at (1.9,  0.6) {2};
    \node[hi] (u3) at (1.2, -1.6) {3};
    \node[nd] (u4) at (-1.2,-1.6) {4};
    \node[hi] (u5) at (-1.9, 0.6) {5};
    \draw[blue!70, very thick] (u1)--(u3);
    \draw[blue!70, very thick] (u1)--(u5);
    \draw                      (u2)--(u5);
    \draw[blue!70, very thick] (u3)--(u5);
    \node[font=\sffamily] at (0,-2.8) {};
  \end{scope}

\end{tikzpicture}
</script>

The three thick blue edges form the clique $\{1,3,5\}$ in $\bar{G}$, corresponding exactly to the three non-edges of the IS in $G$.

<div class="sectionlecturebox">
Vertex Cover
</div>

**Definition (Vertex Cover).** A **vertex cover** of $G = (V, E)$ is a set $S \subseteq V$ such that every edge has at least one endpoint in $S$:

$$\forall\,(u,v) \in E,\quad u \in S \;\text{or}\; v \in S.$$

The **Vertex Cover** decision problem asks: given $G$ and an integer $k$, does $G$ have a vertex cover of size $\le k$?

Vertex Cover is in NP: given a set $S$ as a certificate, verify $\lvert S \rvert \le k$ and scan all edges in $O(V + E)$ time.

<div class="sectionlecturebox">
Reduction: Independent Set $\le_p$ Vertex Cover
</div>

**Key observation.** Let $n = \lvert V \rvert$. A set $S \subseteq V$ is an independent set in $G$ $\iff$ $V \setminus S$ is a vertex cover of $G$.

*Proof.*

$(\Rightarrow)$ Let $S$ be an IS. For any edge $(u,v) \in E$, since $S$ is independent, $u$ and $v$ are not both in $S$, so at least one belongs to $V \setminus S$. Hence $V \setminus S$ covers every edge.

$(\Leftarrow)$ Let $C = V \setminus S$ be a vertex cover. If some $u,v \in S$ had $(u,v) \in E$, then neither endpoint would be in $C$, contradicting that $C$ is a cover. So $S$ is independent. $\square$

**Theorem.** Vertex Cover is NP-complete.

**Proof.** Vertex Cover $\in$ NP (shown above). For NP-hardness: given any instance $(G, k)$ of Independent Set (with $n = \lvert V \rvert$), output $(G,\, n - k)$ as the Vertex Cover instance — the same graph, target size $n - k$. This reduction runs in $O(1)$ additional time.

By the key observation, $G$ has an IS $S$ of size $k$ $\iff$ $V \setminus S$ is a vertex cover of size $n - k$ $\iff$ $G$ has a vertex cover of size $n - k$. Since Independent Set is NP-complete, so is Vertex Cover. $\square$

**Example.** The graph below has $5$ vertices and edges $\{1\text{-}2,\,1\text{-}3,\,2\text{-}4,\,3\text{-}4,\,4\text{-}5\}$. The vertex cover $\{1,4\}$ (red) has size $2$ and touches every edge. The complementary set $\{2,3,5\}$ (yellow) is an IS of size $3$: no two of them are adjacent.

<script type="text/tikz">
\begin{tikzpicture}[thick,
    nd/.style={circle, draw, minimum size=10mm, inner sep=1pt, font=\small\sffamily},
    vc/.style={circle, draw, minimum size=10mm, inner sep=1pt, font=\small\sffamily, fill=red!40},
    is/.style={circle, draw, minimum size=10mm, inner sep=1pt, font=\small\sffamily, fill=yellow!60}]

  \node[vc] (v1) at ( 0,    2.0) {1};
  \node[is] (v2) at (-1.5,  0.0) {2};
  \node[is] (v3) at ( 1.5,  0.0) {3};
  \node[vc] (v4) at ( 0,   -1.5) {4};
  \node[is] (v5) at ( 0,   -3.0) {5};

  \draw (v1)--(v2);
  \draw (v1)--(v3);
  \draw (v2)--(v4);
  \draw (v3)--(v4);
  \draw (v4)--(v5);

  \node[font=\sffamily] at (0, -4.0) {};

\end{tikzpicture}
</script>

<div class="sectionlecturebox">
Summary of Reductions So Far
</div>

The reductions form a chain rooted at 3-SAT (Cook-Levin):

<script type="text/tikz">
\usetikzlibrary{positioning}
\begin{tikzpicture}[
    node distance=1.4cm and 2.4cm,
    box/.style={draw, rounded corners, minimum width=2.8cm, minimum height=0.75cm,
                align=center, font=\sffamily\small},
    arr/.style={->, >=stealth, thick}]

  \node[box] (sat)    {3-SAT};
  \node[box] (is)     [right=of sat]         {Independent Set};
  \node[box] (clique) [above right=of is]    {Clique};
  \node[box] (vc)     [below right=of is]    {Vertex Cover};
  \node[box] (ilp)    [below=of sat]         {ILP};

  \draw[arr] (sat) -- node[above, font=\scriptsize\sffamily] {} (is);
  \draw[arr] (sat) -- node[left,  font=\scriptsize\sffamily] {} (ilp);
  \draw[arr] (is)  -- node[above, font=\scriptsize\sffamily] {} (clique);
  \draw[arr] (is)  -- node[below, font=\scriptsize\sffamily] {} (vc);

\end{tikzpicture}
</script>

