---
title: NP-Hardness Part 2 (NP-Hard, NP-Complete, SAT, Cook-Levin, Reductions)
parent: DSA
nav_order: 17
layout: default
permalink: /dsa/np-hardness-part-2/
---

# NP-Hardness Part 2 (NP-Hard, NP-Complete, SAT, Cook-Levin, Reductions)

<div class="sectionlecturebox">
NP-Hard
</div>

**Definition (NP-Hard).** A problem $X$ is **NP-hard** if every problem in $\mathbf{NP}$ polynomial-time reduces to $X$:

$$\forall\, A \in \mathbf{NP}, \quad A \le_p X.$$

Informally, $X$ is at least as hard as every problem in NP. NP-hard problems need not be decision problems, and they need not belong to NP themselves. They may be strictly harder. If $X$ is NP-hard and admits a polynomial-time algorithm, then every problem in $\mathbf{NP}$ could be solved in polynomial time, implying $\mathbf{P} = \mathbf{NP}$, which is widely conjectured to be false.

<div class="sectionlecturebox">
NP-Complete
</div>

**Definition (NP-Complete).** A problem $X$ is **NP-complete** if:
1. $X \in \mathbf{NP}$: yes-instances of $X$ have a certificate verifiable in polynomial time, and
2. $X$ is NP-hard: every problem in $\mathbf{NP}$ reduces to $X$ in polynomial time.

NP-complete problems are simultaneously the **hardest problems inside NP**. If any one of them is in $\mathbf{P}$, then $\mathbf{P} = \mathbf{NP}$.

The diagram below shows how the complexity classes relate (assuming $\mathbf{P} \ne \mathbf{NP}$):

<p align="center">
<script type="text/tikz">
\begin{tikzpicture}[thick]
  % Fill NP-Hard region
  \fill[orange!25] (2.5, 0) ellipse (3.8 and 2.6);

  % Fill NP region
  \fill[blue!20] (-0.5, 0) ellipse (3.2 and 2.1);

  % Fill intersection (NP-Complete) by clipping NP and filling NP-Hard color
  \begin{scope}
    \clip (-0.5, 0) ellipse (3.2 and 2.1);
    \fill[violet!30] (2.5, 0) ellipse (3.8 and 2.6);
  \end{scope}

  % Fill P inside NP
  \fill[green!30] (-2.2, 0) ellipse (0.9 and 0.7);

  % Outlines
  \draw (2.5, 0) ellipse (3.8 and 2.6);
  \draw (-0.5, 0) ellipse (3.2 and 2.1);
  \draw (-2.2, 0) ellipse (0.9 and 0.7);

  % Labels
  \node[font=\sffamily] at (3.8,  1.9) {NP-Hard};
  \node[font=\sffamily] at (-1.4, 1.5) {NP};
  \node[font=\sffamily] at (0.9,  0.7) {NP-Complete};
  \node[font=\sffamily] at (0.9,  0.1) {(SAT, 3-SAT,};
  \node[font=\sffamily] at (0.9, -0.5) {Ind.\ Set, \ldots)};
  \node[font=\sffamily] at (-2.2,    0) {P};
\end{tikzpicture}
</script>
</p>

<div class="sectionlecturebox">
Satisfiability (SAT and 3-SAT)
</div>

**Terminology.** A **literal** is a variable $x_i$ or its negation $\neg x_i$. A **clause** is a disjunction (OR) of literals: $(\ell_1 \lor \ell_2 \lor \cdots \lor \ell_m)$. A formula is in **conjunctive normal form (CNF)** if it is a conjunction (AND) of clauses.

**Satisfiability (SAT).** Given a Boolean formula $\phi$ in CNF, does there exist a truth assignment to the variables that makes $\phi$ evaluate to **true** (i.e., satisfies every clause)?

**Example.** $\phi = (x_1 \lor \neg x_2) \land (\neg x_1 \lor x_2 \lor x_3)$. Setting $x_1 = \mathrm{T},\, x_2 = \mathrm{T},\, x_3 = \mathrm{F}$ makes both clauses true, so $\phi$ is satisfiable.

SAT is in NP: a satisfying assignment is the certificate, and verification takes $O(n)$ time (substitute the assignment into each clause and check).

**3-SAT.** The restriction of SAT where every clause contains **exactly 3 literals**. For example:

