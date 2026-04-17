import gleam/io
import gleam/int
import gleam/list

/// The Backtrack State is an enumerated type with two states.  
///  It captures the state of backtracking
pub type BacktrackState {
  Failed
  Backtrack
}

pub fn main() {
  // Testing counting numbers
  echo counting_numbers(6)

  // Testing prime numbers
  echo prime_numbers(8)

  // Testing list of numbers
  echo lists_of_numbers(6, counting_numbers)
  echo lists_of_numbers(8, prime_numbers)
  echo lists_of_numbers(-1, counting_numbers)
  echo lists_of_numbers(1, prime_numbers)

  // Testing reachability
  echo can_reach(1, 2, [[4, 2], [2, 3], [1, 3], [3, 4]])
  echo can_reach(1, 2, [[4, 2], [2, 3], [5, 3], [3, 4]])
}

pub fn counting_numbers(n: Int) -> List(Int) {
  count_up(1, n)
}

pub fn prime_numbers(n: Int) -> List(Int) {
  case n < 2 {
    True -> []
    False -> sieve(count_up(2, n))
  }
}

pub fn lists_of_numbers(n: Int, f: fn(Int)->List(Int)) -> List(List(Int)) {
  counting_numbers(n)
  |> list.map(f)
}

pub fn can_reach(from: Int, to: Int, a: List(List(Int))) -> Result(List(List(Int)), BacktrackState) {
  case from == to {
    True -> Ok([])
    False -> {
      case search(from, to, a, a, [from]) {
        Ok(path) -> Ok(path)
        Error(_) -> Error(Failed)
      }
    }
  }
}

// helper to build a list from start to end
fn count_up(start: Int, end: Int) -> List(Int) {
  case start > end {
    True -> []
    False -> [start, ..count_up(start + 1, end)]
  }
}

// sieve of eratosthenes - filters out multiples recursively
fn sieve(numbers: List(Int)) -> List(Int) {
  case numbers {
    [] -> []
    [first, ..rest] -> {
      let filtered = list.filter(rest, fn(x) { x % first != 0 })
      [first, ..sieve(filtered)]
    }
  }
}

// backtracking search through graph edges
fn search(
  from: Int,
  to: Int,
  edges: List(List(Int)),
  graph: List(List(Int)),
  visited: List(Int),
) -> Result(List(List(Int)), BacktrackState) {
  case edges {
    [] -> Error(Backtrack)
    [edge, ..rest] -> {
      case edge {
        [x, y] -> {
          case x == from {
            True -> {
              case list.contains(visited, y) {
                True -> search(from, to, rest, graph, visited)
                False -> {
                  case y == to {
                    True -> Ok([[x, y]])
                    False -> {
                      // try going deeper, backtrack if stuck
                      case search(y, to, graph, graph, [y, ..visited]) {
                        Ok(path) -> Ok([[x, y], ..path])
                        Error(_) -> search(from, to, rest, graph, visited)
                      }
                    }
                  }
                }
              }
            }
            False -> search(from, to, rest, graph, visited)
          }
        }
        _ -> search(from, to, rest, graph, visited)
      }
    }
  }
}
