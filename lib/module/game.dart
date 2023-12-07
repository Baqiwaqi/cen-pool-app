import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// create a class that extends ChangeNotifier
// the clas is for handle the state of the game
// -  creating users
// - start the game
// - increment or decrement the a users score
// - end the game
// - reset the game

class Game extends ChangeNotifier {
  String? id;
  List<User> users;
  String? state;
  String? winner = "creating users";

  Game({
    this.id,
    required this.users,
    this.state,
    this.winner,
  });

  String userName = '';
  void setUserName(String name) {
    userName = name;
    notifyListeners();
  }

  void addUser(User user) {
    users.add(user);
    notifyListeners();
  }

  Future<void> incrementScore(User user) async {
    user.score++;
    try {
      await games.doc(id).update({
        'users': users.map((user) => {'name': user.name, 'score': user.score}),
      });
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> decrementScore(User user) async {
    user.score--;
    try {
      await games.doc(id).update({
        'users': users.map((user) => {'name': user.name, 'score': user.score}),
      });
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> startGame() async {
    state = 'playing';
    try {
      final res = await games.add({
        'users': users.map((user) => {'name': user.name, 'score': user.score}),
        'state': state,
        'winner': winner,
      });

      id = res.id;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> stopGame() async {
    state = 'stopped';
    try {
      await games.doc(id).update({
        'state': state,
      });
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  CollectionReference<Map<String, dynamic>> games =
      FirebaseFirestore.instance.collection('games');

  Stream<List<Game>> getPlayingGames() {
    return games
        .where('state', isEqualTo: 'playing')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Game(
                  id: doc.id,
                  users: (doc.data()['users'] as List<dynamic>)
                      .map((user) => User(user['name'], user['score']))
                      .toList(),
                  state: doc.data()['state'],
                  winner: doc.data()['winner'],
                ))
            .toList());
  }
}

class User {
  String name;
  int score;

  User(this.name, this.score);
}
