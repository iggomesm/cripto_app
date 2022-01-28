import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'configs/app_settings.dart';
import 'meu_aplicativo.dart';
import 'repositories/conta_repository.dart';
import 'repositories/favoritas_repository.dart';
import 'services/auth_services.dart';

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
        ChangeNotifierProvider(
          create: (context) => FavoritasRepository(
            auth: context.read<AuthService>(),
          ),
        ),
        ChangeNotifierProvider(create: (context) => ContaRepository()),
      ],
      child: const MeuAplicativo(),
    ),
  );
}
