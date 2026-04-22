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
  % Step 1: fill NP-Hard with orange
  \fill[orange!25] (2.5, 0) ellipse (3.8 and 2.6);

  % Step 2: fill NP with blue
  \fill[blue!20] (-0.5, 0) ellipse (3.2 and 2.1);

  % Step 3: fill intersection (NP-Complete) with a distinct third color
  \begin{scope}
    \clip (-0.5, 0) ellipse (3.2 and 2.1);
    \fill[violet!30] (2.5, 0) ellipse (3.8 and 2.6);
  \end{scope}

  % Step 4: fill P inside NP
  \fill[green!30] (-2.2, 0) ellipse (0.9 and 0.7);

  % Draw outlines on top
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
\begin{tikzpicture}[thick, font=\small]
  % Coordinates
  % Clause 1: (x1, x2, \neg x3)
  \coordinate (c1a) at (0, 2);
  \coordinate (c1b) at (0, 0);
  \coordinate (c1c) at (0, -2);

  % Clause 2: (\neg x1, x2, x3)
  \coordinate (c2a) at (4, 2.5);
  \coordinate (c2b) at (4, 0.5);
  \coordinate (c2c) at (4, -1.5);

  % Clause 3: (x1, \neg x2, x3)
  \coordinate (c3a) at (8, 2);
  \coordinate (c3b) at (8, 0);
  \coordinate (c3c) at (8, -2);

  % Triangle edges
  \draw (c1a) -- (c1b) -- (c1c) -- cycle;
  \draw (c2a) -- (c2b) -- (c2c) -- cycle;
  \draw (c3a) -- (c3b) -- (c3c) -- cycle;

  % Conflict edges (all 6)
  \draw[dashed, red] (c1a) -- (c2a); % x1 -- \neg x1
  \draw[dashed, red] (c3a) -- (c2a); % x1 -- \neg x1

  \draw[dashed, red] (c1b) -- (c3b); % x2 -- \neg x2
  \draw[dashed, red] (c2b) -- (c3b); % x2 -- \neg x2

  \draw[dashed, red] (c1c) -- (c2c); % \neg x3 -- x3
  \draw[dashed, red] (c1c) -- (c3c); % \neg x3 -- x3

  % Clause labels
  \node[font=\footnotesize\sffamily] at (-1.3, 0) {$C_1$};
  \node[font=\footnotesize\sffamily] at (4, 4) {$C_2$};
  \node[font=\footnotesize\sffamily] at (9.3, 0) {$C_3$};

  % Highlighted independent set: {v_{1,1}, v_{2,2}, v_{3,3}}

  % Clause 1
  \node[fill=yellow!40, circle, inner sep=1.8pt] at (c1a) {};
  \node[left] at (c1a) {$v_{1,1}$};
  \node[left] at ($ (c1a) + (-0.35, 0.3) $) {$x_1$};

  \node[circle, fill=black, inner sep=1.2pt] at (c1b) {};
  \node[left] at (c1b) {$v_{1,2}$};
  \node[left] at ($ (c1b) + (-0.35, -0.1) $) {$x_2$};

  \node[circle, fill=black, inner sep=1.2pt] at (c1c) {};
  \node[left] at (c1c) {$v_{1,3}$};
  \node[left] at ($ (c1c) + (-0.35, 0.3) $) {$\neg x_3$};

  % Clause 2
  \node[circle, fill=black, inner sep=1.2pt] at (c2a) {};
  \node[right] at (c2a) {$v_{2,1}$};
  \node[right] at ($ (c2a) + (0.35, 0.3) $) {$\neg x_1$};

  \node[fill=yellow!40, circle, inner sep=1.8pt] at (c2b) {};
  \node[right] at (c2b) {$v_{2,2}$};
  \node[right] at ($ (c2b) + (0.35, -0.1) $) {$x_2$};

  \node[circle, fill=black, inner sep=1.2pt] at (c2c) {};
  \node[right] at (c2c) {$v_{2,3}$};
  \node[right] at ($ (c2c) + (0.35, 0.3) $) {$x_3$};

  % Clause 3
  \node[circle, fill=black, inner sep=1.2pt] at (c3a) {};
  \node[right] at (c3a) {$v_{3,1}$};
  \node[right] at ($ (c3a) + (0.35, 0.3) $) {$x_1$};

  \node[circle, fill=black, inner sep=1.2pt] at (c3b) {};
  \node[right] at (c3b) {$v_{3,2}$};
  \node[right] at ($ (c3b) + (0.35, -0.1) $) {$\neg x_2$};

  \node[fill=yellow!40, circle, inner sep=1.8pt] at (c3c) {};
  \node[right] at (c3c) {$v_{3,3}$};
  \node[right] at ($ (c3c) + (0.35, 0.3) $) {$x_3$};

  % Legend
  \node[font=\footnotesize\itshape] at (4, -3.5)
    {Independent set: $\{v_{1,1},\,v_{2,2},\,v_{3,3}\}$};

  \draw[fill=yellow!40] (1.6, -4.3) rectangle (2.1, -4.8);
  \node[right] at (2.15, -4.55) {independent set};

  \draw[dashed, red] (5.2, -4.55) -- (5.8, -4.55);
  \node[right] at (5.85, -4.55) {conflict edge};
\end{tikzpicture}
</script>

**Correctness:** We prove $\phi$ is satisfiable $\iff$ $G$ has an independent set of size $k$.

$(\Rightarrow)$ Suppose $\phi$ has a satisfying assignment $\sigma$. For each clause $C_i$, at least one literal $\ell_{i,a}$ is true under $\sigma$; add vertex $v_{i,a}$ to set $S$.
- $\lvert S \rvert = k$ (one vertex per clause).
- No intra-triangle edge in $S$: we chose only one vertex per triangle.
- No conflict edge in $S$: if $S$ contained both $v_{i,a}$ (labeled $x_r$) and $v_{j,b}$ (labeled $\neg x_r$), then $\sigma$ makes both $x_r$ and $\neg x_r$ true, a contradiction.

So $S$ is an independent set of size $k$.

$(\Leftarrow)$ Suppose $G$ has an independent set $S$ with $\lvert S \rvert = k$. Each triangle is a clique of size 3, so $S$ contains at most one vertex per triangle. Since $\lvert S \rvert = k$ and there are $k$ triangles, $S$ has exactly one vertex per triangle. Define an assignment $\sigma$ by setting each literal in $S$ to true. This is well-defined: if $S$ contained $v_{i,a}$ labeled $x_r$ and $v_{j,b}$ labeled $\neg x_r$, the conflict edge between them would contradict $S$ being independent. For variables unconstrained by $S$, set them arbitrarily. Every clause $C_i$ is satisfied because the vertex chosen from triangle $i$ corresponds to a true literal in $C_i$. $\square$
