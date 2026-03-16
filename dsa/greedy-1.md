---
title: Greedy Algorithms Part 1 (Files on Tape, Huffman Coding)
parent: DSA
nav_order: 9
layout: default
permalink: /dsa/greedy-1/
---

# Greedy Algorithms 1

Greedy algorithms, informally, are algorithms that aim to find solutions by performing a series of steps each of which is greedy in some sense.

<div class="sectionlecturebox">Storing Files on Tape</div>

### Problem

You have $n$ files with sizes $s_1, s_2, \ldots, s_n$ stored sequentially on a tape. Because tape access is sequential, reading file $i$ requires reading all files before it first. If the files are stored in some order $\sigma$ (a permutation of $\{1, \ldots, n\}$), the cost to retrieve file $\sigma(j)$ is:

$$\text{cost}(\sigma(j)) = \sum_{k=1}^{j} s_{\sigma(k)}$$

**Example.** Three files with sizes $[1, 2, 3]$. Two orderings:

- Order $[1, 2, 3]$ (i.e., $\sigma(1) = 1, \sigma(2) = 2, \sigma(3) = 3$): retrieval costs are $1,\ 1+2,\ 1+2+3$, total $= 1 + 3 + 6 = 10$.
- Order $[3, 2, 1]$ (i.e., $\sigma(1) = 3, \sigma(2) = 2, \sigma(3) = 1$): retrieval costs are $3,\ 3+2,\ 3+2+1$, total $= 3 + 5 + 6 = 14$.

As we see, the ordering matters in terms of the total retrieval cost. The objective is to find one that minimizes the cost. Assuming each file is equally likely to be requested, the **total retrieval cost** is:

$$C(\sigma) = \sum_{j=1}^{n} \sum_{k=1}^{j} s_{\sigma(k)} = \sum_{j=1}^{n} (n - j + 1) \cdot s_{\sigma(j)}$$

The second equality follows from counting how many times each file's size contributes to the total cost: file $\sigma(j)$ contributes to the cost of itself and all files that come after it, which is $n - j + 1$ times.

**Goal:** Find a permutation $\sigma$ that minimizes $C(\sigma)$. 




### Greedy Solution

**Claim.** Sorting files in **non-decreasing order of size** (smallest first) gives the optimal ordering.

**Intuition:** A small file placed early contributes its size to the cost of every subsequent retrieval. Placing larger files later reduces how often their large sizes are counted.

## Proof of Optimality (Exchange Argument)

Suppose an optimal ordering $\sigma$ has two adjacent files $\sigma(j) = a$ and $\sigma(j+1) = b$ with $s_a > s_b$ (a larger file appears before a smaller one). We show swapping them lowers the total cost. 

```
s_1, s_2, ..., s_{j-1}, s_a, s_b, s_{j+2}, ..., s_n
# swap a and b
s_1, s_2, ..., s_{j-1}, s_b, s_a, s_{j+2}, ..., s_n
```

Consider swapping two adjacent files $a$ (at position $j$) and $b$ (at position $j+1$). After the swap:

- The cost to read $a$ **increases** by $s_b$ (since $b$ now precedes $a$).
- The cost to read $b$ **decreases** by $s_a$ (since $b$ no longer has to skip over $a$).
- All other files are unaffected.

The net change in total cost is $s_b - s_a$. The swap is beneficial when $s_b - s_a < 0$, i.e., $s_b < s_a$. This leads to a contradiction since we assumed $\sigma$ is optimal, but swapping $a$ and $b$ would yield a lower cost. Hence, in the optimal ordering, there cannot be an adjacent pair of files where the larger file comes before the smaller one. Therefore, the optimal ordering is non-decreasing by size. The running time is simply $O(n \log n)$ dominated by sorting.

---

<div class="sectionlecturebox">Storing Files on Tape: Files with Access Probabilities</div>

### Problem