$$\phi = (x_1 \lor x_2 \lor \neg x_3) \land (\neg x_1 \lor x_2 \lor x_3) \land (x_1 \lor \neg x_2 \lor x_3).$$

3-SAT is also in NP for the same reason as SAT.

<div class="sectionlecturebox">
Cook-Levin Theorem
</div>

**Theorem (Cook 1971; Levin 1973).** SAT is NP-complete. In particular, 3-SAT is NP-complete.

The proof shows that any NP problem (described by a polynomial-time verifier) can be encoded as a SAT instance in polynomial time, using the computation of the verifier as a circuit. We omit the proof here.

The significance is that SAT (and 3-SAT) serves as the **starting point** for a chain of reductions: once we know 3-SAT is NP-complete, we can prove other problems NP-complete by reducing **from** 3-SAT (or from any known NP-complete problem).

<div class="sectionlecturebox">
Proving NP-Completeness
</div>

To prove a new problem $B$ is NP-complete:

1. **Show $B \in \mathbf{NP}$:** Exhibit a certificate for yes-instances and a polynomial-time verification algorithm.
2. **Show $B$ is NP-hard:** Choose a known NP-complete problem $A$ (e.g., 3-SAT) and construct a polynomial-time reduction $A \le_p B$.

Since every NP problem reduces to $A$ by NP-hardness of $A$, and $A$ reduces to $B$, transitivity gives that every NP problem reduces to $B$. Combined with step 1, $B$ is NP-complete.

<div class="sectionlecturebox">
Reduction: 3-SAT reduces to Independent Set
</div>

**Recall.** An **independent set** in a graph $G = (V, E)$ is a set $S \subseteq V$ such that no two vertices in $S$ are adjacent. The **Independent Set** decision problem asks: given $G$ and an integer $k$, does $G$ contain an independent set of size $\ge k$?

**Theorem.** Independent Set is NP-complete.

**Proof.**

*Step 1: Independent Set is in NP.* Given a set $S$ as the certificate, verify that $\lvert S \rvert \ge k$ and that no edge has both endpoints in $S$. This takes $O(V + E)$ time.

*Step 2: 3-SAT $\le_p$ Independent Set.* We describe a polynomial-time reduction.

**Construction.** Given a 3-CNF formula $\phi$ with clauses $C_1, \ldots, C_k$ over variables $x_1, \ldots, x_n$, build a graph $G$ and integer $k$ as follows:

- **Clause gadget:** For each clause $C_i = (\ell_1 \lor \ell_2 \lor \ell_3)$, create three vertices $v_{i,1}, v_{i,2}, v_{i,3}$ (one per literal) and connect them into a **triangle** (all three pairs are edges). This ensures at most one vertex per clause can be in any independent set.

- **Conflict edges:** For each pair of vertices $v_{i,a}$ and $v_{j,b}$ in *different* triangles ($i \ne j$) where the corresponding literals are **complementary** (one is $x_r$ and the other is $\neg x_r$ for some $r$), add an edge between them. This prevents choosing contradictory truth values.

- Set the target size to $k$ (the number of clauses).

The construction runs in polynomial time: $3k$ vertices and at most $\binom{3k}{2}$ edges.

**Example.** Let $\phi = (x_1 \lor x_2 \lor \neg x_3) \land (\neg x_1 \lor x_2 \lor x_3) \land (x_1 \lor \neg x_2 \lor x_3)$ with $k = 3$. The graph $G$ has three triangles (one per clause) and six conflict edges (dashed) connecting complementary literals across triangles. The assignment $x_1 = x_2 = x_3 = \mathrm{T}$ satisfies all three clauses; picking one true literal per clause gives the independent set $\{x_1,\, x_2,\, x_3\}$ highlighted in yellow.

