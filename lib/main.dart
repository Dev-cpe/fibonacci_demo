import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fibonaci App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Fibonacci Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<FiboNumer> _fibonacciNumbers = [];
  final List<FiboNumer> _fiboSheetNumbers = [];
  final List<IconData> _types = [
    Icons.circle,
    Icons.square_outlined,
    Icons.close
  ];
  int _highlightedIndex = -1;

  @override
  void initState() {
    super.initState();
    _gennerateFibonacciNumber();
  }

  void _gennerateFibonacciNumber() {
    _fibonacciNumbers = [
      FiboNumer(iconData: Icons.circle, number: 0, index: 0),
      FiboNumer(iconData: Icons.square_outlined, number: 1, index: 1)
    ];
    for (var i = 2; i <= 40; i++) {
      int number =
          _fibonacciNumbers[i - 1].number + _fibonacciNumbers[i - 2].number;
      IconData type = _types[number % _types.length];
      _fibonacciNumbers
          .add(FiboNumer(iconData: type, number: number, index: i));
    }
  }

  void _showBottomSheet(FiboNumer fiboNumer) {
    setState(() {
      _fiboSheetNumbers.add(fiboNumer);
      _fibonacciNumbers.remove(fiboNumer);
    });
    final filterFibonacci = _fiboSheetNumbers
        .where((element) => element.iconData == fiboNumer.iconData)
        .toList();

    final newIndex = filterFibonacci.indexOf(fiboNumer);

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView.builder(
          itemCount: filterFibonacci.length,
          itemBuilder: (context, index) {
            return Container(
              color: newIndex == index ? Colors.greenAccent : null,
              child: ListTile(
                title: Text('Number: ${filterFibonacci[index].number}'),
                subtitle: Text('Index: ${filterFibonacci[index].index}'),
                trailing: Icon((filterFibonacci[index].iconData)),
                onTap: () {
                  setState(() {
                    _fibonacciNumbers.add(filterFibonacci[index]);
                    _fibonacciNumbers
                        .sort((a, b) => a.index.compareTo(b.index));
                    _fiboSheetNumbers.remove(filterFibonacci[index]);
                    _highlightedIndex = _fibonacciNumbers.indexOf(filterFibonacci[index]);
                  });
                  Navigator.pop(context);
                },
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemBuilder: ((context, index) {
          return Container(
            color: _highlightedIndex == index ? Colors.red : null,
            child: ListTile(
              title: Text(
                  'Index: ${_fibonacciNumbers[index].index}, Number: ${_fibonacciNumbers[index].number}'),
              trailing: Icon((_fibonacciNumbers[index].iconData)),
              onTap: () {
                _showBottomSheet(_fibonacciNumbers[index]);
              },
            ),
          );
        }),
        itemCount: _fibonacciNumbers.length,
      ),
    );
  }
}

class FiboNumer {
  FiboNumer(
      {required this.iconData, required this.number, required this.index});
  IconData iconData;
  int number;
  int index;
}
