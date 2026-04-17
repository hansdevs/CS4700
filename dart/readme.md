Introduction
This assignment is to program several problems. It is to be your individual work.

Dart help
Follow the Resources link in Canvas to web sites that discuss Dart programming.

Dart IDE
You may use DartPadLinks to an external site. to code your assignment. Alternatively you may download and install DartLinks to an external site..

Starter Code
The starter code is available as streams.dart Download streams.dartand fractal.dart Download fractal.dart. You will put into your code into streams.dart and fractal.dart.  Both files contain code for running the tests, please leave the tests in the code that you turnin. 

Turnin
Use Canvas.

You will turnin two files: streams.dart and fractal.dart. Please use the exact names for the files you turnin (case-sensitive) since we automatically test the code using these file names.

Grading
The assignment will be graded for good programming style (indentation and appropriate comments), as well as clean compilation and execution. 10% of the grade will cover comments and style.

What to Do for Coding the Assignment
There are two main parts to the assignment.  The first part is about asynchronous programming with Streams.  The second part is about drawing in Flutter using canvas.

Part 1: Streams and Lists
The code for this part of the assignment should go into streams.dart.  It should contain the following functions (not within a class).

10% - Flatten a list of lists
Write the function

          flatten(aList)

to build and return a list composed of all of the sublists in the list.  The function should be null safe. If the list of lists is null then the function should return null.  If a sublist is null, then no elements should be appended to the result.  If a member of a sublist is null, then it should be skipped.

// returns [0, 1, 2]
flatten([[0,1], [2]])

// returns [0, 1, 2]       
flatten([[0,1], [2], null])

// returns [0, 1, 2]
flatten([[0,1,null], [2]])

// returns null
flatten(null)

// returns []
flatten([null,null])

// returns []
flatten([])
10% - Deepen a list
Write the function

          deepen(aList)

to build and return a list where the nth element is paired with a sublist starting from the n+1th element.  The final element should be in a sublist by itself.  The function should be null safe. If the list is null then the function should return null.  If an element is null then it should be included in the deep paring.

// returns [0, [1, [2]]]
deepen([0,1,2])

// returns [0]
deepen([0])

// returns []
deepen([])

// returns [0, [null, [2]]]
deepen([0,null,2])

// returns null
deepen(null)
10% - A stream of Fibonacci numbers
Write the function

Stream<int> Function() fibonacciNumbers(int n)

to build and return an anonymous function.  The anonymous function should take nothing as input and return a Stream<int> that returns a stream of the numbers from the 0th to the nth Fibonacci numberLinks to an external site. with a one second delay before each number in the stream. 

// returns a stream of integers 0, 1, 1, 2 with a one second delay for each number
fibonacciNumbers(3)()

// returns the function that generates the stream 0, 1, 1, 2, 3, 5 with a one second delay for each       
fibonacciNumbers(5)
15% - Filter a stream
Write the function

 Stream<int> Function() streamFilter(
     Stream<int> stream,
     boolean Function(int) filterFunction
     )
to build and return an anonymous function.  The streamFilter  function takes two parameters: a stream to filter and one argument function that evaluates to a boolean.   It returns an anonymous function that should take nothing as input and return a Stream<int>.  

// returns a stream of integers 2, 4 
streamFilter( countingNumbers(5), 
              ((int n) { return n % 2 == 0; })
            )()
15% - Stream accumulation
Write the function

 Stream<int> Function() streamAccumulate(
     Stream<int> stream,
     int Function(int, int) f,
     int initial
     )
to build and return an anonymous function.  The streamAccumulate function takes three parameters: a stream to filter, a two argument function that evaluates to an int, and an initial int value.   It returns an anonymous function that should take nothing as input and return a Stream<int>.  

// returns a stream of integers 1, 3, 6, 10, 15
streamAccumulate( countingNumbers(5), 
                  ((int n, int m) { return n + m; }), 
                  0
                )()   
   
// returns a stream of integers 1, 2, 6, 24, 120                          
streamAccumulate( countingNumbers(5), 
                  ((int n, int m) { return n * m; }), 
                  1
                )()      
+5% Extra credit
Make streamFilter and streamAccumulate extension methods of Stream<int> and rewrite the test code to use them as extension methods.

Part 2: Drawing with Canvas in Flutter
The code for this part of the assignment should go into fractal.dart.  It should contain the following.

30% - DrawFractal Class
Modify the DrawFractal class in fractal.dart to draw a fractal.  The fractal will draw the same "thing", for instance a line, in each level, where the next level in the fractal translates, rotates, and scales the object drawn.  For instance you could create a fractal that draws a slender or bushy tree-like object at higher dimensions by drawing a single vertical line and at the next level add three shorter and skinnier lines to the end of the line drawn at the previous level.  The fractal draws a single line and then uses the graphics transformations to scale, rotate, and translate to recursively call the fractal as many times as needed (i.e., three recursive calls). Use save and restore to save and restore your graphics environment as needed.  

Consult the Dart canvas apiLinks to an external site. for drawing operations for a  canvas. 

The code in fractal.dart is set up to draw the fractal 10 times using Flutter, with a delay of 1 second for each time drawn.

Here is a picture of the final fractal that I drew.