import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings extends ChangeNotifier {
  late SharedPreferences _prefis;

  Map<String, String> locale = {'locale': 'pt_BR', 'name': 'R\$'};

  AppSettings() {
    _startSettings();
  }

  void _startSettings() async {
    await startPreferences();
    await _readLocale();
  }

  startPreferences() async {
    _prefis = await SharedPreferences.getInstance();
  }

  _readLocale() async {
    // Este comando ?? é equivalente ao || do js.
    // Caso a variável _prefis.getString('locale') seja nula ele irá coloca na
    // variável local 'pr_BR'
    final local = _prefis.getString('locale') ?? 'pt_BR';
    final name = _prefis.getString('name') ?? 'R\$';

    locale = {
      'locale': local,
      'name': name,
    };

    notifyListeners();
  }

  setLocale(String local, String name) async {
    await _prefis.setString('locale', local);
    await _prefis.setString('name', name);
    await _readLocale();
  }
}
