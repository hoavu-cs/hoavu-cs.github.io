---
title: NP-Hardness Part 1 (Decision Problems, P, Reductions, NP)
parent: DSA
nav_order: 16
layout: default
permalink: /dsa/np-hardness-part-1/
---

# NP-Hardness Part 1 (Decision Problems, P, Reductions, NP)

<div class="sectionlecturebox">
Decision Problems
</div>

So far we have studied the design and analysis of several algorithms. This part of the course will focus on when a problem is considered hard and unlikely to have an efficient algorithm.

**Definition (Decision Problem).** A <em>decision problem</em> is a computational problem whose output is either **yes** or **no**.


**Examples.**

- **Graph Coloring:** Given a graph $G$ and an integer $k$, can the vertices of $G$ be colored with at most $k$ colors such that no two adjacent vertices share the same color?
- **Hamiltonian Cycle:** Given a graph $G$, does $G$ contain a cycle that visits every vertex exactly once?
- **Subset Sum:** Given a set of integers $S$ and a target $t$, does there exist a subset of $S$ whose elements sum to exactly $t$?

Many optimization problems have a natural decision version. For instance, "find the shortest path" becomes "does a path of length at most $k$ exist?" Studying the decision version is without loss of generality in a complexity-theoretic sense: if the optimization problem is hard, so is its decision version, and vice versa.

<div class="sectionlecturebox">
Class P (Polynomial Time)
</div>

We say an algorithm runs in **polynomial time** if its worst-case running time is $O(n^c)$ for some constant $c$, where $n$ is the size of the input. Polynomial-time algorithms are considered efficient; exponential-time algorithms (e.g., $O(2^n)$) are considered intractable for large inputs.


**Definition**: $\mathbf{P}$ is the class of all decision problems that can be <em>solved</em> in polynomial time.


**Examples of problems in P.**

- **Shortest Path:** Does a path of length at most $k$ exist between $s$ and $t$?. If the edges have non-negative lengths, use Dijkstra's algorithm which runs in $O((V+E) \log V)$ time. Otherwise, use Bellman-Ford algorithm which runs in $O(VE)$ time. Both are polynomial.
- **Strongly connected component**: Given a directed graph $G$ and an integer $k$, does $G$ have at most $k$ strongly connected components? We can use Depth-first-search to count the number of strongly connected components in $O(V+E)$ time.

<div class="sectionlecturebox">
Reductions
</div>

A central idea in complexity theory is the notion of **reducing** one problem to another. Informally, problem $A$ reduces to problem $B$ if we can solve $A$ by using a solver for $B$ as a black box.


**Definition (Polynomial-Time Reduction).** We say problem $A$ <em>polynomial-time reduces</em> to problem $B$, written $A \le_p B$, if there exists a **polynomial-time** algorithm $f$ such that for every input $x$, the algorithm $f$ computes an instance $f(x)$ of $B$ where $x$ is a yes-instance if and only if $f(x)$ is a yes-instance. The algorithm $f$ is called the <em>reduction</em>.


In other words, we transform any instance of $A$ into an instance of $B$ in polynomial time, preserving the yes/no answer.

#### Example: Scheduling to Graph Coloring

**Scheduling problem.** We have $n$ tasks and $k$ time slots. Two tasks **conflict** if they cannot be scheduled in the same time slot (e.g., they share a resource or overlap). Given the conflict structure and a number $k$, can we assign every task to one of $k$ time slots such that no two conflicting tasks share a slot?

**Graph Coloring problem.** Given a graph $G = (V, E)$ and an integer $k$, can we assign each vertex a color from $\{1, \ldots, k\}$ such that no two adjacent vertices share the same color?

**Reduction $\text{Scheduling} \le_p \text{Graph Coloring}$.** Given a scheduling instance $(T, \text{conflicts}, k)$, construct a graph $G$ as follows:

- Create one vertex $v_i$ for each task $t_i$.
- Add an edge $(v_i, v_j)$ for every pair of conflicting tasks $t_i$ and $t_j$.
- Use the same integer $k$.

This construction takes $O(n^2)$ time (polynomial). Now observe:

