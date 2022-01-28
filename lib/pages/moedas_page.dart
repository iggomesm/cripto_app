// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:cripto_app/configs/app_settings.dart';
import 'package:cripto_app/models/moeda.dart';
import 'package:cripto_app/pages/moedas_detalhes_page.dart';
import 'package:cripto_app/repositories/favoritas_repository.dart';
import 'package:cripto_app/repositories/moeda_repository.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MoedasPage extends StatefulWidget {
  const MoedasPage({Key? key}) : super(key: key);

  @override
  State<MoedasPage> createState() => _MoedasPageState();
}

class _MoedasPageState extends State<MoedasPage> {
  late List<Moeda> tabela;
  late NumberFormat real;
  List<Moeda> selecionadas = [];

  late FavoritasRepository favoritas;
  late AppSettings settings;
  late MoedaRepository moedas;

  Widget changeLanguageButton() {
    final String nameMenu =
        settings.locale['locale'] == 'pt_BR' ? 'Doletas' : 'Bozos';

    return PopupMenuButton(
      icon: Icon(Icons.language),
      itemBuilder: (context) => [
        PopupMenuItem(
          child: ListTile(
            title: Text('Converta para $nameMenu'),
            leading: Icon(Icons.swap_horizontal_circle_outlined),
            onTap: () {
              final String local =
                  settings.locale['locale'] == 'pt_BR' ? 'en_US' : 'pt_BR';
              final String name =
                  settings.locale['locale'] == 'pt_BR' ? '\$' : 'R\$';

              settings.setLocale(local, name);
              // Para fechar o menu
              Navigator.pop(context);
            },
          ),
        )
      ],
    );
  }

  AppBar _appBarDinamica() {
    if (selecionadas.isEmpty) {
      return AppBar(
        title: Text("Meu Aplicativo"),
        actions: [
          changeLanguageButton(),
        ],
      );
    } else {
      return AppBar(
        title: Text("${selecionadas.length} selecionadas"),
        titleTextStyle: TextStyle(color: Colors.red[900], fontSize: 24),
        leading: IconButton(
          onPressed: () {
            setState(() {
              selecionadas = [];
            });
          },
          icon: Icon(Icons.arrow_back),
        ),
        backgroundColor: Colors.blueGrey[400],
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.deepOrangeAccent[400]),
      );
    }
  }

  mostrarDetalhes(Moeda moeda) {
    Navigator.push(context, MaterialPageRoute(builder: (buildContext) {
      return MoedaDetalhesPage(moeda: moeda);
    }));
  }

  montaConfiguracoes() {
    real = NumberFormat.currency(
        locale: settings.locale['locale'], name: settings.locale['name']);
  }

  @override
  Widget build(BuildContext context) {
    // Posso pegar dessa forma
    //this.favoritas = Provider.of<FavoritasRepository>(context);

    // Ou posso pegar dessa forma
    favoritas = context.watch<FavoritasRepository>();
    settings = context.watch<AppSettings>();
    moedas = context.watch<MoedaRepository>();

    tabela = moedas.tabela;

    montaConfiguracoes();

    return Scaffold(
      appBar: _appBarDinamica(),
      body: RefreshIndicator(
        onRefresh: () => moedas.checkPrecos(),
        child: ListView.separated(
          itemCount: tabela.length,
          itemBuilder: (BuildContext context, int moeda) {
            return ListTile(
              leading: selecionadas.contains(tabela[moeda])
                  ? CircleAvatar(
                      child: Icon(Icons.check_circle),
                    )
                  : SizedBox(
                      child: Image.network(tabela[moeda].icone),
                      width: 40,
                    ),
              title: Row(
                children: [
                  Text(
                    tabela[moeda].nome,
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                  ),
                  if (favoritas.lista.contains(tabela[moeda]))
                    Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 12,
                    )
                ],
              ),
              trailing: Text(real.format(tabela[moeda].preco)),
              selected: selecionadas.contains(tabela[moeda]),
              selectedTileColor: Colors.indigo[50],
              onTap: () {
                mostrarDetalhes(tabela[moeda]);
              },
              onLongPress: () {
                setState(() {
                  (selecionadas.contains(tabela[moeda]))
                      ? selecionadas.remove(tabela[moeda])
                      : selecionadas.add(tabela[moeda]);
                });
                print(tabela[moeda].nome);
              },
            );
          },
          padding: EdgeInsets.all(16),
          separatorBuilder: (_, ____) => Divider(),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: (selecionadas.isEmpty)
          ? null
          : FloatingActionButton.extended(
              onPressed: () {
                favoritas.saveAll(selecionadas);

                limpaSelecionadas();
              },
              icon: Icon(Icons.star),
              label: Text(
                "Favoritar",
                style: TextStyle(
                  letterSpacing: 0,
                  fontWeight: FontWeight.bold,
                ),
              )),
    );
  }

  void limpaSelecionadas() {
    setState(() {
      selecionadas = [];
    });
  }
}
