// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:cripto_app/pages/moedas_page.dart';

import 'careteira_page.dart';
import 'configuracoes_page.dart';
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
          CarteiraPage(),
          ConfiguracoesPage(),
        ],
        onPageChanged: (pagina) {
          setState(() {
            paginaAtual = pagina;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Color(Colors.amber.shade200.value),
        type: BottomNavigationBarType.fixed,
        currentIndex: paginaAtual,
        // ignore: prefer_const_literals_to_create_immutables
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: "Todas",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: "Favoritas",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined),
            label: "Carteira",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Configurações",
          ),
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
