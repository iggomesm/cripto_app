import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_aula_1/models/moeda.dart';

class FavoritasRepository extends ChangeNotifier {
  List<Moeda> _lista = [];

  UnmodifiableListView<Moeda> get lista => UnmodifiableListView(_lista);

  saveAll(List<Moeda> moedas) {
    moedas.forEach((element) {
      if (!this._lista.contains(element)) this._lista.add(element);
      notifyListeners();
    });
  }

  remove(Moeda moeda) {
    this._lista.remove(moeda);
    notifyListeners();
  }
}
