import 'package:flutter/material.dart';
import 'package:flutter_aula_1/pages/moedas_page.dart';

import 'favoritas_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //Controla o índice das páginas
  int paginaAtual = 0;

  //Controller que gerencia as páginas do PageView
  late PageController pc;

  @override
  void initState() {
    super.initState();
    pc = PageController(initialPage: paginaAtual);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pc,
        children: [
          MoedasPage(),
          FavoritasPage(),
        ],
        onPageChanged: (pagina) {
          setState(() {
            paginaAtual = pagina;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: paginaAtual,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "Todas"),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: "Favoritas"),
        ],
        onTap: (pagina) {
          pc.animateToPage(pagina,
              duration: Duration(milliseconds: 400),
              curve: Curves.easeInOutCirc);
        },
      ),
    );
  }
}
