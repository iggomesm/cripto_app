// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cripto_app/repositories/conta_repository.dart';
import 'package:intl/intl.dart';

import 'package:cripto_app/models/moeda.dart';
import 'package:provider/provider.dart';

class MoedaDetalhesPage extends StatefulWidget {
  Moeda moeda;

  MoedaDetalhesPage({
    Key? key,
    required this.moeda,
  }) : super(key: key);

  @override
  State<MoedaDetalhesPage> createState() => _MoedaDetalhesPageState();
}

class _MoedaDetalhesPageState extends State<MoedaDetalhesPage> {
  NumberFormat format = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  final _form = GlobalKey<FormState>();
  final _valor = TextEditingController();
  double quantidade = 0.0;
  late ContaRepository conta;

  comprar() async {
    if (_form.currentState!.validate()) {
      //Salva a compra

      conta.comprar(widget.moeda, double.parse(_valor.text));

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Compra realizada")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    conta = Provider.of<ContaRepository>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.moeda.nome),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  child: Image.network(
                    widget.moeda.icone,
                    scale: 2.5,
                  ),
                  width: 25,
                ),
                Text(
                  format.format(widget.moeda.preco),
                  style: TextStyle(
                    fontSize: 24,
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.teal.withOpacity(0.05),
                ),
                alignment: Alignment.center,
                child: Text(
                  ' ${quantidade.toString()} ${widget.moeda.sigla}',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.teal,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _form,
              child: TextFormField(
                onChanged: (value) {
                  setState(() {
                    quantidade = (value.isEmpty)
                        ? 0
                        : double.parse(value) / widget.moeda.preco;
                  });
                },
                controller: _valor,
                style: TextStyle(fontSize: 22),
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Valor',
                    prefixIcon: Icon(Icons.monetization_on_outlined),
                    suffix: Text(
                      'reais',
                      style: TextStyle(fontSize: 14),
                    )),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Inform o valor da compra.';
                  } else if (double.parse(value) < 50) {
                    return 'Compra mínima é R\$50,00';
                  } else if (double.parse(value) > conta.saldo) {
                    return 'Saldo insulficiente para realizar a compra';
                  }
                  return null;
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              alignment: Alignment.bottomCenter,
              margin: EdgeInsets.only(
                top: 24,
              ),
              child: ElevatedButton(
                onPressed: comprar,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check),
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'Comprar',
                        style: TextStyle(fontSize: 24),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
