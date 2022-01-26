import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  // Pega a instância do Firebase.
  FirebaseAuth _auth = FirebaseAuth.instance;

  // User é uma classe do Firebase que representará um usuário.
  User? usuario;

  // Esta variável indicará um loagind que deverá ficar visível enquanto um
  // usuário não estiver carregado.
  bool isLoading = true;

  AuthService() {
    _authCheck();
  }

  void _authCheck() {
    // Este método é responsável por criar um Listener do firebase.
    // Ele ficará monitorando o status do usuário junto ao firebase.
    _auth.authStateChanges().listen((User? user) {
      usuario = (user == null) ? null : user;
      isLoading = false;
      notifyListeners();
    });
  }

  registrar(String email, String senha) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: senha);

      _getUser();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw AuthException('Senha muito fraca.');
      } else if (e.code == 'email-already-in-use') {
        throw AuthException('Este e-mail já está cadastrado.');
      }
    }
  }

  login(String email, String senha) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: senha);

      _getUser();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw AuthException('E-mail não cadastrado.');
      } else if (e.code == 'wrong-password') {
        throw AuthException('Senha incorreta.');
      }
    }
  }

  logout() async {
    await _auth.signOut();
    _getUser();
  }

  void _getUser() {
    usuario = _auth.currentUser;
    notifyListeners();
  }
}

class AuthException implements Exception {
  String message;
  AuthException(this.message);
}
