// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cripto_app/configs/app_settings.dart';
import 'package:cripto_app/repositories/conta_repository.dart';
import 'package:cripto_app/services/auth_services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'documentos_page.dart';

class ConfiguracoesPage extends StatefulWidget {
  ConfiguracoesPage({Key? key}) : super(key: key);

  @override
  State<ConfiguracoesPage> createState() => _ConfiguracoesPageState();
}

class _ConfiguracoesPageState extends State<ConfiguracoesPage> {
  @override
  Widget build(BuildContext context) {
    final conta = context.watch<ContaRepository>();
    final settings = context.watch<AppSettings>();

    NumberFormat real = NumberFormat.currency(
        locale: settings.locale['locale'], name: settings.locale['name']);

    return Scaffold(
      appBar: AppBar(
        title: Text('Conta'),
      ),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            ListTile(
              title: Text('Saldo'),
              subtitle: Text(
                real.format(conta.saldo),
                style: TextStyle(fontSize: 25, color: Colors.indigo),
              ),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: updateSaldo,
              ),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.camera),
              title: Text('Escanear documento'),
              subtitle: Text('Escaneie aqui sua CNH ou RG'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DocumentosPage(),
                  fullscreenDialog: true,
                ),
              ),
            ),
            Divider(),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 28),
                  child: OutlinedButton(
                    onPressed: () => context.read<AuthService>().logout(),
                    style: OutlinedButton.styleFrom(
                      primary: Colors.red,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            'Sair do App',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void updateSaldo() async {
    final form = GlobalKey<FormState>();
    final valor = TextEditingController();
    final conta = Provider.of<ContaRepository>(context, listen: false);

    valor.text = conta.saldo.toString();

    AlertDialog dialog = AlertDialog(
      title: Text('Atualizar o valor'),
      content: Form(
        key: form,
        child: TextFormField(
          controller: valor,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
          ],
          validator: (value) {
            if (value!.isEmpty) {
              return 'Informe o valor do saldo';
            } else {
              return null;
            }
          },
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context), child: Text('Cancelar')),
        TextButton(
            onPressed: () {
              if (form.currentState!.validate()) {
                conta.setSaldo(double.parse(valor.text));
                Navigator.pop(context);
              }
            },
            child: Text('Salvar')),
      ],
    );
    showDialog(context: context, builder: (context) => dialog);
  }
}
