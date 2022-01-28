// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';

class DBFirestore {
  DBFirestore._();

  static final DBFirestore instace = DBFirestore._();

  // Pega a instância do Firebase
  final FirebaseFirestore _firebase = FirebaseFirestore.instance;

  static FirebaseFirestore get() {
    return DBFirestore.instace._firebase;
  }
}
