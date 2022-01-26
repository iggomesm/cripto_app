import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_aula_1/repositories/conta_repository.dart';
import 'package:flutter_aula_1/repositories/favoritas_repository.dart';
import 'package:flutter_aula_1/services/auth_services.dart';
import 'package:provider/provider.dart';

import 'configs/app_settings.dart';
import 'meu_aplicativo.dart';

void main() async {
  // Faz com que o flutter não suba um erro por não ter o método runApp sedo a
  // primeira coisa a ser executada.
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa a biblioteca do Firebase
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()),
        ChangeNotifierProvider(create: (context) => AppSettings()),
        ChangeNotifierProvider(create: (context) => FavoritasRepository()),
        ChangeNotifierProvider(create: (context) => ContaRepository()),
      ],
      child: const MeuAplicativo(),
    ),
  );
}
