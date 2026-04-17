# CS4700 Quiz Answers

---

## Question 1 (2 pts)

If the following Java method were to be invoked, where would "x" be allocated?

```java
int computeMaximum(int x, int y) {
  return (x > y) ? x : y;
}
```

- **the stack**
- code area in memory
- none of the others
- the heap
- static area in memory

> `x` is a local parameter — gets allocated on the stack frame of the method call.

---

## Question 2 (2 pts)

Suppose that Prolog has type inference like Haskell. What would the inferred type of the prolog rule `elem` be assuming the first argument is an "input" and the second argument is the "output"?

```prolog
elem([],[]).
elem([Head|Tail],[[Head|NewList]]) :-
    elem(Tail,NewList).
```

- [a] -> [b]
- [a] -> [a]
- **[a] -> [[a]]**
- [[a]] -> [b]
- [[a]] -> [[a]]

> The first arg is a flat list `[a]`. The second wraps each element in a sublist, producing `[[a]]`.

---

## Question 3 (2 pts)

Consider the following program in a Dart-like language (execution begins with `main`).

```dart
int exchange(int x, int y) {
  x = y + 1;
  y = x - 1;
  return x;
}

void main() {
  int i = 1;
  List<int> lst = [0, 1, 2];
  exchange(i, lst[i]);
  print(i);    print(' ');
  print(lst[0]); print(' ');
  print(lst[1]); print(' ');
  print(lst[2]);
}
```

Assume eager, left-to-right evaluation. What is printed when all parameters are **passed-by-value**?

- 2 0 1 1
- 2 1 1 2
- 2 0 1 2
- 1 0 0 2
- **1 0 1 2**

> Pass-by-value: `x` and `y` are copies. Changes inside `exchange` don't affect `i` or `lst`. Everything stays the same.

---

## Question 4 (2 pts)

Same program. What is printed when all parameters are **passed-by-reference**?

- 2 1 1 2
- 2 0 1 1
- 1 0 0 2
- 1 0 1 2
- **2 0 1 2**

> `x` aliases `i`, `y` aliases `lst[1]`. `x = y + 1` → `i = 1+1 = 2`. `y = x - 1` → `lst[1] = 2-1 = 1`. Result: `i=2`, `lst=[0,1,2]`.

---

## Question 5 (2 pts)

Same program. What is printed when all parameters are **passed-by-name**?

- **2 0 1 1**
- 1 0 0 2
- 2 1 1 2
- 2 0 1 2
- 1 0 1 2

> Pass-by-name re-evaluates the expression each time. `x = y + 1` → `i = lst[i] + 1 = lst[1] + 1 = 2`. Now `i=2`. `y = x - 1` → `lst[i] = i - 1` → `lst[2] = 2-1 = 1`. Result: `i=2`, `lst=[0,1,1]`.

---

## Question 6 (2 pts)

```dart
int y = 20;

void myFunc() { print y; }

void outerFunction() {
  void innerFunction(void Function() passedFunction) {
    int y = 22;
    return passedFunction();
  }
  int y = 25;
  innerFunction(myFunc);
}

void main() {
  outerFunction();
}
```

Assume **deep binding**. What is printed?

- **25**
- 20
- 22
- it cannot be determined
- 23

> Deep binding captures the referencing environment at the point the function is passed as an argument. When `innerFunction(myFunc)` is called, `y = 25` is in scope. That's what `myFunc` sees.

---

## Question 7 (2 pts)

Same program. Assume **shallow binding**. What is printed?

- 23
- **22**
- 25
- it cannot be determined
- 20

> Shallow binding uses the most recent binding of `y` at the time `passedFunction()` is actually called. Inside `innerFunction`, `y = 22`, so that's what gets printed.

---

## Question 8 (2 pts)

```dart
int outer(int x) {
  int inner(int y) {
    // <-- Execution reaches here
    return y - 1;
  }
  if (x == 1) return inner(x);
  return outer(x - 1);
}

int main() {
  int w = 3;
  return outer(w);
}
```

When execution reaches the indicated place, the stack frames from bottom to top are:

- **main, outer, outer, outer, inner**
- main, outer
- main, outer, outer, inner (outer called itself recursively once)
- none of the other answers
- main, outer, inner

> `main` → `outer(3)` → `outer(2)` → `outer(1)` → `inner(1)`. That's 5 frames.

---

## Question 9 (2 pts)

Java passes parameters using which of the following?

- pass-by-need
- pass-by-reference
- pass-by-value-result
- pass-by-name
- **pass-by-value**

> Java always passes by value. Even object references are copied (passed by value).

---

## Question 10 (2 pts)

Given the following regular expression:

```
a (b | c)* a (a | c)+
```

Which of the following strings is accepted?

- **acacaccaaacc**
- aabcaac
- aca
- aa
- abcabccaa

> Parse: `a` + `c` (matches `(b|c)*`) + `a` + `caccaaacc` (all a's and c's, matches `(a|c)+`). The others either contain invalid chars for their position or are too short.

---

## Question 11 (2 pts)

Consider the following grammar. Nonterminals are lowercase and terminals are uppercase.

```
s -> c A B
c -> c B | d
d -> A d | A
```

Which of the following sentences is in the language?

- ABABAB
- BBABAB
- **AAAB**
- BAABAB
- AAABA

> `d → A d → A A`, so `c → d → AA`. Then `s → c A B → AA A B → AAAB`. The others either start with B (impossible since d always starts with A) or don't end with B (s always ends with AB).

---

## Question 12 (2 pts)

Suppose Java-t is like Java but has type inference like Haskell. What would the type of `foo` be?

```java
foo (a, b) {
  return (a == 0) ? b : "good-bye";
}

main () {
  x = 3;
  y = "hello";
  foo(x, y)
}
```

- Int -> String
- **Int, String -> String**
- Int, Int -> String
- String, String -> Boolean
- Int, String -> Boolean

> `a` is compared to `0` so it's `Int`. The ternary returns `b` or `"good-bye"` — both must be `String`, so `b` is `String`. Return type is `String`.
