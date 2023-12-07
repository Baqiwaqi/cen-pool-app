import 'package:app/firebase_options.dart';
import 'package:app/module/game.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        StreamProvider<List<Game>>(
            create: (context) => Game().getGame(), initialData: const []),

        // StreamProvider<List<Game>>(
        //   create: (context) => Game(users: []).getPlayingGames(),
        //   initialData: const [],
        // ),
        ChangeNotifierProvider(
          create: (context) => Game(users: []),
        )
      ],
      child: const MyApp(),
    ),
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
      home: const Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

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
            Consumer<List<Game>>(builder: (context, List<Game> games, child) {
              if (games.isEmpty) {
                return const Text("loading");
              }

              Game game = games[0];

              // prettier print
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      ' ${game.state} ${game.winner ?? ''}',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),

                    //  display user and display score
                    Column(
                      children: game.users!
                          .map((user) => Text('${user.name} ${user.score}'))
                          .toList(),
                    ),
                  ],
                ),
              );
            }),

            // Consumer<Game>(builder: (context, Game game, child) {
            //   // display created users
            //   return Column(
            //     children: game.users
            //         .map((user) => Text('${user.name} ${user.score}'))
            //         .toList(),
            //   );
            // }),

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
            Consumer<List<Game>>(builder: (context, List<Game> games, child) {
              if (games.isEmpty) {
                return const Text("loading");
              }

              Game game = games[0];

              if (game.state == 'playing') {
                return Column(
                  children: game.users!
                      .map((user) => Row(
                            children: [
                              ElevatedButton(
                                onPressed: () => {
                                  game.incrementScore(user),
                                },
                                child: const Text('+'),
                              ),
                              Text('${user.name} ${user.score}'),
                              ElevatedButton(
                                onPressed: () => {
                                  game.decrementScore(user),
                                },
                                child: const Text('-'),
                              ),
                            ],
                          ))
                      .toList(),
                );
              }

              if (game.state == 'creating users' || game.state == null) {
                return Column(
                  children: [
                    // display created users
                    Column(
                      children: game.users!
                          .map(
                            (user) => Row(
                              children: [
                                Text('${user.name} ${user.score}'),
                                ElevatedButton(
                                  onPressed: () => {
                                    game.removeUser(user),
                                  },
                                  child: const Text('X'),
                                ),
                              ],
                            ),
                          )
                          .toList(),
                    ),

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
                                labelText: 'Player name',
                              ),
                              controller: myController,
                              onChanged: (text) {
                                context.read<Game>().setUserName(text);
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          FloatingActionButton(
                            child: const Icon(Icons.add),
                            // icon: const Icon(Icons.add),
                            // style: ButtonStyle(
                            //   padding: MaterialStateProperty.all(
                            //     const EdgeInsets.symmetric(horizontal: 16),
                            //   ),
                            // ),
                            onPressed: () => {
                              game.addUser(User(myController.text, 0)),
                              myController.clear(),
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }

              return const Text('Game is not playing');
            }),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => {context.read<Game>().clearGame()},
            tooltip: 'Clear game',
            child: const Icon(Icons.clear),
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            onPressed: () => {
              if (context.read<Game>().state == 'playing')
                context.read<Game>().stopGame()
              else
                context.read<Game>().startGame(),
            },
            tooltip: 'Start Game',
            child: Icon(
              context.watch<Game>().state == 'playing'
                  ? Icons.stop
                  : Icons.play_arrow,
            ),
          ),
        ],
      ),
    );
  }
}
