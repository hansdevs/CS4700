## Thu Mar 19th




- Dart Review

```
CS 4700 Dart Calisthenics
 
Convert the following Postscript expressions to Dart .
1)         3 4 + 5 6 * -

(3 + 4) - (5 * 6)
	
2)         /x 7 def

var x = 7;
int x = 7;
const var x = 7;
const int x = 7;
final int x = 7;
final late int x;
       x = 7;
	
3)         /f { 
        /x exch def
        x x *
     } def
int f(int x) { return x * x}
var f = (int x) => x * x;


Give Dart functions for each of the following. The List collection class has many methods.

1)  Reverse a List, e.g., reverse([1,2,3]) would produce the List [3, 2, 1]
List<T> reverse (List<T> myList) {

}


2) A function to put each element in a list into a list, e.g, subListOf([1,2,3]) would produce List [[1], [2], [3]]
List<List<int>> subListOf(List<int> list) {
}
Make subListOf an extension method for List<int>.
extension on List<int> {
}
 
3) A function to apply a function to each pair of elements in a list, e.g, 
     pairs(((x, y) => x + y), [1,2,3,4,5]) 
would produce List [3, 7, 5]

List<Int> pairs (int Function(int, int) func, List<Int> list) 
{
	
}




Make pairs an extension method for List<int>.
extension on List<int> {
 
}

4) A function to turn a List into a Stream with a one second delay for each streamed value.
     stream([1,2,3]) 
would produce a Stream of values, 1, 2, 3 with a one second delay between each.





5) A Flutter app to draw a square (use square.dart as the starter code).
import 'package:flutter/material.dart';
class DrawSquare extends CustomPainter {
  /// Called when the canvas is (re)painted, draw the box here.
  @override
  void paint(Canvas canvas, Size size) {
     canvas.drawLine(const Offset(0,0), const Offset(200,200), Paint());
  }
  /// Always repaint
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}


```


## Resources

[Dart.dev](https://dart.dev/)

[types](https://dart.dev/language/built-in-types)

[code editor for dart](https://dartpad.dev)

Prof slides as well

- good idea to try with Flutter
