import 'package:flutter/material.dart';
import 'package:flutter_aula_1/pages/moedas_page.dart';

import 'pages/home_page.dart';

class MeuAplicativo extends StatelessWidget {
  const MeuAplicativo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int corPadrao = 0xFF009688;
    return MaterialApp(
      title: "Meu Aplicativo",
      theme: ThemeData(primarySwatch: Colors.teal),
      home: HomePage(),
    );
  }
}
