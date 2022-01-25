import 'package:flutter/material.dart';
import 'package:flutter_aula_1/repositories/conta_repository.dart';
import 'package:flutter_aula_1/repositories/favoritas_repository.dart';
import 'package:provider/provider.dart';

import 'configs/app_settings.dart';
import 'meu_aplicativo.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppSettings()),
        ChangeNotifierProvider(create: (context) => FavoritasRepository()),
        ChangeNotifierProvider(create: (context) => ContaRepository()),
      ],
      child: const MeuAplicativo(),
    ),
  );
}
