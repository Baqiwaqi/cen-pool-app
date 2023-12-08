import 'package:app/firebase_options.dart';
import 'package:app/module/game.dart';
import 'package:app/theme/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/breakpoint.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';

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
      theme: theme,
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
          actions: [
            IconButton(
              icon: const Icon(Icons.arrow_forward),
              onPressed: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SecondPage()),
                ),
              },
            ),
          ],
        ),
        body: ResponsiveBreakpoints.builder(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // consumer for reading the current playing game
                Consumer<List<Game>>(
                    builder: (context, List<Game> games, child) {
                  if (games.isEmpty) {
                    return const Text("loading");
                  }

                  Game game = games[0];

                  if (game.state == 'winner') {
                    return Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Theme.of(context).colorScheme.primary,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Theme.of(context).colorScheme.primary,
                                Theme.of(context).colorScheme.secondary,
                              ],
                            ),
                            backgroundBlendMode: BlendMode.softLight,
                          ),
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Text(
                            '${game.state?.toUpperCase()} ${game.winner?.toUpperCase() ?? ''}',
                            style: ResponsiveBreakpoints.of(context).isDesktop
                                ? Theme.of(context).textTheme.displayLarge
                                : Theme.of(context).textTheme.headlineLarge,
                          ),
                        ),
                      ],
                    );
                  }

                  if (game.state == 'playing') {
                    return Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Theme.of(context).colorScheme.primary,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Theme.of(context).colorScheme.primary,
                                Theme.of(context).colorScheme.secondary,
                              ],
                            ),
                            backgroundBlendMode: BlendMode.softLight,
                          ),
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Text(
                            '${game.state?.toUpperCase()}',
                            style: ResponsiveBreakpoints.of(context).isDesktop
                                ? Theme.of(context).textTheme.displayLarge
                                : Theme.of(context).textTheme.headlineLarge,
                          ),
                        ),
                        Column(
                          children: game.users!
                              .map((user) => Container(
                                    margin: const EdgeInsets.only(top: 20),
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        width: 2,
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                    width: 300,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineMedium,
                                            user.name[0].toUpperCase() +
                                                user.name.substring(1)),
                                        Text(
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineMedium,
                                          user.score.toString(),
                                        ),
                                      ],
                                    ),
                                  ))
                              .toList(),
                        ),
                      ],
                    );
                  }

                  if (game.state == 'creating users' || game.state == null) {
                    return Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Theme.of(context).colorScheme.primary,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Theme.of(context).colorScheme.primary,
                                Theme.of(context).colorScheme.secondary,
                              ],
                            ),
                            backgroundBlendMode: BlendMode.softLight,
                          ),
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Text(
                            '${game.state?.toUpperCase()}',
                            style: ResponsiveBreakpoints.of(context).isDesktop
                                ? Theme.of(context).textTheme.displayLarge
                                : Theme.of(context).textTheme.headlineLarge,
                          ),
                        ),
                        Column(
                          children: game.users!
                              .map((user) => Container(
                                    margin: const EdgeInsets.only(top: 20),
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        width: 2,
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                    width: 300,
                                    child: Text(
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium,
                                        user.name[0].toUpperCase() +
                                            user.name.substring(1)),
                                  ))
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
          breakpoints: [
            const Breakpoint(start: 0, end: 450, name: MOBILE),
            const Breakpoint(start: 451, end: 800, name: TABLET),
            const Breakpoint(start: 801, end: 1920, name: DESKTOP),
            const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
          ],
        ));
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
                return SizedBox(
                  // full height
                  height: MediaQuery.of(context).size.height - 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                                      width: 200,
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 10,
                                      ),
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
                  ),
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
