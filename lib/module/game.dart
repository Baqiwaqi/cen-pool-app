import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Game extends ChangeNotifier {
  String? id;
  List<User>? users;
  String? state;
  String? winner = "creating users";

  Game({
    this.id,
    this.users,
    this.state,
    this.winner,
  });

  String userName = '';
  void setUserName(String name) {
    userName = name;
    notifyListeners();
  }

  void addUser(User user) {
    users?.add(user);
    notifyListeners();
  }

  void removeUser(User user) {
    users?.remove(user);
    notifyListeners();
  }

  Future<void> incrementScore(User user) async {
    user.score++;
    try {
      await game.update({
        'users': users?.map((user) => {'name': user.name, 'score': user.score}),
      });
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> decrementScore(User user) async {
    user.score--;
    try {
      await game.update({
        'users': users?.map((user) => {'name': user.name, 'score': user.score}),
      });
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> startGame() async {
    state = 'playing';
    try {
      await game.update({
        'users': users?.map((user) => {'name': user.name, 'score': user.score}),
        'state': state,
        'winner': winner,
      });

      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> clearGame() async {
    state = 'creating users';
    users = [];
    winner = null;

    try {
      await game.update({
        'users': users?.map((user) => {'name': user.name, 'score': user.score}),
        'state': state,
        'winner': winner,
      });
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> stopGame() async {
    state = 'stopped';
    try {
      await game.update({
        'users': users?.map((user) => {'name': user.name, 'score': user.score}),
        'state': state,
        'winner': winner,
      });
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  DocumentReference<Map<String, dynamic>> game =
      FirebaseFirestore.instance.collection('game').doc('playing');

  Stream<List<Game>> getGame() {
    return FirebaseFirestore.instance
        .collection('game')
        .snapshots()
        .map((snapshots) {
      return snapshots.docs.map((snapshot) {
        final data = snapshot.data();
        return Game(
          id: snapshot.id,
          users: (data['users'] as List<dynamic>)
              .map((user) => User(user['name'], user['score']))
              .toList(),
          state: data['state'],
          winner: data['winner'],
        );
      }).toList();
    });
  }
}

class User {
  String name;
  int score;

  User(this.name, this.score);
}
