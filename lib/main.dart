import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:english_words/english_words.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  var favorites = <WordPair>[];

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;
    var favorites = appState.favorites;
    var icon = favorites.contains(pair) ? const Icon(Icons.favorite) : const Icon(Icons.favorite_border);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('I am a cabbage'),
            RandomWord(pair: pair),
            SizedBox(height: 20),
            Row(
              mainAxisSize: MainAxisSize.min, 
              children: [
                MyButton(onPressed: appState.getNext, label: 'Next'),
                SizedBox(width: 10),
                MyButton(onPressed: appState.toggleFavorite, label: 'Like', icon: icon),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MyButton extends StatelessWidget {
  const MyButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.icon,
  });

  final String label;
  final VoidCallback onPressed;
  final Icon? icon;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        child: Row(
          children: [
            icon ?? const SizedBox.shrink(),
            SizedBox(width: 10),
            Text(label),
          ],
        ));
  }
}

class RandomWord extends StatelessWidget {
  const RandomWord({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onTertiaryContainer,
    );
    return Card(
      color: theme.colorScheme.tertiaryContainer,
      elevation: 5.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(pair.asCamelCase,
            style: style, semanticsLabel: "${pair.first} ${pair.second}"),
      ),
    );
  }
}