<script type="text/tikz">
\begin{tikzpicture}[thick,
    lit/.style={circle, draw, minimum size=12mm, inner sep=1pt, font=\small\sffamily},
    hi/.style={circle, draw, minimum size=12mm, inner sep=1pt, font=\small\sffamily, fill=yellow!50},
    lbl/.style={draw=none, fill=none, font=\small\sffamily}]

  % === C1 (bottom-left): x1 apex, x2 base-left, neg_x3 base-right ===
  \node[hi]  (x1a)  at (0,   1.3) {$x_1$};
  \node[lit] (x2a)  at (-1,  0)   {$x_2$};
  \node[lit] (nx3a) at (1,   0)   {$\neg x_3$};
  \draw (x1a) -- (x2a) -- (nx3a) -- (x1a);
  \node[lbl] at (0, -0.8) {$C_1$};

  % === C2 (top-center): neg_x1 apex, x2 base-left, x3 base-right ===
  \node[lit] (nx1b) at (4,   4.3) {$\neg x_1$};
  \node[hi]  (x2b)  at (3,   3)   {$x_2$};
  \node[lit] (x3b)  at (5,   3)   {$x_3$};
  \draw (nx1b) -- (x2b) -- (x3b) -- (nx1b);
  \node[lbl] at (4, 2.2) {$C_2$};

  % === C3 (bottom-right): x1 apex, neg_x2 base-left, x3 base-right ===
  \node[lit] (x1c)  at (8,   1.3) {$x_1$};
  \node[lit] (nx2c) at (7,   0)   {$\neg x_2$};
  \node[hi]  (x3c)  at (9,   0)   {$x_3$};
  \draw (x1c) -- (nx2c) -- (x3c) -- (x1c);
  \node[lbl] at (8, -0.8) {$C_3$};

  % === Conflict edges (dashed) ===
  % x1 (C1) <-> neg_x1 (C2): bend left
  \draw[dashed, gray] (x1a)  to[bend left=15] (nx1b);
  % x1 (C3) <-> neg_x1 (C2): bend right
  \draw[dashed, gray] (x1c)  to[bend right=15] (nx1b);
  % x3 (C2) <-> neg_x3 (C1): diagonal down-left
  \draw[dashed, gray] (x3b)  to[bend right=15] (nx3a);
  % x2 (C2) <-> neg_x2 (C3): bend right more
  \draw[dashed, gray] (x2b)  to[bend right=25] (nx2c);
  % x2 (C1) <-> neg_x2 (C3): long, arc below, more
  \draw[dashed, gray] (x2a)  to[bend right=30] (nx2c);
  % neg_x3 (C1) <-> x3 (C3): long, arc below (deeper)
  \draw[dashed, gray] (nx3a) to[bend right=28] (x3c);

  \node[lbl] at (4, -1.9) {Solid: clause gadget \quad Dashed: conflict};
\end{tikzpicture}
</script>

**Correctness:** We prove $\phi$ is satisfiable $\iff$ $G$ has an independent set of size $k$.

$(\Rightarrow)$ Suppose $\phi$ has a satisfying assignment $\sigma$. For each clause $C_i$, at least one literal $\ell_{i,a}$ is true under $\sigma$; add vertex $v_{i,a}$ to set $S$.
- $\lvert S \rvert = k$ (one vertex per clause).
- No intra-triangle edge in $S$: we chose only one vertex per triangle.
- No conflict edge in $S$: if $S$ contained both $v_{i,a}$ (labeled $x_r$) and $v_{j,b}$ (labeled $\neg x_r$), then $\sigma$ makes both $x_r$ and $\neg x_r$ true, a contradiction.

So $S$ is an independent set of size $k$.

$(\Leftarrow)$ Suppose $G$ has an independent set $S$ with $\lvert S \rvert = k$. Each triangle is a clique of size 3, so $S$ contains at most one vertex per triangle. Since $\lvert S \rvert = k$ and there are $k$ triangles, $S$ has exactly one vertex per triangle. Define an assignment $\sigma$ by setting each literal in $S$ to true. This is well-defined: if $S$ contained $v_{i,a}$ labeled $x_r$ and $v_{j,b}$ labeled $\neg x_r$, the conflict edge between them would contradict $S$ being independent. For variables unconstrained by $S$, set them arbitrarily. Every clause $C_i$ is satisfied because the vertex chosen from triangle $i$ corresponds to a true literal in $C_i$. $\square$

<div class="sectionlecturebox">
Reduction: 3-SAT reduces to ILP
</div>

An **integer linear program (ILP)** is a system of linear inequalities with integer-valued variables. The **ILP Feasibility** decision problem asks: given coefficients $c_{ji}$ and right-hand sides $d_j$, does there exist integers $y_1, \ldots, y_n$ satisfying

$$\sum_{i=1}^{n} c_{ji}\, y_i \;\ge\; d_j \quad \text{for all } j?$$