- If we can schedule the tasks into $k$ slots with no conflicts, then assigning each vertex the color equal to its slot gives a valid $k$-coloring of $G$.
- Conversely, if $G$ has a valid $k$-coloring, assigning each task to the time slot corresponding to its vertex's color gives a valid schedule.

Hence, the scheduling instance is a **yes**-instance if and only if the graph coloring instance is a **yes**-instance. This completes the reduction. $\square$

<p align="center">
<script type="text/tikz">
\begin{tikzpicture}[
  node/.style={circle, draw=black, thick, minimum size=1cm, font=\small\bfseries},
  >=stealth, thick
]

% Left: Scheduling instance as conflict pairs
\node at (1.5, 3.8) {Scheduling instance};
\node at (1.5, 2.8) {Tasks: $t_1  t_2  t_3  t_4$};
\node at (1.5, 2.1) {Conflicts:};
\node at (1.5, 1.5) {$(t_1  t_2)$};
\node at (1.5, 0.9) {$(t_1  t_3)$};
\node at (1.5, 0.3) {$(t_2  t_3)$};
\node at (1.5, -0.3) {$(t_3  t_4)$};
\node at (1.5, -1.0) {$k = 3$ slots};

% Reduction arrow
\draw[->, very thick] (4.2, 1.4) -- (5.8, 1.4)
  node[midway, above, font=\small] {$f$};

% Right: Graph coloring instance
\node[node, fill=red!30]   (v1) at (7.0,  1.5) {$v_1$};
\node[node, fill=blue!30]  (v2) at (8.5,  3.0) {$v_2$};
\node[node, fill=green!50] (v3) at (10.0, 1.5) {$v_3$};
\node[node, fill=red!30]   (v4) at (8.5,  0.0) {$v_4$};
\draw (v1) -- (v2);
\draw (v1) -- (v3);
\draw (v2) -- (v3);
\draw (v3) -- (v4);
\node[font=\small, above] at (8.5, 3.8) {Graph coloring ($k=3$)};

\end{tikzpicture}
</script>
</p>


**Claim.** If $A \le_p B$ and $B \in \mathbf{P}$, then $A \in \mathbf{P}$.

**Proof.** Suppose $A \le_p B$ via a polynomial-time reduction $f$, and suppose $B$ has a polynomial-time algorithm $\mathcal{A}_B$.

Given an instance $x$ of $A$, we solve it as follows:

1. Compute $f(x)$ in polynomial time.
2. Run $\mathcal{A}_B$ on $f(x)$ and return its answer.

Step 1 takes $O(n^c)$ time for some constant $c$, and the output $f(x)$ has size at most $O(n^c)$ (a polynomial-time computation can write at most polynomially many output bits). Step 2 runs in time polynomial in $\lvert f(x) \rvert$, which is $O((n^c)^d) = O(n^{cd})$ for some constant $d$. The total running time is polynomial in $n$. Since the answer is correct by the definition of the reduction, $A \in \mathbf{P}$. $\square$

**Implication.** If there is an efficient algorithm for $B$, then there is an efficient algorithm for $A$. Equivalently, if $A \le_p B$ and $A$ is hard, then $B$ is also hard.

<div class="sectionlecturebox">
Class NP
</div>

Consider the Graph Coloring problem. We don't know how to solve it in polynomial time in general, but if someone hands us a proposed coloring, we can **verify** it in polynomial time: just check every edge to confirm its endpoints have different colors.

This observation motivates the class NP.

**Definition (Class NP)**. $\mathbf{NP}$ is the class of all decision problems for which a <b>yes</b>-instance has a <em>certificate</em> (also called a <em>witness</em>) of this fact that can be <em>verified</em> in polynomial time.

**Examples of problems in NP.**

Think of this as a game. If the answer is **no**, then we are done. If the answer is **yes** and Alice knows this fact, she wants to convince Bob that this is the case too. The rule is that Alice cannot ask Bob to brute-force for the solution as he can only run polynomial time algorithms. So she has to give him something that he can easily verify. 

