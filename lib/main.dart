import 'package:app/firebase_options.dart';
import 'package:app/module/game.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        StreamProvider<List<Game>>(
          create: (context) => Game().getGame(),
          initialData: const [],
        ),
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
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SecondPage()),
              ),
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // consumer for reading the current playing game
            Consumer<List<Game>>(builder: (context, List<Game> games, child) {
              if (games.isEmpty) {
                return const Text("loading");
              }

              Game game = games[0];

              if (game.state == 'winner') {
                return Column(
                  children: [
                    Text(
                      ' ${game.state} ${game.winner ?? ''}',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    Column(
                      children: game.users!
                          .map((user) => Text('${user.name} ${user.score}'))
                          .toList(),
                    ),
                  ],
                );
              }

              if (game.state == 'playing') {
                return Column(
                  children: [
                    Text(
                      ' ${game.state} ${game.winner ?? ''}',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    Column(
                      children: game.users!
                          .map(
                            (user) => Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 10,
                              ),
                              width: 300,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium,
                                    user.name,
                                  ),
                                  Text(
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium,
                                    user.score.toString(),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                );
              }

              if (game.state == 'creating users' || game.state == null) {
                return Column(
                  children: [
                    Text(
                      'Creating users',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    Column(
                      children: game.users!
                          .map(
                            (user) => Text(
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                                user.name),
                          )
                          .toList(),
                    ),
                  ],
                );
              }

              return const Text('Game is not playing');
            }),
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
  final userController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    userController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game setup'),
      ),
      body: Center(
        child: Column(
          children: [
            Consumer<List<Game>>(builder: (context, List<Game> games, child) {
              if (games.isEmpty) {
                return const Text("loading");
              }

              Game game = games[0];

              if (game.state == 'winner') {
                return Column(
                  children: [
                    Text(
                      ' ${game.state} ${game.winner ?? ''}',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    Column(
                      children: game.users!
                          .map((user) => Text('${user.name} ${user.score}'))
                          .toList(),
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () => {game.resetGame()},
                            child: const Text('Reset game'),
                          ),
                          ElevatedButton(
                            onPressed: () => {
                              game.clearGame(),
                            },
                            child: const Text('Clear game'),
                          ),
                        ])
                  ],
                );
              }

              if (game.state == 'playing') {
                return Column(
                  children: [
                    Column(
                      children: game.users!
                          .map((user) => Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    onPressed: () => {
                                      game.decrementScore(user),
                                    },
                                    child: const Icon(Icons.remove),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 10,
                                    ),
                                    width: 300,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineMedium,
                                          user.name,
                                        ),
                                        Text(
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineMedium,
                                          user.score.toString(),
                                        ),
                                      ],
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () => {
                                      game.incrementScore(user),
                                    },
                                    child: const Icon(Icons.add),
                                  ),
                                ],
                              ))
                          .toList(),
                    ),
                    ElevatedButton(
                      onPressed: () => {
                        game.clearGame(),
                      },
                      child: const Text('Clear game'),
                    ),
                  ],
                );
              }

              if (game.state == 'creating users' || game.state == null) {
                return Column(
                  children: [
                    // winnig score input
                    Container(
                      padding: const EdgeInsets.all(10),
                      width: 300,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Winning score',
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              initialValue: game.winningScore.toString(),
                              onChanged: (text) => {
                                game.setWinningScore(int.parse(text)),
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    // display created users
                    Column(
                      children: game.users!
                          .map(
                            (user) => Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium,
                                  user.name,
                                ),
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
                              controller: userController,
                            ),
                          ),
                          const SizedBox(width: 10),
                          FloatingActionButton(
                            child: const Icon(Icons.add),
                            onPressed: () => {
                              game.addUser(
                                User(userController.text, 0),
                              ),
                              userController.clear(),
                            },
                          ),
                        ],
                      ),
                    ),

                    ElevatedButton(
                      onPressed: () => {
                        game.startGame(),
                      },
                      child: const Text('Start game'),
                    ),
                  ],
                );
              }

              return const Text('Game is not playing');
            }),
          ],
        ),
      ),
    );
  }
}
