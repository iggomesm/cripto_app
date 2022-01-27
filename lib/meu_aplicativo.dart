import 'package:flutter/material.dart';

import 'pages/home_page.dart';
import 'widgets/auth_check.dart';

class MeuAplicativo extends StatelessWidget {
  const MeuAplicativo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int corPadrao = 0xFF009688;
    return MaterialApp(
      title: "Meu Aplicativo",
      theme: ThemeData(primarySwatch: Colors.teal),
      home: AuthCheck(),
    );
  }
}
