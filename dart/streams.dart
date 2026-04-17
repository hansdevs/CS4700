flatten(aList) {
  if (aList == null) return null;
  var result = [];
  for (var sublist in aList) {
    if (sublist == null) continue;
    for (var item in sublist) {
      if (item == null) continue;
      result.add(item);
    }
  }
  return result;
}

deepen(aList) {
  if (aList == null) return null;
  if (aList.isEmpty) return [];
  if (aList.length == 1) return [aList[0]];
  return [aList[0], deepen(aList.sublist(1))];
}

Stream<int> Function() fibonacciNumbers(int n) {
  return () async* {
    int a = 0;
    int b = 1;
    for (int i = 0; i <= n; i++) {
      await Future<void>.delayed(const Duration(seconds: 1));
      yield a;
      int temp = a + b;
      a = b;
      b = temp;
    }
  };
}

Stream<int> Function() streamFilter(Stream<int> stream, bool Function(int) f) {
  return () async* {
    await for (var item in stream) {
      if (f(item)) {
        yield item;
      }
    }
  };
}

Stream<int> Function() streamAccumulation(Stream<int> stream, int Function(int, int) f, initial) {
  var acc = initial;
  return () async* {
    await for (var item in stream) {
      acc = f(item, acc);
      yield acc;
    }
  };
}

Stream<int> Function() generateNumbers(int n) {
  final Stream<int> Function() func = (() async* {
    for (int i = 1; i <= n; i++) {
      await Future<void>.delayed(const Duration(seconds: 1));
        yield i;
      }
    });
  return func;
}

void main(List<String> arguments) async {
  print( 'flattening [[0,1], [2]] yields ${flatten([[0,1], [2]])}');
  print( 'flattening [[0,1], [2], null] yields ${flatten([[0,1], [2], null])}');
  print( 'flattening [[0,1, null], [2]] yields ${flatten([[0,1, null], [2]])}');
  print( 'flattening null yields ${flatten(null)}');
  print( 'flattening [null] yields ${flatten([null])}');
  print( 'deepening [0,1,2] yields ${deepen([0,1,2])}');
  print( 'deepening [0,null,2] yields ${deepen([0,null,2])}');
  print( 'deepening [0] yields ${deepen([0])}');
  print( 'deepening [] yields ${deepen([])}');
  print( 'deepening null yields ${deepen(null)}');
  await for (final number in fibonacciNumbers(7)()) {
    print ('fibonnaci number is ${number}');
  }
  await for (final number in streamFilter(generateNumbers(10)(), ((a) {return a % 2 == 0;}))()) {
    print ('filtered number is $number');
  }
 
  await for (final number in streamAccumulation(generateNumbers(10)(),((a,b) {return a+b;}),0)()) {
      print ('cumulative number is $number.');
  }  
}



