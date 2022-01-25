import 'package:flutter/material.dart';
import 'package:flutter_aula_1/models/moeda.dart';
import 'package:flutter_aula_1/repositories/favoritas_repository.dart';
import 'package:flutter_aula_1/widgets/moeda_card.dart';
import 'package:provider/provider.dart';

class FavoritasPage extends StatefulWidget {
  FavoritasPage({Key? key}) : super(key: key);

  @override
  _FavoritasPageState createState() => _FavoritasPageState();
}

class _FavoritasPageState extends State<FavoritasPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favoritas"),
      ),
      body: Container(
        color: Colors.indigo.withOpacity(0.05),
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(12.0),
        child: Consumer<FavoritasRepository>(
          builder: montaListagemFavorita,
        ),
      ),
    );
  }

  Widget montaListagemFavorita(
      BuildContext context, FavoritasRepository favoritas, Widget? widget) {
    if (favoritas.lista.isEmpty) {
      return ListTile(
        leading: Icon(Icons.star),
        title: Text("Nenhuma favorita adicionada"),
      );
    } else {
      return ListView.builder(
          itemCount: favoritas.lista.length,
          itemBuilder: (context, index) {
            return MoedaCard(moeda: favoritas.lista[index]);
          });
    }
  }
}
