import 'package:app/firebase_options.dart';
import 'package:app/module/counter.dart';
import 'package:app/module/game.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(providers: [
      StreamProvider<List<Game>>(
        create: (context) => Game(users: []).getPlayingGames(),
        initialData: const [],
      ),
      ChangeNotifierProvider(create: (context) => Game(users: [])),
      ChangeNotifierProvider(create: (context) => Counter()),
    ], child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            // consumer for reading the current playing game
            Consumer(builder: (context, List<Game> games, child) {
              print(games);

              return Column(
                children: games
                    .map((game) => Column(
                          children: [
                            Text(
                              ' ${game.state} ${game.winner ?? ''}',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),

                            //  display user and display score
                            Column(
                              children: game.users
                                  .map((user) =>
                                      Text('${user.name} ${user.score}'))
                                  .toList(),
                            ),
                          ],
                        ))
                    .toList(),
              );
            }),

            Consumer(builder: (context, Game game, child) {
              // display created users
              return Column(
                children: game.users
                    .map((user) => Text('${user.name} ${user.score}'))
                    .toList(),
              );
            }),
            Consumer(builder: (context, Counter counter, child) {
              return Text(
                '${counter.count}',
                style: Theme.of(context).textTheme.headlineMedium,
              );
            }),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const SecondPage(),
                  ),
                );
              },
              child: const Text('Go to second page'),
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => {context.read<Counter>().decrement()},
            tooltip: 'Decrement',
            child: const Icon(Icons.remove),
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            onPressed: () => {context.read<Counter>().increment()},
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}

class SecondPage extends StatefulWidget {
  const SecondPage({super.key});

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Page'),
      ),
      body: Center(
        child: Column(
          children: [
            const Text('This is the second page'),

            // consumer for reading the current playing game
            Consumer(builder: (context, List<Game> games, child) {
              return Column(
                children: games
                    .map((game) => Column(
                          children: [
                            Text(
                              ' ${game.state} ${game.winner ?? ''}',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),

                            //  display user and display score
                            Column(
                              children: game.users
                                  .map((user) => Row(
                                        children: [
                                          ElevatedButton(
                                              onPressed: () => {
                                                    game.decrementScore(user),
                                                  },
                                              child: const Text('-')),
                                          Text('${user.name} ${user.score}'),
                                          ElevatedButton(
                                            onPressed: () => {
                                              game.incrementScore(user),
                                            },
                                            child: const Text('+'),
                                          ),
                                        ],
                                      ))
                                  .toList(),
                            ),
                          ],
                        ))
                    .toList(),
              );
            }),

            Consumer(builder: (context, Game game, child) {
              if (game.state == 'playing') {
                return Column(
                  children: game.users
                      .map((user) => Row(
                            children: [
                              Text('${user.name} ${user.score}'),
                              ElevatedButton(
                                onPressed: () => {
                                  context.read<Game>().incrementScore(user),
                                },
                                child: const Text('+'),
                              ),
                              ElevatedButton(
                                onPressed: () => {
                                  context.read<Game>().decrementScore(user),
                                },
                                child: const Text('-'),
                              ),
                            ],
                          ))
                      .toList(),
                );
              }
              // display created users
              return Column(
                children: game.users
                    .map((user) => Text('${user.name} ${user.score}'))
                    .toList(),
              );
            }),
            Container(
              padding: const EdgeInsets.all(10),
              width: 300,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: TextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Enter your username',
                      ),
                      controller: myController,
                      onChanged: (text) {
                        context.read<Game>().setUserName(text);
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => {
                      context.read<Game>().addUser(User(myController.text, 0)),
                      myController.clear(),
                    },
                    child: const Text('Add user'),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () => {
                if (context.read<Game>().state == 'playing')
                  context.read<Game>().stopGame()
                else
                  context.read<Game>().startGame(),
              },
              child: Text(
                context.watch<Game>().state == 'playing'
                    ? 'Stop game'
                    : 'Start game',
              ),
            ),
            ElevatedButton(
                onPressed: () => {Navigator.of(context).pop()},
                child: const Text("GO BACK"))
          ],
        ),
      ),
    );
  }
}