- **Graph 3-coloring**: Consider the 3-coloring problem that asks if the input graph is 3-colorable. While it's not clear how to tell if a graph is 3-colorable without brute-forcing, if the graph is 3-colorable, the certificate is a 3-coloring of the graph. To verify, go through every edge and check that 2 end points have different colors and there are at most 3 colors.

<p align="center">
<script type="text/tikz">
\begin{tikzpicture}[
  mynode/.style={circle, draw=black, thick, minimum size=0.8cm, font=\small\bfseries},
  >=stealth, thick
]

% Left: uncolored graph
\node[mynode] (v1) at (0,     0)  {$v_1$};
\node[mynode] (v2) at (0,     2)  {$v_2$};
\node[mynode] (v3) at (1.73,  1)  {$v_3$};
\node[mynode] (v4) at (1.73, -1)  {$v_4$};
\node[mynode] (v5) at (0,    -2)  {$v_5$};
\node[mynode] (v6) at (-1.73,-1)  {$v_6$};
\node[mynode] (v7) at (-1.73, 1)  {$v_7$};
\draw (v2)--(v3)--(v4)--(v5)--(v6)--(v7)--(v2);
\draw (v1)--(v2); \draw (v1)--(v4); \draw (v1)--(v6);
\draw (v3) to[bend right=25] (v6); \draw (v4) to[bend left=25] (v7);
\node at (0, 2.9) {Input graph};

% Arrow
\draw[->, very thick] (2.7, 0) -- (4.3, 0)
  node[midway, above] {certificate};

% Right: 3-colored graph
\node[mynode, fill=red!30]   (u1) at (7,     0)  {$v_1$};
\node[mynode, fill=blue!30]  (u2) at (7,     2)  {$v_2$};
\node[mynode, fill=green!40] (u3) at (8.73,  1)  {$v_3$};
\node[mynode, fill=blue!30]  (u4) at (8.73, -1)  {$v_4$};
\node[mynode, fill=green!40] (u5) at (7,    -2)  {$v_5$};
\node[mynode, fill=blue!30]  (u6) at (5.27, -1)  {$v_6$};
\node[mynode, fill=green!40] (u7) at (5.27,  1)  {$v_7$};
\draw (u2)--(u3)--(u4)--(u5)--(u6)--(u7)--(u2);
\draw (u1)--(u2); \draw (u1)--(u4); \draw (u1)--(u6);
\draw (u3) to[bend right=25] (u6); \draw (u4) to[bend left=25] (u7);
\node at (7, 2.9) {Certificate (valid 3-coloring)};

\end{tikzpicture}
</script>
</p>

- **Independent Set**: A set $S$ of vertices in a graph $G$ is an **independent set** if no two vertices in $S$ are adjacent. The decision problem asks: given $G$ and an integer $k$, does $G$ contain an independent set of size at least $k$? The certificate is simply the set $S$ itself. To verify, check that $\lvert S \rvert \ge k$ and that no edge of $G$ has both endpoints in $S$ — both checks run in $O(V + E)$ time. The figure below shows the generalized Petersen graph $GP(12, 4)$. It is not obvious whether it has an independent set of size $8$, but the certificate (the 8 highlighted vertices) makes it easy to verify.

<p align="center">
<script type="text/tikz">
\begin{tikzpicture}[
  base/.style={circle, draw=black, thick, minimum size=0.5cm, inner sep=0pt},
  hi/.style={circle, draw=black, very thick, fill=yellow!60, minimum size=0.5cm, inner sep=0pt},
  >=stealth, thick
]

% Left: GP(12,4) uncolored, centered at (0,0)
\foreach \i in {0,...,11} {
  \pgfmathsetmacro{\ang}{90 - \i * 30}
  \node[base] (u\i) at (\ang:3)   {};
  \node[base] (v\i) at (\ang:1.5) {};
}
\foreach \i [evaluate=\i as \j using {int(mod(\i+1,12))}] in {0,...,11} { \draw (u\i)--(u\j); }
\foreach \i in {0,...,11} { \draw (u\i)--(v\i); }
\foreach \i [evaluate=\i as \j using {int(mod(\i+4,12))}] in {0,...,11} { \draw (v\i)--(v\j); }
\node at (0, 3.7) {\quad $k=8$};