Each file $i$ now has a size $s_i$ and an access probability $p_i > 0$, where $\sum_{i=1}^{n} p_i = 1$. The **expected retrieval cost** is:

$$C(\sigma) = \sum_{j=1}^{n} p_{\sigma(j)} \cdot \sum_{k=1}^{j} s_{\sigma(k)}$$

That is, the cost to retrieve file $\sigma(j)$ is weighted by its access probability $p_{\sigma(j)}$.
Again, the goal is to find the ordering $\sigma$ minimizing $C(\sigma)$.

**Example.** Two files: $(s_1, p_1) = (10, 0.1)$ and $(s_2, p_2) = (1, 0.9)$.

- Order $[1, 2]$: $C = 0.1 \cdot 10 + 0.9 \cdot (10 + 1) = 1 + 9.9 = 10.9$.
- Order $[2, 1]$: $C = 0.9 \cdot 1 + 0.1 \cdot (1 + 10) = 0.9 + 1.1 = 2.0$.

Even though file 1 is larger, file 2 should go first because it is accessed much more frequently.

### Greedy Solution

**Claim.** Sorting files in **non-decreasing order of $s_i / p_i$** (size-to-probability ratio) gives the optimal ordering.

### Proof of Optimality (Exchange Argument)

Suppose in an optimal ordering, there are files $a = \sigma(j)$ and $b = \sigma(j+1)$ such that $s_a / p_a > s_b / p_b$. We show swapping them lowers the expected cost.
 Consider swapping two adjacent files $a$ (at position $j$) and $b$ (at position $j+1$). 

First, note that
$$
\frac{s_a}{p_a} > \frac{s_b}{p_b} \implies p_b s_a > p_a s_b \implies p_a s_b - p_b s_a < 0.
$$
 
 
 After the swap:

- The cost to read $a$ now **increases** by $s_b$, contributing $+p_a s_b$ to the total expected cost.
- The cost to read $b$ now **decreases** by $s_a$, contributing $-p_b s_a$ to the total expected cost.
- All other files are unaffected.

The net change in total expected cost is $p_a s_b - p_b s_a < 0$.  This leads to a contradiction since we assumed $\sigma$ is optimal. Hence, sorting by non-decreasing $s_i / p_i$ is optimal. The running time is again $O(n \log n)$ dominated by sorting.

---

<div class="sectionlecturebox">Huffman Coding</div>

### Prefix Trees

A **prefix tree** (also called a trie or prefix-free binary tree) is a full binary tree used to represent a binary encoding of symbols. Each leaf corresponds to one symbol, and the binary codeword for a symbol is read off by following the path from the root to that leaf: a left branch contributes a `0` and a right branch contributes a `1`.

The key property is **prefix-free**: no codeword is a prefix of another. This holds automatically because every symbol sits at a leaf — if a codeword for symbol $x$ were a prefix of the codeword for symbol $y$, then $x$ would lie on the path from the root to $y$, making $x$ an internal node, not a leaf.

**Example.** Suppose we want to encode four symbols $\{A, B, C, D\}$.

*Fixed-length encoding* uses 2 bits per symbol regardless of frequency:

```
A → 00,  B → 01,  C → 10,  D → 11
```

*Variable-length encoding* can do better if some symbols appear more often. Here is one prefix tree for the same four symbols:

```
        (root)
       /      \
      0        1
     / \      / \
    A   B    C   D
   (00)(01) (10)(11)
```

This is just the fixed-length tree. Now consider a different tree where $A$ is very frequent:

```
      (root)
      /     \
     0       1
     |      / \
     A     0   1
    (0)   /     \
         B       1
        (10)    / \
               C   D
              (110)(111)
```

Here the codewords are:

| Symbol | Codeword | Length |
|--------|----------|--------|
| A      | 0        | 1      |
| B      | 10       | 2      |
| C      | 110      | 3      |
| D      | 111      | 3      |

