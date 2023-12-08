import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Game extends ChangeNotifier {
  String? id;
  List<User>? users;
  String? state = 'creating users';
  String? winner;
  int? winningScore = 10;

  Game({
    this.id,
    this.users,
    this.state,
    this.winner,
    this.winningScore,
  });

  // winning score setter
  void setWinningScore(int score) {
    try {
      winningScore = score;
      docRef.update({
        'winningScore': winningScore,
      });
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  String userName = '';
  void setUserName(String name) {
    userName = name;
    notifyListeners();
  }

  void addUser(User user) {
    try {
      users?.add(user);
      docRef.update({
        'users': users?.map((user) => {'name': user.name, 'score': user.score}),
      });
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  void removeUser(User user) {
    users?.remove(user);
    docRef.update({
      'users': users?.map((user) => {'name': user.name, 'score': user.score}),
    });
    notifyListeners();
  }

  Future<void> incrementScore(User user) async {
    try {
      user.score++;

      if (user.score == winningScore) {
        winner = user.name;
        state = 'winner';
        notifyListeners();
        return await docRef.update({
          'users':
              users?.map((user) => {'name': user.name, 'score': user.score}),
          'state': state,
          'winner': winner,
        });
      }

      await docRef.update({
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
      await docRef.update({
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
      await docRef.update({
        'users': users?.map((user) => {'name': user.name, 'score': user.score}),
        'state': state,
        'winner': winner,
      });

      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> resetGame() async {
    try {
      state = 'creating users';
      users = users?.map((user) => User(user.name, 0)).toList();
      winner = null;

      await docRef.update({
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
      await docRef.update({
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
      await docRef.update({
        'users': users?.map((user) => {'name': user.name, 'score': user.score}),
        'state': state,
        'winner': winner,
      });
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  final docRef = FirebaseFirestore.instance.collection('game').doc('playing');

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
          winningScore: data['winningScore'],
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
