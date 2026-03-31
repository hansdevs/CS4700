# Control Structures in Programming Languages

> **CS 4700 -- March 31st**
> Utah State University

---

## Table of Contents

1. [What Is a Control Structure?](#what-is-a-control-structure)
2. [Control Flow Using GOTO](#control-flow-using-goto)
3. [Sequential and Collateral Commands](#sequential-and-collateral-commands)
4. [Conditional Commands](#conditional-commands)
5. [Iterative Commands](#iterative-commands)
6. [Escapes and Breaks](#escapes-and-breaks)
7. [Exceptions](#exceptions)
8. [Control Structures in CS4700 Languages](#control-structures-in-cs4700-languages)
9. [Comprehensive Cross-Language Comparison](#comprehensive-cross-language-comparison)
10. [Summary](#summary--control-structure-design-philosophy)

---

## What Is a Control Structure?

A **control structure** is a control statement together with the collection of statements whose execution it governs. Control structures dictate the order in which instructions execute and are one of the most fundamental aspects of any programming language.

Every imperative language provides at least:

| Structure | Purpose | Classic Example |
|---|---|---|
| **Selection** | Choose one path based on a condition | `if / else` |
| **Multiple Selection** | Choose one of many paths | `switch` / `match` |
| **Definite Iteration** | Repeat a known number of times | `for` loop |
| **Indefinite Iteration** | Repeat until a condition changes | `while`, `do...while` |

Control structures are **single-entry, single-exit** constructs:

```
                  +-------------------+
                  |                   |
                  |     true          |
  entry ----+--->  E ---> S1 --------+---> exit
                  |  |               |
                  |  +---> S2 -------+
                  |    false         |
                  +-------------------+
```

### Why This Common Set?

All of these structures can ultimately be reduced to **goto** instructions at the machine level. The seminal 1968 paper *"Go To Statement Considered Harmful"* by Edsger Dijkstra argued that undisciplined use of `goto` makes programs unreadable and error-prone. Structured control flow offers:

- **Disciplined branching** -- gotos are still used under the hood, but the programmer works with higher-level abstractions.
- **Common pattern recognition** -- selection, iteration, and sequencing cover the vast majority of control flow needs.
- **Readability and maintainability** -- structured code is easier for humans to follow.
- **Safety** -- prevents dangerous patterns like branching into the middle of a subroutine.
- **Lexical coherence** -- related code stays together visually and logically.

---

## Control Flow Using GOTO

In the 1960s, `GOTO` was a standard part of many languages. In assembler, branch/GOTO is the **only** flow-of-control mechanism.

Dijkstra's 1968 paper ["Go To Statement Considered Harmful"](https://dl.acm.org/doi/10.1145/362929.362947) was a turning point in programming language design.

### GOTO Still Exists in Modern Languages

Even today, `goto` persists in some languages:

```python
# Python -- goto via third-party module (never do this!)
if b > a:
    goto .elselabel
elif a == b:
    .elselabel: print("a and b are equal")
```

```python
# Python also has "comefrom" (from the goto module)
print("here")
label .skipahead
print("I'm skipped")
comefrom .skipahead
```

### Computed GOTO

The `GOTO` target can be a computed value, making control flow even harder to reason about:

```cpp
// C++ -- computed GOTO via GCC extension
static void *array[] = { &&foo, &&bar, &&hack };
goto *array[i];  // no bounds checking!
```

```python
# Python (goto module)
x = calculateLabelName()
goto *x
```

Computed GOTOs are dangerous because there is no static guarantee that the target is valid. Modern structured control (switch, match, virtual dispatch) replaces computed GOTOs safely.

---

## Sequential and Collateral Commands

### Sequential Execution

The default in most imperative languages: statements execute one after another, top to bottom.

```c
// C
printf("I'm first");
printf("I'm second");
```

```python
# Python
print("I'm first")
print("I'm second")
```

```postscript
% PostScript -- sequential execution on the stack
(I'm first) print
(I'm second) print
```

```haskell
-- Haskell -- sequential via do-notation (monadic sequencing)
main = do
    putStrLn "I'm first"
    putStrLn "I'm second"
```

### Collateral Execution

In collateral execution, there is **no guarantee** of ordering. This is rare and typically only appears in parallel or concurrent programming languages.

```c
// Hypothetical collateral C
printf("Maybe I'm first"), printf("Maybe I'm second");
```

```c
n = 7; n = 8;   // sequential -- n is guaranteed to be 8
n = 7, n = 8;   // collateral -- n could be 7 or 8
```

**Language comparison -- concurrency primitives that resemble collateral commands:**

| Language | Mechanism | Notes |
|---|---|---|
| **Dart** | `Future.wait([f1, f2])` | Concurrent futures with event-loop scheduling |
| **Go** | `go func()` goroutines | Lightweight concurrent execution; non-deterministic without sync |
| **Rust** | `std::thread::spawn` | Ownership prevents data races at compile time |
| **Gleam** | Erlang processes via OTP | Built on BEAM VM; message-passing concurrency |
| **Haskell** | `forkIO`, `async` | Software transactional memory (STM) for safe concurrency |
| **Prolog** | Concurrent logic programming | Backtracking is sequential; parallelism requires extensions |

---

## Conditional Commands

A conditional command selects **exactly one** subcommand to execute based on a condition (the *guard*).

### if-then-else Across Languages

```c
// C / C++
if (E) {
    C1;
} else {
    C2;
}
```

```pascal
{ Pascal }
if E then C1
else C2;
```

```python
# Python
if E:
    C1
elif E2:
    C2
else:
    C3
```

```raku
# Raku -- uses elsif for chaining
if (E) { C1 }
elsif (E2) { C2 }
else { C3 }

# Raku -- one-line postfix form
$max = $y if $y > $max;
$max = $x unless $x < $max;
```

```rust
// Rust -- if is an EXPRESSION that returns a value
let result = if x > 0 { "positive" } else { "non-positive" };
```

```dart
// Dart -- traditional if statement
if (E) {
    C1;
} else if (E2) {
    C2;
} else {
    C3;
}
// Dart also has ternary: condition ? expr1 : expr2
var result = x > 0 ? "positive" : "non-positive";
```

```haskell
-- Haskell -- if is an expression; both branches required
let result = if x > 0 then "positive" else "non-positive"

-- Haskell -- guards (more idiomatic than if-else chains)
absolute x
    | x < 0    = -x
    | otherwise = x
```

```gleam
// Gleam -- no if statement; uses case expressions for all branching
let result = case x > 0 {
    True -> "positive"
    False -> "non-positive"
}
```

```prolog
% Prolog -- if-then-else via the -> ; operator
classify(X, Result) :-
    ( X > 0 -> Result = positive
    ; X < 0 -> Result = negative
    ; Result = zero
    ).
```

```postscript
% PostScript -- if and ifelse are stack-based operators
% condition {true-branch} if
% condition {true-branch} {false-branch} ifelse
x 0 gt { (positive) } { (non-positive) } ifelse
```

**Key design differences:**

| Language | `if` is an expression? | Postfix form? | Guards? | Requires else? |
|---|---|---|---|---|
| **C / C++** | No | No | No | No |
| **Java** | No (ternary `?:` is) | No | No | No |
| **Pascal** | No | No | No | No |
| **Python** | Yes (ternary `x if c else y`) | No | No | No |
| **Raku** | No | Yes (`x if cond`) | No | No |
| **Rust** | Yes | No | No | Yes (when used as expr) |
| **Dart** | No (ternary `?:` is) | No | No | No |
| **Haskell** | Yes | No | Yes | Yes |
| **Gleam** | N/A (uses `case`) | No | Yes (via `case`) | Yes |
| **Prolog** | N/A (logical) | No | Via clauses | No |
| **PostScript** | N/A (stack-based) | No | No | No |

### Nondeterministic Conditionals

A nondeterministic conditional (as in Dijkstra's guarded commands) selects any subcommand whose guard is true:

```
if E1 -> C1
 | E2 -> C2
 | ...
 | En -> Cn
fi
```

If the command is effectively deterministic (at most one guard is true at a time), this degenerates into a chain of independent `if` statements.

**Prolog's clause selection** is the closest modern analog -- multiple clauses can match, and Prolog tries them in order with backtracking:

```prolog
% Prolog -- multiple clauses act like guarded commands
greet(morning) :- write('Good morning').
greet(afternoon) :- write('Good afternoon').
greet(evening) :- write('Good evening').
```

### Case / Switch / Match Statements

A case statement is semantically similar to nested `if-then-else`, but can be **more efficient** -- compilers can generate jump tables for dense integer ranges, achieving O(1) dispatch instead of O(n) sequential tests.

#### Across Languages

```c
// C -- fall-through by default; break required to exit
switch (x) {
    case 1:  doA(); break;
    case 2:  doB(); break;
    default: doDefault();
}
```

```java
// Java 14+ -- switch expressions with arrow syntax prevent fall-through
int result = switch (x) {
    case 1 -> 10;
    case 2 -> 20;
    default -> 0;
};
```

```python
# Python 3.10+ -- structural pattern matching
match x:
    case 1:
        do_a()
    case 2:
        do_b()
    case _:
        do_default()
```

```rust
// Rust -- match is exhaustive; compiler enforces all cases are handled
match x {
    1 => do_a(),
    2 => do_b(),
    _ => do_default(),
}
```

```dart
// Dart 3.0+ -- switch expressions with pattern matching
var result = switch (x) {
    1 => 'one',
    2 => 'two',
    _ => 'other',
};

// Dart -- traditional switch statement (fall-through disallowed on non-empty cases)
switch (x) {
    case 1:
        doA();
        break;
    case 2:
        doB();
        break;
    default:
        doDefault();
}
```

```haskell
-- Haskell -- case expression with pattern matching
describe x = case x of
    1 -> "one"
    2 -> "two"
    _ -> "other"

-- Also via function-level pattern matching
describe 1 = "one"
describe 2 = "two"
describe _ = "other"
```

```gleam
// Gleam -- case is the primary branching construct
// The compiler enforces exhaustive matching
let description = case x {
    1 -> "one"
    2 -> "two"
    _ -> "other"
}

// Gleam -- pattern matching on complex types
case result {
    Ok(value) -> use_value(value)
    Error(reason) -> handle_error(reason)
}
```

```prolog
% Prolog -- no switch; pattern matching on clause heads
describe(1, "one").
describe(2, "two").
describe(_, "other").
```

```postscript
% PostScript -- no native switch; simulate with dictionary lookup
/actions <<
    /case1 { (one) print }
    /case2 { (two) print }
>> def
% Or use nested ifelse
```

```raku
# Raku -- given/when (similar to switch with smart matching)
given $x {
    when 1  { say "one" }
    when 2  { say "two" }
    default { say "other" }
}
```

**Critical differences:**

| Language | Fall-through? | Exhaustive? | Expressions? | Pattern Matching? | Static values only? |
|---|---|---|---|---|---|
| **C / C++** | Yes (implicit) | No | No | No | Yes |
| **Java** (classic) | Yes (implicit) | No | No | No | Yes |
| **Java 14+** | No (arrow) | Yes (expr) | Yes | Limited | No |
| **Python 3.10+** | No | No | No | Yes (structural) | No |
| **Rust** | No | Yes (compile-time) | Yes | Yes (full) | No |
| **Dart 3.0+** | No | Yes (sealed types) | Yes | Yes (full) | No |
| **Haskell** | No | Yes (warnings) | Yes | Yes (full) | No |
| **Gleam** | No | Yes (compile-time) | Yes | Yes (full) | N/A |
| **Raku** | No | No | No | Yes (smart match) | No |
| **Prolog** | No (backtracks) | No | N/A | Yes (unification) | No |
| **PostScript** | N/A | N/A | N/A | No | N/A |

**Historical notes:**
- **COBOL** used the keyword `CASE` for a computed goto. When a structured case statement was later added, the keyword `WHEN` had to be used instead.
- **Pascal** did not define behavior when no case tag matched. Implementations varied: some ignored the mismatch, some raised a runtime error, some added a default clause.
- **C's fall-through** is widely considered a design mistake -- users forget `break` statements. Java inherited this but added switch expressions in Java 14 to address it.

---

## Iterative Commands

### Two Fundamental Classes

| Class | Description | Typical Form |
|---|---|---|
| **Definite** | Number of iterations known before the loop starts | `for` loop |
| **Indefinite** | Number of iterations unknown; depends on a runtime condition | `while`, `do...while` |

### Repeat Loop (Post-Test)

The continuation/exit condition is evaluated **after** the loop body, so the body always executes **at least once**.

```
        +-------+
        |       |
   ---> | S | --+--> C --+--->
        |       |  true  |
        +-------+ <------+
                    false exits
```

```c
// C / C++
do {
    C;
} while (E);
```

```pascal
{ Pascal -- note: "until" means exit when true (opposite of "while") }
repeat
    C
until E;
```

```java
// Java
do {
    S;
} while (C);
```

```dart
// Dart -- same as Java/C
do {
    S;
} while (C);
```

```rust
// Rust -- no built-in do-while; idiomatic alternative:
loop {
    C;
    if !E { break; }
}
```

**Languages without a post-test loop:**

| Language | Has do-while? | Workaround |
|---|---|---|
| **C / Java / Dart** | Yes | -- |
| **Pascal** | Yes (`repeat...until`) | -- |
| **Python** | No | `while True:` with `break` |
| **Rust** | No | `loop { ... if !E { break; } }` |
| **Haskell** | No | Recursion or monadic loops |
| **Gleam** | No | Recursion |
| **Prolog** | No | Recursion with tail calls |
| **PostScript** | No | `loop` with `exit` |

### While Loop (Pre-Test)

The condition is evaluated **before** the body. The body may execute **zero** times.

```
        +----------------------+
        |                      |
        |        false         |
   -----+---> C --------------+------>
        | |   |                |
        | |   +----> S         |
        | |    true  |         |
        | +<---------+         |
        +----------------------+
```

```c
// C / C++
while (E) {
    C;
}
```

```java
// Java
while (C) {
    S;
}
```

```python
# Python
while E:
    C
```

```rust
// Rust
while E {
    C;
}
```

```dart
// Dart
while (C) {
    S;
}
```

```raku
# Raku
while (C) { S }
```

```postscript
% PostScript -- no while keyword; use loop with exit
{ E not { exit } if  S } loop
```

```haskell
-- Haskell -- no while loop; use recursion
whileM :: IO Bool -> IO () -> IO ()
whileM cond body = do
    c <- cond
    when c $ do
        body
        whileM cond body
```

```prolog
% Prolog -- recursion replaces loops entirely
print_until_zero(0) :- !.
print_until_zero(N) :-
    write(N), nl,
    N1 is N - 1,
    print_until_zero(N1).
```

```gleam
// Gleam -- no loops at all; recursion only
fn count_down(n: Int) -> Nil {
    case n {
        0 -> Nil
        _ -> {
            io.println(int.to_string(n))
            count_down(n - 1)
        }
    }
}
```

### General Loop (Mid-Test)

Sometimes we need to evaluate the exit condition **in the middle** of the loop body. This avoids duplicating initialization or read logic.

**The problem:**

```
repeat
    C1;           // first half of body
while (E)         // test in the middle
    C2;           // second half of body
```

**Example -- read characters until `*`:**

```
repeat
    ch = getchar();
while (ch != '*')
    print(ch);
```

C does not have a native mid-test loop, but `break` inside an infinite loop achieves the same effect:

```c
// C -- general loop via break
for (;;) {
    ch = getchar();
    if (ch == '*') break;
    printf("%c", ch);
}
```

```rust
// Rust -- loop is explicitly designed for this
loop {
    let ch = get_char();
    if ch == '*' { break; }
    print!("{}", ch);
}
```

```python
# Python
while True:
    ch = get_char()
    if ch == '*':
        break
    print(ch)
```

```dart
// Dart
while (true) {
    var ch = getChar();
    if (ch == '*') break;
    print(ch);
}
```

```postscript
% PostScript -- loop with exit
{
    currentfile read       % read a character
    { dup 42 eq { pop exit } if  % 42 = ASCII '*'
      ( ) dup 0 4 -1 roll put print
    } if
} loop
```

### For Loop -- The Loop Index Question

The `for` loop raises several design questions about the **loop index variable**:

```pascal
{ Pascal }
for i := 1 to 7 do
begin
    writeln(i);
end;
```

| Question | C | Java | Python | Rust | Pascal | Dart | Raku |
|---|---|---|---|---|---|---|---|
| Must index be declared elsewhere? | Pre-C99: yes | No | No (implicit) | No | Yes | No | No |
| Can index be modified in body? | Yes | Yes | Yes (meaningless for `range`) | No (immutable) | Impl-dependent | Yes | Yes |
| Index value after loop? | Last assigned | Last assigned | Last assigned | N/A (scoped) | Undefined | Last assigned | Last assigned |
| Increment restricted to integers? | No | No | Integers only | N/A (iterators) | No (ordinals) | No | No |

**Definite loop issues illustrated:**

```pascal
{ Pascal -- what is i after the loop? 8? 7? undefined? }
for i := 1 to 7 do
begin
    writeln(i);
end;
{ Answer: undefined by the language spec! }
```

```pascal
{ Pascal -- can you change i inside the loop? }
for i := 'a' to 'f' do
begin
    writeln(i);
    i := 'g';  { Not allowed? }
end;
```

### Modern Trend -- Remove the Index Entirely

Many modern languages prefer **iterator-based** loops, eliminating off-by-one errors:

```raku
# Raku -- foreach with explicit loop variable
for [1..7] -> $i {
    print $i;
}
```

```python
# Python -- for-in
for item in collection:
    print(item)
```

```rust
// Rust -- for-in with iterators
for item in collection.iter() {
    println!("{}", item);
}
```

```dart
// Dart -- for-in
for (var item in collection) {
    print(item);
}
```

```haskell
-- Haskell -- map (no explicit loop at all)
mapM_ print [1..7]

-- Or list comprehension
[x * 2 | x <- [1..7]]
```

```gleam
// Gleam -- list.each or list.map (no loop keyword)
list.each(my_list, fn(item) {
    io.println(item)
})

list.map([1, 2, 3], fn(x) { x * 2 })
```

```prolog
% Prolog -- iteration via findall or maplist
print_list([]).
print_list([H|T]) :- write(H), nl, print_list(T).
```

```postscript
% PostScript -- forall iterates over arrays
[1 2 3 4 5] { == } forall

% PostScript -- for loop with index
1 1 7 { == } for    % prints 1 through 7
```

### Iteration Paradigm Comparison

| Paradigm | Languages | Loop Mechanism |
|---|---|---|
| **Imperative loops** | C, Java, Dart, Pascal | `for`, `while`, `do-while` |
| **Iterator-based** | Python, Rust, Raku, Dart | `for-in` over iterables |
| **Recursion only** | Haskell, Gleam, Prolog | Tail-recursive functions; no loop keywords |
| **Higher-order functions** | Haskell, Gleam, Rust | `map`, `fold`, `filter` replace loops |
| **Stack-based** | PostScript | `for`, `forall`, `loop` operators on the stack |
}
```

```rust
// Rust
loop {
    let ch = get_char();
    if ch == '*' { break; }
    print!("{}", ch);
}
```

```python
# Python
while True:
    ch = get_char()
    if ch == '*':
        break
    print(ch)
```

### For Loop -- The Loop Index Question

The `for` loop raises several design questions about the **loop index variable**:

| Question | C | Java | Python | Rust | Pascal |
|---|---|---|---|---|---|
| Must the index be declared elsewhere? | Pre-C99: yes | No (`for (int i...)`) | No (implicit) | No (`for i in ...`) | Yes |
| Can the index be modified inside the body? | Yes | Yes | Yes (but meaningless for `range`) | No (immutable by default) | Implementation-dependent |
| What is the index value after the loop? | Last assigned value | Last assigned value | Last assigned value | N/A (scoped to loop) | Undefined |

**Modern trend -- eliminate the index entirely:**

Many modern languages prefer iterator-based loops that abstract away the index, reducing off-by-one errors and making intent clearer.

```perl
# Perl -- foreach
foreach my $item (@array) {
    print $item;
}
```

```python
# Python -- for-in
for item in collection:
    print(item)
```

```rust
// Rust -- for-in with iterators
for item in collection.iter() {
    println!("{}", item);
}
```

```swift
// Swift
for item in collection {
    print(item)
}
```

```go
// Go -- range
for i, item := range collection {
    fmt.Println(i, item)
}
```

```kotlin
// Kotlin
for (item in collection) {
    println(item)
}
```

---

## Escapes and Breaks

### Single-Entry, Single-Exit Principle

Most structured control constructs follow the **single-entry, single-exit** (SESE) model. They can be composed like building blocks, and reasoning about them is straightforward.

**if-then-else flow:**

```
        +-------------------+
        |                   |
        |     true          |
   -----+-> E ---> C1 -----+----->
        |  |                |
        |  +----> C2 -------+
        |    false          |
        +-------------------+
```

**while loop flow:**

```
        +----------------------+
        |                      |
        |        false         |
   -----+---> E --------------+------>
        | |   |                |
        | |   +----> C         |
        | |    true  |         |
        | +<---------+         |
        +----------------------+
```

### break -- Escape from the Innermost Block

A `break` transfers control to the **end of the immediately enclosing loop**. It cannot cross multiple loop boundaries.

```c
// C -- break exits only the inner loop
while (!eof()) {
    ch = getchar();
    if (ch == 'q') break;  // exits this while loop only
}
```

**Flow with break:**

```
        +----------------------+
        |                      |
        |        false         |
   -----+---> E --------------+------>
        | |   |                |  |
        | |   +----> C -------+--+  (break exits here)
        | |    true  |         |
        | +<---------+         |
        +----------------------+
```

### continue / next -- Skip to End of Loop Body

The `continue` (or `next`) statement skips the rest of the current iteration and jumps to the loop condition check.

```
        +-----------------------------+
        |              false          |
   -----+---> C ---------------------+----->
        | |   |                       |
        | |   +---> S; next; S2       |
        | |    true       |           |
        | +<--------------+ (S2 skipped)
        +-----------------------------+
```

```c
// C / C++ / Java / Dart
for (int i = 0; i < 10; i++) {
    if (i % 2 == 0) continue;  // skip even numbers
    printf("%d\n", i);
}
```

```python
# Python
for i in range(10):
    if i % 2 == 0:
        continue
    print(i)
```

```rust
// Rust
for i in 0..10 {
    if i % 2 == 0 { continue; }
    println!("{}", i);
}
```

```raku
# Raku -- uses "next" instead of "continue"
for 0..9 -> $i {
    next if $i %% 2;
    say $i;
}
```

| Language | Skip keyword | Notes |
|---|---|---|
| **C / C++ / Java / Dart** | `continue` | Standard keyword |
| **Python** | `continue` | Standard keyword |
| **Rust** | `continue` | Supports labels: `continue 'label` |
| **Raku** | `next` | Perl-family keyword |
| **Haskell** | N/A | No loops, no continue; use guards or pattern matching in recursion |
| **Gleam** | N/A | No loops; filter in list operations |
| **Prolog** | N/A | Backtracking replaces continue |
| **PostScript** | N/A | No direct equivalent |

### Breaking Out of Nested Loops -- Language Comparison

The problem: `break` in C only exits one level. How do we exit multiple levels?

```c
// C -- break only exits the inner loop
while (...) {
    while (...) {
        if (ch == 'q') break;  // exits inner loop only
    }
    // execution continues here after break
}
```

**Solutions across languages:**

```java
// Java -- labeled break
outer:
while (true) {
    while (true) {
        if (ch == 'q') break outer;  // exits both loops
    }
}
```

```rust
// Rust -- labeled break
'outer: loop {
    loop {
        if ch == 'q' { break 'outer; }
    }
}

// Rust -- break can return a value from loop!
let result = loop {
    if condition { break 42; }
};
```

```dart
// Dart -- labeled break (same syntax as Java)
outer:
while (true) {
    while (true) {
        if (ch == 'q') break outer;
    }
}
```

```python
# Python -- no labeled break; common workarounds:
# 1. Extract to function and use return
def search():
    for row in matrix:
        for val in row:
            if val == target:
                return val

# 2. Use a flag variable
# 3. Use exception (anti-pattern)
```

```raku
# Raku -- labeled loop control
OUTER: while True {
    while True {
        last OUTER if $ch eq 'q';  # exits both loops
    }
}
```

| Language | Multi-level break? | Mechanism |
|---|---|---|
| **C / C++** | No | Use `goto`, flag variable, or `return` |
| **Java** | Yes | Labeled `break` |
| **Dart** | Yes | Labeled `break` |
| **Python** | No | Use `return` from function or flag |
| **Rust** | Yes | Labeled `break 'label` (can also return values) |
| **Raku** | Yes | `last LABEL` |
| **Go** | Yes | Labeled `break` |
| **Haskell** | N/A | No loops to break from |
| **Gleam** | N/A | No loops to break from |
| **Prolog** | N/A | Cut (`!`) controls backtracking |
| **PostScript** | Partial | `exit` exits the innermost `loop`/`for`/`forall` |

### Prolog's Cut -- A Unique Control Mechanism

Prolog has no break/continue, but the **cut** (`!`) operator controls backtracking:

```prolog
% Without cut -- Prolog may try all clauses
max(X, Y, X) :- X >= Y.
max(X, Y, Y) :- X < Y.

% With cut -- once X >= Y succeeds, don't try the second clause
max(X, Y, X) :- X >= Y, !.
max(_, Y, Y).
```

The cut commits to the current clause choice, preventing backtracking past it. It is the closest analog to `break` in logic programming.

### return -- General Escape from a Function

A `return` statement exits the entire function, regardless of nesting depth.

```java
// Java
while (...) {
    while (...) {
        if (ch == 'q') return;  // exits both loops AND the function
    }
}
```

```gleam
// Gleam -- no return statement; the last expression is the return value
// Early return is achieved via case expressions
fn process(x: Int) -> String {
    case x {
        0 -> "zero"        // "early return" for this case
        _ -> "non-zero"
    }
}
```

```haskell
-- Haskell -- no return statement in the imperative sense
-- "return" in Haskell wraps a value in a monad (completely different!)
-- Control flow is handled through pattern matching and guards
process 0 = "zero"
process _ = "non-zero"
```

### exit / halt -- Terminate the Program

The most drastic escape: terminate the entire process.

```c
// C
exit(return_code);
```

```java
// Java
System.exit(1);
```

```python
# Python
import sys
sys.exit(1)
```

```rust
// Rust
std::process::exit(1);
```

```dart
// Dart
import 'dart:io';
exit(1);
```

```haskell
-- Haskell
import System.Exit
exitWith (ExitFailure 1)
```

```postscript
% PostScript
quit
```

**Escalation hierarchy:**

| Level | Scope | C | Java | Python | Rust | Dart | Haskell | Prolog |
|---|---|---|---|---|---|---|---|---|
| **continue** | Current iteration | `continue` | `continue` | `continue` | `continue` | `continue` | N/A | fail/backtrack |
| **break** | Innermost loop | `break` | `break` | `break` | `break` | `break` | N/A | `!` (cut) |
| **return** | Current function | `return` | `return` | `return` | `return` | `return` | N/A (pattern match) | N/A |
| **exit** | Entire program | `exit()` | `System.exit()` | `sys.exit()` | `process::exit()` | `exit()` | `exitWith` | `halt` |

---

## Exceptions

An **exception** is an "exceptional" or unexpected condition that disrupts normal control flow. Common examples:

- **Arithmetic** -- division by zero, overflow
- **Array access** -- index out of bounds
- **I/O** -- file not found, permission denied
- **Memory** -- allocation failure, null pointer dereference

An exception is **thrown** (or *raised* / *signaled*) when the condition occurs, and **caught** (or *handled*) by an exception handler.

### Languages Without Exception Handling

In early languages (and in C), there is no built-in exception mechanism. A division by zero simply crashes.

```c
// C -- no exception handling; this crashes with a signal
x = 0;
z = y / x;  // SIGFPE -> core dump
```

C programmers must handle errors via return codes, `errno`, or `setjmp`/`longjmp`. This leads to deeply nested conditional checks and **error code bloat**:

```c
errorCodeType readFile() {
    int errorCode = 0;
    open the file;
    if (theFileIsOpen) {
        determine the length;
        if (gotTheFileLength) {
            allocate memory;
            if (gotEnoughMemory) {
                read into memory;
                if (readFailed) {
                    errorCode = -1;
                }
            } else { errorCode = -2; }
        } else { errorCode = -3; }
        close the file;
        if (!theFileDidClose && errorCode == 0) {
            errorCode = -4;
        }
    } else { errorCode = -5; }
    return errorCode;
}
```

This code buries the actual logic under layers of error checking. Exception handling addresses this directly.

### The Clean Version -- Why Exceptions Improve Code Clarity

```java
void readFile() {
    try {
        open the file;
        determine its size;
        allocate that much memory;
        read the file into memory;
        close the file;
    } catch (FileOpenException e) {
        handleOpenError();
    } catch (SizeException e) {
        handleSizeError();
    } catch (MemoryException e) {
        handleMemoryError();
    } catch (ReadException e) {
        handleReadError();
    } catch (CloseException e) {
        handleCloseError();
    }
}
```

The logic is **clear and linear** -- the happy path reads top-to-bottom, and error handling is separated into its own section.

### Key Design Questions for Exception Systems

| Question | Description |
|---|---|
| **User-defined exceptions?** | Can programmers define their own exception types beyond built-in ones? |
| **Explicit raising?** | Can predefined exceptions be raised manually? |
| **Handler binding** | How is an exception matched to its handler? |
| **Continuation** | Where does execution resume after handling? |
| **Finalization** | Is there a guaranteed cleanup block (`finally`)? |
| **Information passing** | What data can the exception carry to the handler? |
| **Missing handler** | What happens if no handler matches? |
| **Propagation** | Can unhandled exceptions travel up the call stack? |

### Exception Handling Across Languages

#### C++

```cpp
try {
    // Code that might throw
    throw SomeExceptionType();
} catch (const SomeExceptionType& e) {
    // Handler for SomeExceptionType
} catch (const AnotherType& e) {
    // Handler for AnotherType
} catch (...) {
    // Catch-all handler
}
```

**C++ specifics:**

- Only user-defined exceptions; standard library provides predefined types like `std::overflow_error`, `std::runtime_error`.
- `throw` specifications (deprecated in C++17, removed in C++20; replaced by `noexcept`).
- No `finally` block -- relies on **RAII** (Resource Acquisition Is Initialization) for cleanup; destructors run automatically when objects go out of scope.
- If a function overrides another, it cannot throw *more* exceptions than the base.

#### Java

```java
try {
    x = 0;
    z = y / x;  // throws ArithmeticException
    x = z;      // skipped -- continuation is at end of try block
} catch (ArithmeticException e) {
    System.out.println("Division by zero");
    z = 0;
} finally {
    // Always executes, whether or not an exception occurred
}
```

**Java specifics:**

- Exceptions are **objects** -- instances of classes descending from `Exception`.
- **Checked vs. unchecked**: checked exceptions (`IOException`) must be declared or caught; unchecked (`NullPointerException`) need not be.
- Multiple `catch` clauses tried in order; first matching handler wins.
- Handler matches if the exception *is-a* (inheritance) match.
- `finally` block guarantees cleanup.
- Continuation is at the **end of the try block**.
- Methods declare thrown exceptions: `public void read() throws IOException`.

```java
// User-defined exception
class MyException extends Exception {
    public MyException(String msg) {
        super(msg);
    }
}
```

#### Python

```python
try:
    result = 10 / 0
except ZeroDivisionError as e:
    print(f"Caught: {e}")
except (TypeError, ValueError) as e:
    print(f"Type or value error: {e}")
else:
    print("No exception occurred")  # runs only if try succeeded
finally:
    print("Always runs")
```

**Python specifics:**

- `raise` to throw; `assert` for debug-time invariant checks.
- `else` clause (unique to Python) runs only when no exception was raised.
- All exceptions inherit from `BaseException`; user exceptions should extend `Exception`.
- No checked exceptions -- all are unchecked.
- Rich traceback information automatically available.

#### Dart

```dart
try {
    var result = 10 ~/ 0;  // integer division by zero
} on IntegerDivisionByZeroException {
    print("Can't divide by zero");
} on FormatException catch (e) {
    print("Format error: $e");
} catch (e, stackTrace) {
    print("Unknown error: $e");
    print("Stack trace: $stackTrace");
} finally {
    print("Always runs");
}
```

**Dart specifics:**

- **Any object** can be thrown (not just Exception subclasses), though this is discouraged.
- `on` keyword filters by type; `catch` captures the exception object.
- `rethrow` keyword re-throws the current exception preserving the stack trace.
- No checked exceptions.
- `finally` for cleanup.

```dart
// Dart -- user-defined exception
class InsufficientFundsException implements Exception {
    final double amount;
    InsufficientFundsException(this.amount);
    String toString() => "Insufficient funds: needed $amount";
}

// Throwing
throw InsufficientFundsException(100.0);
```

#### Rust -- A Different Philosophy

Rust **does not have exceptions**. Instead, it uses the **type system** for error handling:

```rust
// Rust -- Result type for recoverable errors
fn divide(a: f64, b: f64) -> Result<f64, String> {
    if b == 0.0 {
        Err(String::from("Division by zero"))
    } else {
        Ok(a / b)
    }
}

// Caller MUST handle the Result
match divide(10.0, 0.0) {
    Ok(val) => println!("Result: {}", val),
    Err(e) => println!("Error: {}", e),
}

// The ? operator for concise error propagation
fn do_math() -> Result<f64, String> {
    let val = divide(10.0, 2.0)?;  // propagates Err automatically
    Ok(val * 2.0)
}
```

- `Result<T, E>` for recoverable errors; `Option<T>` for nullable values.
- `panic!()` for unrecoverable errors (analogous to `exit()`).
- **No hidden control flow** -- every possible error is visible in the function signature.
- The `?` operator provides concise error propagation (similar to checked exceptions, but enforced by the type system).

#### Gleam -- Following Rust's Lead

Gleam also uses `Result` types instead of exceptions, inheriting this philosophy from both Rust and Erlang/OTP:

```gleam
// Gleam -- Result type
fn divide(a: Float, b: Float) -> Result(Float, String) {
    case b == 0.0 {
        True -> Error("Division by zero")
        False -> Ok(a /. b)
    }
}

// Pattern match to handle
case divide(10.0, 0.0) {
    Ok(val) -> io.println(float.to_string(val))
    Error(msg) -> io.println("Error: " <> msg)
}

// use keyword for early return on error (like Rust's ?)
fn do_math() -> Result(Float, String) {
    use val <- result.try(divide(10.0, 2.0))
    Ok(val *. 2.0)
}
```

**Gleam specifics:**

- No exceptions at all -- the language has no `try`/`catch` construct.
- `Result(value, error)` is the standard error type.
- `use` expressions provide monadic error propagation.
- Runs on the BEAM VM, so Erlang's process-level error isolation provides a safety net.

#### Go -- Explicit Error Returns

```go
// Go -- errors are values
func divide(a, b float64) (float64, error) {
    if b == 0 {
        return 0, fmt.Errorf("division by zero")
    }
    return a / b, nil
}

result, err := divide(10, 0)
if err != nil {
    log.Fatal(err)
}
```

- No exceptions; errors are returned as values.
- `defer` provides finalization (similar to `finally`).
- `panic`/`recover` exists but is reserved for truly exceptional situations.

#### Haskell -- Pure Functional Error Handling

Haskell uses multiple mechanisms depending on the context:

```haskell
-- Maybe for computations that might fail
safeDivide :: Double -> Double -> Maybe Double
safeDivide _ 0 = Nothing
safeDivide a b = Just (a / b)

-- Either for errors with information
safeDivide' :: Double -> Double -> Either String Double
safeDivide' _ 0 = Left "Division by zero"
safeDivide' a b = Right (a / b)

-- Using do-notation for chaining (monadic error propagation)
compute :: Either String Double
compute = do
    x <- safeDivide' 10.0 2.0
    y <- safeDivide' x 3.0
    return (y + 1)

-- IO exceptions for impure code
import Control.Exception
main = do
    result <- try (readFile "missing.txt") :: IO (Either IOException String)
    case result of
        Left err  -> putStrLn ("Error: " ++ show err)
        Right contents -> putStrLn contents
```

**Haskell specifics:**

- Pure code uses `Maybe` and `Either` (no exceptions).
- Impure (IO) code can throw and catch exceptions via `Control.Exception`.
- `error` function for unrecoverable errors (like `panic!` in Rust).
- Monadic chaining (`>>=` or do-notation) provides elegant error propagation.

#### Prolog -- Failure and Backtracking as Error Handling

Prolog's primary control mechanism (backtracking) naturally handles many "error" cases:

```prolog
% Prolog -- catch and throw for exceptions
safe_divide(_, 0, _) :- throw(division_by_zero).
safe_divide(X, Y, Result) :- Result is X / Y.

% Catching
main :-
    catch(
        safe_divide(10, 0, R),
        division_by_zero,
        (write('Cannot divide by zero'), nl)
    ).
```

**Prolog specifics:**

- `catch(Goal, Catcher, Recovery)` is the exception mechanism.
- `throw(Term)` raises an exception with any term.
- Failure (`fail`) is not an exception -- it triggers backtracking.
- The cut-fail combination (`!, fail`) implements negation-as-failure.

#### PostScript -- Error Handling on the Stack

```postscript
% PostScript -- stopped operator acts like try-catch
{ 0 div } stopped   % pushes true on stack if error occurred
{ (Error caught!) print } if

% PostScript -- error dictionary
errordict /undefined {
    (Undefined variable!) print
} put
```

**PostScript specifics:**

- `stopped` operator catches errors from the enclosed procedure.
- Pushes a boolean on the stack indicating whether an error occurred.
- Error handlers can be customized via the `errordict` dictionary.
- No user-defined exception types -- errors are identified by name.

### Comprehensive Exception Comparison

| Feature | C | C++ | Java | Python | Dart | Rust | Gleam | Haskell | Prolog | PostScript |
|---|---|---|---|---|---|---|---|---|---|---|
| **Mechanism** | errno / return codes | try/catch/throw | try/catch/finally | try/except/else/finally | try/on/catch/finally | Result/Option | Result | Maybe/Either + IO exceptions | catch/throw | stopped |
| **User-defined** | N/A | Yes (classes) | Yes (extends Exception) | Yes (extends Exception) | Yes (implements Exception) | Yes (impl Error) | Yes (custom types) | Yes (custom types) | Yes (any term) | via errordict |
| **Checked** | N/A | No | Yes | No | No | Yes (via types) | Yes (via types) | Partial (pure vs IO) | No | No |
| **Finally/cleanup** | N/A | RAII (destructors) | `finally` | `finally` | `finally` | Drop trait (RAII) | N/A | `bracket` | N/A (use catch) | N/A |
| **Propagation** | Manual | Auto up stack | Auto up stack | Auto up stack | Auto up stack | Explicit `?` | Explicit `use` | Auto in IO; explicit in pure | Auto up stack | Manual |
| **Catch-all** | N/A | `catch (...)` | `catch (Exception e)` | `except Exception` | `catch (e)` | N/A | N/A | `catch SomeException` | `catch(_,_,_)` | `stopped` |

### Exception Propagation

Exceptions can propagate **up the call stack**. If a method does not handle an exception, it passes to its caller, and so on until a handler is found or the program terminates.

```java
// Java -- propagation example
void method1() {
    try {
        method2();
    } catch (Exception e) {
        // Handles exceptions from method2 or method3
    }
}

void method2() throws Exception {
    method3();  // does not handle, propagates
}

void method3() throws Exception {
    readFile();  // throws if file I/O fails
}
```

**Propagation in Rust/Gleam (explicit):**

```rust
// Rust -- the ? operator chains propagation
fn method1() -> Result<(), MyError> {
    let val = method2()?;  // propagates if Err
    Ok(())
}

fn method2() -> Result<i32, MyError> {
    let val = method3()?;  // propagates if Err
    Ok(val + 1)
}
```

The key difference: in Java/Python/Dart, propagation is **implicit** (unhandled exceptions automatically bubble up). In Rust/Gleam, propagation is **explicit** (you must use `?` or `use`).

| Question | Description |
|---|---|
| **User-defined exceptions?** | Can programmers define their own exception types beyond built-in ones? |
| **Explicit raising?** | Can predefined exceptions be raised manually? |
| **Handler binding** | How is an exception matched to its handler? |
| **Continuation** | Where does execution resume after handling? |
| **Finalization** | Is there a guaranteed cleanup block (`finally`)? |
| **Information passing** | What data can the exception carry to the handler? |
| **Missing handler** | What happens if no handler matches? |
| **Propagation** | Can unhandled exceptions travel up the call stack? |

---

## Control Structures in CS4700 Languages

A summary of how each language studied in CS4700 approaches control flow, highlighting what makes each unique.

### PostScript (Stack-Based, Concatenative)

PostScript has **no variables in the traditional sense**. Control structures operate on the operand stack using executable procedures (code blocks in curly braces):

```postscript
% Conditional
x 0 gt { (positive) print } { (negative) print } ifelse

% Definite loop (for)
1 1 10 { dup mul == } for       % prints squares of 1-10

% Iterate over array
[10 20 30] { == } forall

% Indefinite loop with exit
{ currentfile read not { exit } if  process } loop

% Repeat n times
5 { (hello ) print } repeat
```

**Key insight:** Control flow operators (`if`, `ifelse`, `for`, `loop`) consume their arguments from the stack. Code blocks `{ }` are first-class objects that can be passed to any operator.

### Rust (Systems, Ownership-Based)

Rust's control structures emphasize **expressions over statements** and **exhaustiveness**:

```rust
// if is an expression
let x = if condition { 1 } else { 2 };

// match must be exhaustive
let msg = match status {
    Status::Ok => "fine",
    Status::Error(code) => format!("error {}", code),
    // compiler error if a variant is missing
};

// loop is an expression (can return values via break)
let result = loop {
    if done() { break 42; }
};

// while let -- loop + pattern matching
while let Some(item) = iterator.next() {
    process(item);
}

// if let -- single-pattern match
if let Some(val) = maybe_value {
    use_val(val);
}

// No exceptions -- Result and Option types
fn risky() -> Result<i32, Error> { ... }
```

### Haskell (Pure Functional, Lazy)

Haskell has **no imperative loops**. All "iteration" is recursion or higher-order functions:

```haskell
-- Guards replace if-else chains
bmi x
    | x < 18.5  = "underweight"
    | x < 25.0  = "normal"
    | x < 30.0  = "overweight"
    | otherwise  = "obese"

-- Pattern matching on constructors
describe :: [a] -> String
describe []     = "empty"
describe [_]    = "singleton"
describe (_:_)  = "multiple elements"

-- "Loops" via recursion
factorial 0 = 1
factorial n = n * factorial (n - 1)

-- "Loops" via higher-order functions
sumSquares = sum . map (^2) . filter even $ [1..100]

-- List comprehension
pairs = [(x, y) | x <- [1..5], y <- [1..5], x /= y]

-- Monadic sequencing for effects
main = do
    line <- getLine
    putStrLn ("You said: " ++ line)
```

**Key insight:** Haskell's laziness means even "infinite" data structures work -- `take 10 [1..]` evaluates only what's needed.

### Prolog (Logic, Declarative)

Prolog's control flow is fundamentally different -- it is driven by **unification and backtracking**:

```prolog
% "Selection" via multiple clauses
factorial(0, 1) :- !.
factorial(N, F) :-
    N > 0,
    N1 is N - 1,
    factorial(N1, F1),
    F is N * F1.

% "Iteration" via recursion
print_list([]).
print_list([H|T]) :-
    write(H), nl,
    print_list(T).

% Backtracking as control flow
member(X, [X|_]).
member(X, [_|T]) :- member(X, T).

% If-then-else
max(X, Y, Max) :-
    ( X >= Y -> Max = X ; Max = Y ).

% Cut (!) prevents backtracking -- commits to a choice
classify(X, positive) :- X > 0, !.
classify(X, negative) :- X < 0, !.
classify(0, zero).

% findall -- collect all solutions
all_evens(List, Evens) :-
    findall(X, (member(X, List), X mod 2 =:= 0), Evens).
```

**Key insight:** Prolog has no `for`, `while`, or `break`. Backtracking **is** the control structure. The cut (`!`) is the only way to "break" out of it.

### Dart (Object-Oriented, Async-Ready)

Dart provides familiar imperative control structures plus modern async flow:

```dart
// Standard if/else, switch, for, while, do-while (like Java)

// Switch expressions with patterns (Dart 3.0+)
var description = switch (shape) {
    Circle(radius: var r) => 'circle with radius $r',
    Square(side: var s)   => 'square with side $s',
    _                     => 'unknown shape',
};

// for-in with iterables
for (var item in collection) {
    print(item);
}

// Async control flow -- a distinguishing feature
Future<String> fetchData() async {
    try {
        var response = await http.get(url);
        return response.body;
    } catch (e) {
        return 'Error: $e';
    }
}

// Async iteration
await for (var event in stream) {
    process(event);
}

// Null-aware operators as lightweight control flow
var name = user?.name ?? 'Anonymous';
```

**Key insight:** Dart's `async`/`await` transforms callbacks into sequential-looking code, effectively creating a new kind of structured control flow for asynchronous operations.

### Gleam (Functional, BEAM-Based)

Gleam is deliberately minimal -- it has **no loops, no if statements, no exceptions**:

```gleam
// case is the ONLY branching construct
let result = case value {
    0 -> "zero"
    n if n > 0 -> "positive"
    _ -> "negative"
}

// "Iteration" via recursion
fn sum(list: List(Int)) -> Int {
    case list {
        [] -> 0
        [first, ..rest] -> first + sum(rest)
    }
}

// Higher-order functions (preferred over manual recursion)
let total = list.fold(numbers, 0, fn(acc, x) { acc + x })
let evens = list.filter(numbers, fn(x) { x % 2 == 0 })

// Error handling via Result
fn parse(input: String) -> Result(Int, String) {
    case int.parse(input) {
        Ok(n) -> Ok(n * 2)
        Error(_) -> Error("Not a number")
    }
}

// use for monadic chaining (like Rust's ?)
fn process() -> Result(String, Error) {
    use data <- result.try(fetch_data())
    use parsed <- result.try(parse(data))
    Ok(format(parsed))
}
```

**Key insight:** Gleam proves that `case` + recursion + higher-order functions can replace every traditional control structure. The compiler's exhaustiveness checking catches missing branches at compile time.

### Raku (Multi-Paradigm, Expressive)

Raku (formerly Perl 6) has the most diverse control structure syntax of any language in the course:

```raku
# Postfix conditionals
$max = $y if $y > $max;
$max = $x unless $x < $max;

# given/when (smart matching)
given $x {
    when 1..10   { say "small" }
    when 11..100 { say "medium" }
    when Int     { say "some integer" }
    default      { say "something else" }
}

# Loop forms
loop (my $i = 0; $i < 10; $i++) { say $i }    # C-style
for @array -> $item { say $item }               # iterator
while condition() { do_something() }            # while
repeat { do_something() } while condition();    # do-while
repeat { do_something() } until condition();    # do-until

# Loop control
for @items -> $item {
    next if $item eq "skip";   # continue
    last if $item eq "stop";   # break
}

# Labeled loops
OUTER: for @matrix -> @row {
    for @row -> $item {
        last OUTER if $item == target;
    }
}

# Junctions -- concurrent-like logic
if $x == any(1, 3, 5, 7) { say "odd single digit" }
```

**Key insight:** Raku's `given`/`when` uses smart matching, which adapts its behavior based on the types of the operands (regex match for strings, numeric comparison for numbers, type check for types, etc.).

---

## Comprehensive Cross-Language Comparison

### Control Structure Feature Matrix

| Feature | C | Java | Python | Rust | Dart | Haskell | Gleam | Prolog | PostScript | Raku |
|---|---|---|---|---|---|---|---|---|---|---|
| **if/else** | Statement | Statement | Statement | Expression | Statement | Expression | N/A (case) | `->` `;` | `ifelse` | Statement + postfix |
| **switch/match** | `switch` | `switch` | `match` | `match` | `switch` | `case` | `case` | Clause heads | dict lookup | `given/when` |
| **for loop** | Yes | Yes | `for-in` | `for-in` | Both | No (recursion) | No (recursion) | No (recursion) | `for`, `forall` | Yes + `for-in` |
| **while loop** | Yes | Yes | Yes | Yes | Yes | No | No | No | `loop` | Yes |
| **do-while** | Yes | Yes | No | No | Yes | No | No | No | No | `repeat...while` |
| **break** | Yes | Labeled | Yes | Labeled | Labeled | N/A | N/A | `!` (cut) | `exit` | `last` (labeled) |
| **continue** | Yes | Yes | Yes | Labeled | Yes | N/A | N/A | `fail` | N/A | `next` (labeled) |
| **goto** | Yes | No | Module only | No | No | No | No | No | No | No |
| **Exceptions** | No | try/catch | try/except | Result type | try/on/catch | Maybe/Either | Result type | catch/throw | `stopped` | try/CATCH |
| **Exhaustive match** | No | Partial | No | Yes | Yes | Warnings | Yes | No | No | No |

### Error Handling Philosophy Spectrum

```
Exceptions <-------------------------------------------> Type-Based Errors
  (implicit propagation, runtime)                    (explicit propagation, compile-time)

  Java     Python    Dart    C++    Prolog    Go    Haskell    Rust    Gleam
  |--------|---------|-------|-------|---------|------|---------|-------|
  traditional try/catch       values/backtrack    Result/Maybe/Either
```

---

---

## Summary -- Control Structure Design Philosophy

| Era | Philosophy | Languages |
|---|---|---|
| **1950s--60s** | Unstructured (`goto` everywhere) | Assembly, early FORTRAN, COBOL |
| **1970s** | Structured programming (SESE) | Pascal, C |
| **1980s** | Logic/declarative control | Prolog (backtracking as control) |
| **1980s--90s** | OOP + exceptions | C++, Java |
| **1990s--2000s** | Stack/concatenative | PostScript (stack-based control) |
| **2000s** | Multi-paradigm expressiveness | Raku (smart matching, postfix conditionals) |
| **2010s** | Expression-based, exhaustive matching | Rust, Dart 3.0, Haskell |
| **2020s** | Minimal (case + recursion only) | Gleam (no loops, no if, no exceptions) |

### Key Takeaways

1. **Every language needs selection and iteration** -- but the mechanisms range from `goto` to pattern matching to backtracking.
2. **Expression-based control** (Rust, Haskell, Gleam) eliminates uninitialized variable bugs and encourages totality.
3. **Exhaustive matching** (Rust, Gleam, Haskell) forces programmers to handle all cases at compile time.
4. **Recursion can replace all loops** (Haskell, Gleam, Prolog) -- functional and logic languages prove this with tail-call optimization.
5. **Error handling is converging on two camps**: traditional exceptions (Java, Python, Dart) vs. type-based errors (Rust, Gleam, Haskell, Go).
6. **PostScript demonstrates** that control structures need not be syntactic keywords -- they can be stack operators consuming code blocks.
7. **Prolog demonstrates** that control flow need not be programmer-directed -- backtracking lets the runtime explore possibilities.

---

## References

- Watt, David. *Programming Language Concepts and Paradigms*, Chapters 3 and 8.
- Sebesta, Robert. *Concepts of Programming Languages*, Chapter 8.
- Sebesta, Robert. *Programming Languages*, 6th ed., Chapter 14.
- Dijkstra, Edsger. ["Go To Statement Considered Harmful"](https://dl.acm.org/doi/10.1145/362929.362947), 1968.
- *Brewing Java: A Tutorial*.