If a message is `AABABCD`, the fixed-length encoding uses $7 \times 2 = 14$ bits, while the variable-length encoding uses $1+1+2+1+2+3+3 = 13$ bits. The more skewed the symbol frequencies, the greater the savings.

**Cost of a prefix tree.** Given symbols $1, \ldots, n$ with frequencies $f_1, \ldots, f_n$ (the number of times each symbol appears), the total number of bits to encode a message is:

$$\text{cost}(T) = \sum_{i=1}^{n} f_i \cdot d_T(i)$$

where $d_T(i)$ is the depth of leaf $i$ in tree $T$ (equivalently, the length of symbol $i$'s codeword). The goal of **Huffman coding** is to find the prefix tree $T$ minimizing $\text{cost}(T)$.

### Huffman's Algorithm

The greedy idea is: **symbols with lower frequency should get longer codewords**. Rather than building the tree top-down, Huffman builds it bottom-up by repeatedly merging the two least-frequent symbols into a single combined node.

**Algorithm.**

1. Create a leaf node for each symbol $i$ with key $f_i$. Insert all nodes into a min-heap.
2. While the heap has more than one node:
   - Extract the two nodes $u$, $v$ with the smallest frequencies.
   - Create a new internal node $w$ with $f_w = f_u + f_v$, and children $u$ and $v$.
   - Insert $w$ back into the heap.
3. The remaining node is the root of the Huffman tree.

The running time is $O(n \log n)$: each of the $n-1$ merge steps does two extractions and one insertion into the min-heap, each $O(\log n)$.

**Example.** Five symbols with frequencies:

| Symbol | A  | B  | C  | D  | E  |
|--------|----|----|----|----|----|
| Freq   | 45 | 13 | 12 | 16 | 9  |

**Step 1.** Heap (sorted by frequency): $E{:}9,\ C{:}12,\ B{:}13,\ D{:}16,\ A{:}45$.

**Step 2.** Merge $E$ and $C$ (the two smallest) into $EC{:}21$.

Heap: $B{:}13,\ D{:}16,\ EC{:}21,\ A{:}45$.

**Step 3.** Merge $B$ and $D$ into $BD{:}29$.

Heap: $EC{:}21,\ BD{:}29,\ A{:}45$.

**Step 4.** Merge $EC$ and $BD$ into $ECBD{:}50$.

Heap: $A{:}45,\ ECBD{:}50$.

**Step 5.** Merge $A$ and $ECBD$ into $AECBD{:}95$. This is the root.

The resulting tree:

```
              (95)
             /    \
           (45)   (50)
            A     /   \
                (21)  (29)
                / \   / \
               E   C B   D
              (9)(12)(13)(16)
```

Reading off the codewords where left edges are `0` and right edges are `1`:

| Symbol | Path       | Codeword | Length |
|--------|------------|----------|--------|
| A      | left       | 0        | 1      |
| E      | right-left-left  | 100 | 3   |
| C      | right-left-right | 101 | 3   |
| B      | right-right-left | 110 | 3   |
| D      | right-right-right| 111 | 3   |

**Total cost:**

$$\text{cost}(T) = 45 \cdot 1 + 9 \cdot 3 + 12 \cdot 3 + 13 \cdot 3 + 16 \cdot 3 = 45 + 27 + 36 + 39 + 48 = 195 \text{ bits}$$

For comparison, a fixed-length encoding would need $\lceil \log_2 5 \rceil = 3$ bits per symbol, costing $3 \times (45 + 9 + 12 + 13 + 16) = 3 \times 95 = 285$ bits.

### Encoding and Decoding

Using the codeword table above, recall:

| Symbol | Codeword |
|--------|----------|
| A      | 0        |
| E      | 100      |
| C      | 101      |
| B      | 110      |
| D      | 111      |

**Encoding.** Encode the string `ABCADE` by replacing each symbol with its codeword and concatenating:

$$A\ B\ C\ A\ D\ E \;\longrightarrow\; 0 \cdot 110 \cdot 101 \cdot 0 \cdot 111 \cdot 100 = \texttt{0110101011110}$$

**Decoding.** It is trivial to decode a bitstring using the prefix tree. Start at the root and read bits one by one following left edges for `0` and right edges for `1`. Whenever you reach a leaf, output the corresponding symbol and return to the root to continue decoding the next symbol.

### Proof of Optimality

We prove that Huffman's algorithm produces a prefix tree with minimum cost. The proof proceeds in two steps: first a structural lemma about optimal trees, then an inductive argument.

**Lemma (sibling property).** There exists an optimal tree $T^\star$ in which the two symbols with the lowest frequencies, say $x$ and $y$ (with $f_x \leq f_y \leq f_i$ for all other $i$), are siblings at the maximum depth.

**Proof of Lemma.** Let $T^\star$ be any optimal tree. Let $a$ and $b$ be two siblings at maximum depth in $T^\star$. Without loss of generality assume $f_a \leq f_b$. Since $a$ and $b$ are at the maximum depth and $x$, $y$ are the two least frequent symbols, we have $f_x \leq f_a$ and $f_y \leq f_b$.

Swap $x$ with $a$ in $T^\star$ to get tree $T'$. The change in cost is:

$$\text{cost}(T') - \text{cost}(T^\star) = (f_x - f_a)(d_{T^\star}(a) - d_{T^\star}(x)) \leq 0$$

since $f_x \leq f_a$ and $d_{T^\star}(a) \geq d_{T^\star}(x)$ (because $a$ is at maximum depth). So $T'$ is no worse than $T^\star$, hence also optimal. Swapping $y$ with $b$ by the same argument gives a tree $T''$ that is optimal and has $x$, $y$ as siblings at maximum depth. $\square$

**Theorem.** Huffman's algorithm produces an optimal prefix tree.

**Proof.** By induction on $n$, the number of symbols.

*Base case.* $n = 2$: the only prefix tree has both symbols as children of the root, each with depth 1. Huffman produces exactly this tree.

*Inductive step.* Assume Huffman is optimal for any instance with $n - 1$ symbols. Consider an instance with $n$ symbols. Let $x$ and $y$ be the two symbols with the smallest frequencies.

By the Lemma, there exists an optimal tree $T^\star$ in which $x$ and $y$ are siblings under some internal node $w$. Since $x$ and $y$ are siblings, $d_{T^\star}(x) = d_{T^\star}(y) = d_{T^\star}(w) + 1$. We can expand $\text{cost}(T^\star)$ as:

$$\text{cost}(T^\star) = \sum_{i \neq x,y} f_i \cdot d_{T^\star}(i) + (f_x + f_y)(d_{T^\star}(w) + 1)$$

$$= \underbrace{\left[\sum_{i \neq x,y} f_i \cdot d_{T^\star}(i) + (f_x + f_y) \cdot d_{T^\star}(w)\right]}_{\text{cost}(T^\star_w)} + (f_x + f_y)$$

Here $T^\star_w$ is the tree $T^\star$ with leaves $x$ and $y$ removed and their parent $w$ treated as a leaf with frequency $f_w = f_x + f_y$ which is an instance with $n - 1$ symbols.

By the inductive hypothesis, Huffman's algorithm on this reduced instance produces a tree $T_w$ with $\text{cost}(T_w) \leq \text{cost}(T^\star_w)$. Huffman does exactly this: it merges $x$ and $y$ into $w$, recurses, then attaches $x$ and $y$ back as children of $w$. The resulting tree $T_H$ satisfies:

$$\text{cost}(T_H) = \text{cost}(T_w) + (f_x + f_y) \leq \text{cost}(T^\star_w) + (f_x + f_y) = \text{cost}(T^\star)$$

So Huffman's tree is at least as good as any optimal tree. $\blacksquare$