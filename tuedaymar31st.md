# Control Structures in Programming Languages

> **CS 4700 -- March 31st**

---

## What Is a Control Structure?

A **control structure** is a control statement together with the collection of statements whose execution it governs. Control structures dictate the order in which instructions execute and are one of the most fundamental aspects of any programming language.

Every imperative language provides at least:

| Structure | Purpose | Classic C Example |
|---|---|---|
| **Selection** | Choose one path based on a condition | `if / else` |
| **Multiple Selection** | Choose one of many paths | `switch` |
| **Definite Iteration** | Repeat a known number of times | `for` |
| **Indefinite Iteration** | Repeat until a condition changes | `while`, `do...while` |

### Why This Common Set?

All of these structures can ultimately be reduced to **goto** instructions at the machine level. The seminal 1968 paper *"Go To Statement Considered Harmful"* by Edsger Dijkstra argued that undisciplined use of `goto` makes programs unreadable and error-prone. Structured control flow offers:

- **Disciplined branching** -- gotos are still used under the hood, but the programmer works with higher-level abstractions.
- **Common pattern recognition** -- selection, iteration, and sequencing cover the vast majority of control flow needs.
- **Readability and maintainability** -- structured code is easier for humans to follow.
- **Safety** -- prevents dangerous patterns like branching into the middle of a subroutine.
- **Lexical coherence** -- related code stays together visually and logically.

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
| Go | `go func()` goroutines | Lightweight concurrent execution; ordering is non-deterministic without synchronization |
| Erlang | `spawn(Fun)` | Message-passing concurrency; no shared state |
| Rust | `std::thread::spawn` | Ownership model prevents data races at compile time |
| Java | `Thread`, `ExecutorService` | Shared-memory concurrency; requires explicit synchronization |

---

## Conditional Commands

A conditional command selects **exactly one** subcommand to execute based on a condition (the *guard*).

### if-then-else Across Languages

```c
// C
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

```perl
# Perl -- note the special elsif keyword for chaining
if (E) {
    C1;
} elsif (E2) {
    C2;
} else {
    C3;
}
```

```rust
// Rust -- if is an expression, not just a statement
let result = if x > 0 { "positive" } else { "non-positive" };
```

```kotlin
// Kotlin -- also expression-based
val result = if (x > 0) "positive" else "non-positive"
```

**Key comparison:** In C, Java, and Pascal, `if` is a *statement*. In Rust, Kotlin, Scala, and Haskell, `if` is an *expression* that produces a value. This eliminates an entire class of bugs related to uninitialized variables.

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

### Case / Switch Statements

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

```haskell
-- Haskell -- pattern matching in function definitions
describe 1 = "one"
describe 2 = "two"
describe _ = "other"
```

**Critical differences:**

| Language | Fall-through? | Exhaustiveness Check? | Expressions? | Pattern Matching? |
|---|---|---|---|---|
| C | Yes (implicit) | No | No | No |
| Java (classic) | Yes (implicit) | No | No | No |
| Java 14+ | No (arrow syntax) | Yes (switch expressions) | Yes | Limited |
| Python 3.10+ | No | No | No | Yes (structural) |
| Rust | No | Yes (compile-time) | Yes | Yes (full) |
| Haskell | No | Yes (with warnings) | Yes | Yes (full) |
| COBOL | No | No | No | No |

**Historical note:** COBOL used the keyword `CASE` for a computed goto. When a structured case statement was later added to the language, the keyword `WHEN` had to be used instead to avoid conflict.

**Pascal quirk:** The original Pascal specification did not define behavior when no case tag matched. Implementations varied: some ignored the mismatch, some raised a runtime error, and some extended the language with a default clause.

---

## Iterative Commands

### Two Fundamental Classes

| Class | Description | Typical Form |
|---|---|---|
| **Definite** | Number of iterations known before the loop starts | `for` loop |
| **Indefinite** | Number of iterations unknown; depends on a runtime condition | `while`, `do...while` |

### Repeat Loop (Post-Test)

The continuation/exit condition is evaluated **after** the loop body, so the body always executes **at least once**.

```c
// C
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

```rust
// Rust -- no built-in do-while; idiomatic alternative:
loop {
    C;
    if !E { break; }
}
```

### While Loop (Pre-Test)

The condition is evaluated **before** the body. The body may execute **zero** times.