% Arrow
\draw[->, very thick] (3.8, 0) -- (5.2, 0)
  node[midway, above] {certificate};

% Right: GP(12,4) with independent set highlighted, centered at (9,0)
\begin{scope}[shift={(9,0)}]
  \foreach \i in {0,...,11} {
    \pgfmathsetmacro{\ang}{90 - \i * 30}
    \node[base] (U\i) at (\ang:3)   {};
    \node[base] (V\i) at (\ang:1.5) {};
  }
  \foreach \i [evaluate=\i as \j using {int(mod(\i+1,12))}] in {0,...,11} { \draw (U\i)--(U\j); }
  \foreach \i in {0,...,11} { \draw (U\i)--(V\i); }
  \foreach \i [evaluate=\i as \j using {int(mod(\i+4,12))}] in {0,...,11} { \draw (V\i)--(V\j); }
  % Highlight: even outer vertices + V1, V3
  \foreach \i in {0,2,4,6,8,10} {
    \pgfmathsetmacro{\ang}{90 - \i * 30}
    \node[hi] at (\ang:3) {};
  }
  \node[hi] at ({90 - 1*30}:1.5) {};
  \node[hi] at ({90 - 3*30}:1.5) {};
  \node at (0, 3.7) {Certificate (yellow)};
\end{scope}

\end{tikzpicture}
</script>
</p>

- **Subset Sum**: Given a set of integers $S$ and a target $t$, does some subset of $S$ sum to exactly $t$? It is not obvious how to decide this without trying all $2^n$ subsets, but if the answer is yes the certificate is the subset itself. Verification takes $O(n)$ time: sum the elements and compare to $t$.

<p align="center">
<script type="text/tikz">
\begin{tikzpicture}[
  box/.style={draw=black, thick, minimum width=0.85cm, minimum height=0.85cm, font=\small},
  hi/.style={draw=black, very thick, fill=yellow!60, minimum width=0.85cm, minimum height=0.85cm, font=\small},
  >=stealth, thick
]

% Left: input set in a 2x4 grid
\node[box] at (0, 0.9) {$3$};
\node[box] at (1, 0.9) {$1$};
\node[box] at (2, 0.9) {$7$};
\node[box] at (3, 0.9) {$11$};
\node[box] at (0, 0)   {$4$};
\node[box] at (1, 0)   {$9$};
\node[box] at (2, 0)   {$2$};
\node[box] at (3, 0)   {$6$};
\node at (1.5, 1.75) {\quad $t = 20$};

% Arrow
\draw[->, very thick] (3.9, 0.45) -- (5.1, 0.45)
  node[midway, above] {certificate};

% Right: subset {3, 7, 4, 6} highlighted
\node[hi]  at (6, 0.9) {$3$};
\node[box] at (7, 0.9) {$1$};
\node[hi]  at (8, 0.9) {$7$};
\node[box] at (9, 0.9) {$11$};
\node[hi]  at (6, 0)   {$4$};
\node[box] at (7, 0)   {$9$};
\node[box] at (8, 0)   {$2$};
\node[hi]  at (9, 0)   {$6$};
\node at (7.5, 1.75) {$3 + 7 + 4 + 6 = 20 = t$};

\end{tikzpicture}
</script>
</p>

<div class="lecturebox">
<b>Claim.</b> $\mathbf{P} \subseteq \mathbf{NP}$.
</div>

**Proof.** Let $L \in \mathbf{P}$, so there is a polynomial-time algorithm $\mathcal{A}$ that decides $L$. We show $L \in \mathbf{NP}$ by constructing a verifier: on input $(x, c)$, ignore the certificate $c$ and run $\mathcal{A}$ on $x$. If $\mathcal{A}$ accepts, accept; otherwise reject. This verifier runs in polynomial time and accepts $x$ if and only if $x \in L$, so $L \in \mathbf{NP}$. $\square$

Intuitively, if you can solve a problem efficiently on your own, you do not need a certificate to verify a yes-answer. The central open question in computer science is whether the reverse holds: does $\mathbf{NP} \subseteq \mathbf{P}$, i.e., is $\mathbf{P} = \mathbf{NP}$?
