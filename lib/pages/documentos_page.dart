import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class DocumentosPage extends StatefulWidget {
  DocumentosPage({Key? key}) : super(key: key);

  @override
  State<DocumentosPage> createState() => _DocumentosPageState();
}

class _DocumentosPageState extends State<DocumentosPage> {
  // Tipo de objeto de câmera.
  // O smart phone possui várias câmeras. Esse array irá saber quais câmeras
  // O smartphone possui. Assim é possível utilizar uma ou mais câmeras.
  List<CameraDescription> cameras = [];
  CameraController? controller; // Objeto de controle da câmera
  XFile? imagem; // Objeto que irá armazenar a imagem.
  Size? size; // Objeto que irá trabalhar o tamanho da tela do celular.

  @override
  void initState() {
    super.initState();
    _loadCameras();
  }

  /// Realiza a carga das câmeras do aparelho.
  /// Caso o usuário não tenha dado permissões, é possível que ocorra uma Excep.
  /// Por esse motivo é necessário que essa estrutura esteja dentro de um try
  /// catch para a exception CameraException.
  _loadCameras() async {
    try {
      cameras = await availableCameras();
      _startCamera();
    } on CameraException catch (e) {
      print(e);
    }
  }

  _startCamera() {
    // A câmera pode não ser inicializada caso o usuário não tenha dado
    // permissão.
    if (cameras.isEmpty) {
      print('Camera não encontrada.');
    } else {
      // Envia a primeira câmera da lista que normalmente é câmetra traseira.
      _previewCamera(cameras.first);
    }
  }

  _previewCamera(CameraDescription camera) async {
    //Monta um controlador da câmera.
    // Aqui é aonde você define as propriedades da câmera. Se você irá utilizar
    // audio, qual o tipo do arquivo da foto, se usará flash, qual a qualidade
    // da imagem, etc.
    final CameraController cameraController = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    controller = cameraController;

    try {
      // Comando para inicializar a câmera.
      await cameraController.initialize();
    } on CameraException catch (e) {
      print(e);
    }

    // mounted é uma variável de estado do Flutter. Ela é true caso o widget
    // esteja montado dentro da árvore de widgets
    if (mounted) {
      // Este setState vazio serve para o flutter atualizar a tela caso a câmera
      // que acabou de ser inicializada ainda não esteja sendo exibida.
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Documento Oficial'),
        backgroundColor: Colors.grey,
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        color: Colors.grey.withOpacity(0.5),
        child: Center(
          child: _arquivoWidget(),
        ),
      ),
      floatingActionButton: (imagem != null)
          ? FloatingActionButton.extended(
              onPressed: () => Navigator.pop(context),
              label: Text('Finalizar'),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  _arquivoWidget() {
    return Container(
      width: size!.width,
      height: size!.width,
      child: imagem == null
          ? _cameraPreviewWidget()
          : Image.file(
              File(imagem!.path),
              fit: BoxFit.contain,
            ),
    );
  }

  _cameraPreviewWidget() {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      return Text('Widget para camera que não está disponível');
    } else {
      return Stack(
        alignment: Alignment.bottomCenter,
        children: [
          CameraPreview(controller!),
          Padding(
            padding: EdgeInsets.only(bottom: 24),
            child: CircleAvatar(
              radius: 32,
              backgroundColor: Colors.black.withOpacity(0.5),
              child: IconButton(
                onPressed: tirarFoto,
                icon: Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ),
        ],
      );
    }
  }

  tirarFoto() async {
    final CameraController? cameraController = controller;

    if (cameraController != null && cameraController.value.isInitialized) {
      try {
        XFile file = await cameraController.takePicture();

        if (mounted) setState(() => imagem = file);
      } catch (e) {
        print(e);
      }
    }
  }
}