```c
// C
while (E) {
    C;
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

C does not have a native mid-test loop, but the `break` statement inside an infinite loop achieves the same effect:

```c
// C -- general loop via break
for (;;) {
    ch = getchar();
    if (ch == '*') break;
    printf("%c", ch);
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

Most structured control constructs follow the **single-entry, single-exit** (SESE) model. They can be composed like building blocks ("tinker toys"), and reasoning about them is straightforward.

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

### Breaking Out of Nested Loops -- Language Comparison

The problem: `break` in C/Java only exits one level. How do we exit multiple levels?

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
// Rust -- labeled break (similar to Java)
'outer: loop {
    loop {
        if ch == 'q' { break 'outer; }
    }
}
```

```python
# Python -- no labeled break; common workaround is a flag or function
def search():
    for row in matrix:
        for val in row:
            if val == target:
                return val  # function return as escape
```

```perl
# Perl -- labeled loop control
OUTER: while (1) {
    while (1) {
        last OUTER if $ch eq 'q';  # exits both loops
    }
}
```

| Language | Multi-level break? | Mechanism |
|---|---|---|
| C | No | Use `goto`, flag variable, or `return` |
| Java | Yes | Labeled `break` |
| Python | No | Use `return` from function or flag |
| Rust | Yes | Labeled `break 'label` |
| Perl | Yes | `last LABEL` |
| Go | Yes | Labeled `break` |

### return -- General Escape from a Function

A `return` statement exits the entire function, regardless of nesting depth.

```c
while (...) {
    while (...) {
        if (ch == 'q') return;  // exits both loops AND the function
    }
}
```

### exit / halt -- Terminate the Program

The most drastic escape: terminate the entire process.

```c
// C
while (...) {
    while (...) {
        if (error) exit(return_code);  // terminates the program
    }
}
```

```python
# Python
import sys
sys.exit(1)
```

```java
// Java
System.exit(1);
```

```rust
// Rust
std::process::exit(1);
```

**Escalation hierarchy:**

| Level | Scope | C | Java | Python | Rust |
|---|---|---|---|---|---|
| break | Innermost loop | `break` | `break` / `break label` | `break` | `break` / `break 'label` |
| return | Current function | `return` | `return` | `return` | `return` |
| exit | Entire program | `exit(code)` | `System.exit(code)` | `sys.exit(code)` | `std::process::exit(code)` |

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
    x = z;      // skipped
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

#### Rust -- A Different Philosophy

Rust **does not have exceptions**. Instead, it uses the type system for error handling:

```rust
// Rust -- Result type for recoverable errors
fn divide(a: f64, b: f64) -> Result<f64, String> {
    if b == 0.0 {
        Err(String::from("Division by zero"))
    } else {
        Ok(a / b)
    }
}

// Caller must handle the Result
match divide(10.0, 0.0) {
    Ok(val) => println!("Result: {}", val),
    Err(e) => println!("Error: {}", e),
}

// Or use the ? operator for propagation
fn do_math() -> Result<f64, String> {
    let val = divide(10.0, 2.0)?;  // propagates Err automatically
    Ok(val * 2.0)
}
```

- `Result<T, E>` for recoverable errors; `Option<T>` for nullable values.
- `panic!()` for unrecoverable errors (analogous to `exit()`).
- **No hidden control flow** -- every possible error is visible in the function signature.
- The `?` operator provides concise error propagation (similar to checked exceptions, but enforced by the type system).

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

### Comprehensive Comparison

| Feature | C | C++ | Java | Python | Rust | Go |
|---|---|---|---|---|---|---|
| Exception mechanism | None (errno, return codes) | try/catch/throw | try/catch/finally | try/except/else/finally | Result/Option types | Error return values |
| User-defined exceptions | N/A | Yes (classes) | Yes (extends Exception) | Yes (extends Exception) | Yes (impl Error trait) | Yes (impl error interface) |
| Checked exceptions | N/A | No | Yes | No | Yes (via types) | No |
| Finally / cleanup | N/A | RAII (destructors) | `finally` | `finally` | `Drop` trait (RAII) | `defer` |
| Propagation | Manual | Automatic up stack | Automatic up stack | Automatic up stack | Explicit with `?` | Manual |
| Catch-all | N/A | `catch (...)` | `catch (Exception e)` | `except Exception` | N/A | `recover()` |
| Information passing | errno integer | Exception object | Exception object | Exception object | Error type with data | Error interface |

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

**The clean version with exceptions:**

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

---

## Summary -- Control Structure Design Philosophy

| Era | Philosophy | Example |
|---|---|---|
| **1950s--60s** | Unstructured (`goto` everywhere) | Assembly, early FORTRAN, COBOL |
| **1970s** | Structured programming (SESE) | Pascal, C |
| **1980s--90s** | Object-oriented exceptions | C++, Java |
| **2000s--10s** | Pattern matching, expression-based control flow | Scala, Rust, Kotlin |
| **2020s** | Algebraic error types, effect systems | Rust, Koka, Unison |

The evolution is clear: each generation of languages provides **more structured, more expressive, and safer** control flow mechanisms, progressively eliminating classes of bugs while maintaining (or improving) readability.

---

## References

- Watt, David. *Programming Language Concepts and Paradigms*, Chapters 3 and 8.
- Sebesta, Robert. *Concepts of Programming Languages*, Chapter 8.
- Sebesta, Robert. *Programming Languages*, 6th ed., Chapter 14.
- Dijkstra, Edsger. *"Go To Statement Considered Harmful"*, 1968.
- *Brewing Java: A Tutorial*.