**Theorem.** ILP Feasibility is NP-complete.

**Proof.**

*Step 1: ILP is in NP.* A certificate is an integer assignment $y \in \mathbb{Z}^n$. Checking each constraint takes $O(n)$ time, so verification is polynomial.

*Step 2: 3-SAT $\le_p$ ILP.* We describe a polynomial-time reduction.

**Construction.** Given a 3-CNF formula $\phi$ with clauses $C_1, \ldots, C_m$ over variables $x_1, \ldots, x_n$:

- **Variables:** Introduce an integer variable $y_i \in \mathbb{Z}$ for each $x_i$, where $y_i = 1$ encodes $x_i = \mathrm{T}$ and $y_i = 0$ encodes $x_i = \mathrm{F}$.

- **Clause constraints:** For each clause $C_j$, let $P_j$ be the set of indices of positive literals and $N_j$ the set of indices of negated literals. The clause is satisfied iff at least one literal is true:

$$\sum_{i \in P_j} y_i \;+\; \sum_{i \in N_j} (1 - y_i) \;\ge\; 1.$$

- **Bound constraints:** $0 \le y_i \le 1$ for each $i$ (together with integrality, this forces $y_i \in \{0,1\}$).

The ILP has $n$ variables, $m + 2n$ constraints, all constructible in polynomial time.

**Example (satisfiable).** For $\phi = (x_1 \lor x_2 \lor \neg x_3) \land (\neg x_1 \lor x_2 \lor x_3) \land (x_1 \lor \neg x_2 \lor x_3)$:

$$\begin{aligned}
y_1 + y_2 + (1-y_3) &\;\ge\; 1 & (C_1{:}\ P=\{1,2\},\ N=\{3\})\\
(1-y_1) + y_2 + y_3 &\;\ge\; 1 & (C_2{:}\ P=\{2,3\},\ N=\{1\})\\
y_1 + (1-y_2) + y_3 &\;\ge\; 1 & (C_3{:}\ P=\{1,3\},\ N=\{2\})\\
0 \le y_i \le 1,\quad y_i &\;\in\; \mathbb{Z}, & i = 1,2,3.
\end{aligned}$$

The assignment $y_1 = y_2 = y_3 = 1$ satisfies all three constraints: $1+1+0 = 2 \ge 1$, $0+1+1 = 2 \ge 1$, $1+0+1 = 2 \ge 1$.

**Example (unsatisfiable).** For $\phi = (x_1 \lor x_1 \lor x_1) \land (\neg x_1 \lor \neg x_1 \lor \neg x_1)$, the ILP becomes:

$$\begin{aligned}
3y_1 &\;\ge\; 1 & (C_1)\\
3(1-y_1) &\;\ge\; 1 & (C_2)\\
0 \le y_1 \le 1,\quad y_1 &\;\in\; \mathbb{Z}.
\end{aligned}$$

$C_1$ requires $y_1 \ge \tfrac{1}{3}$, so $y_1 = 1$. $C_2$ requires $y_1 \le \tfrac{2}{3}$, so $y_1 = 0$. The two constraints are contradictory — the ILP is infeasible, confirming $\phi$ is unsatisfiable.

**Correctness:** We prove $\phi$ is satisfiable $\iff$ the ILP has a feasible solution.

$(\Rightarrow)$ Let $\sigma$ be a satisfying assignment. Set $y_i = 1$ if $\sigma(x_i) = \mathrm{T}$, else $y_i = 0$. Each clause $C_j$ has at least one true literal: a true positive literal $x_i$ contributes $+1$ via $y_i = 1$, and a true negative literal $\neg x_i$ contributes $+1$ via $(1 - y_i) = 1$. So $\sum_{i \in P_j} y_i + \sum_{i \in N_j}(1 - y_i) \ge 1$ holds for every $j$.

$(\Leftarrow)$ Let $y \in \mathbb{Z}^n$ with $0 \le y_i \le 1$ be a feasible ILP solution. Set $\sigma(x_i) = \mathrm{T}$ iff $y_i = 1$. For each clause $C_j$, the constraint gives $\sum_{i \in P_j} y_i + \sum_{i \in N_j}(1 - y_i) \ge 1$, so at least one literal in $C_j$ is true under $\sigma$. $\square$
