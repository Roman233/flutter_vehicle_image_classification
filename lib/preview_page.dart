import 'dart:ffi';

import 'package:flutter/material.dart';
import 'dart:io';

import 'package:flutter_tflite/flutter_tflite.dart';

class PreviewPage extends StatefulWidget {
  const PreviewPage({super.key, required this.imagePath});

  final String imagePath;

  @override
  State<PreviewPage> createState() {
    return _PreviewPageState();
  }
}

class _PreviewPageState extends State<PreviewPage> {
  _PreviewPageState();

  bool hasResult = false;
  bool hasResult7 = false;
  String result = '';
  String result7 = '';
  //final labels = _loadLabels(labelsFileName);
  //final model = _loadModel(modelFileName);

  @override
  void initState() {
    super.initState();
    loadAndClassifyModel();
  }

  Widget _getResult14() {
    if (hasResult) {
      return Text("Resultado 14: $result");
    } else {
      return const Text("A prever 14 classes...");
    }
  }

  Widget _getResult7() {
    if (hasResult) {
      return Text("Resultado 7: $result7");
    } else {
      return const Text("A prever 7 classes...");
    }
  }

  classifyImage(String imagePath) async {
    debugPrint("Classifying model");
    var output = await Tflite.runModelOnImage(
      path: imagePath,
      numResults: 14,
      /* threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5, */
    );
    debugPrint(output.toString());
    debugPrint("");
    if (output != null && output.isNotEmpty) {
      var conf = double.parse(output.first['confidence'].toString())
          .toStringAsFixed(4);
      var label = output.first['label'].toString().split(' ')[1];
      if (double.parse(conf) < 0.40) {
        label = "Not a vehicle";
      }
      setState(() {
        hasResult = true;
        result = "$conf $label";
      });
      loadAndClassifyModel7();
    }
  }

  classifyImage7(String imagePath) async {
    debugPrint("Classifying model 7");
    var output = await Tflite.runModelOnImage(
      path: imagePath,
      numResults: 7,
    );
    debugPrint(output.toString());
    debugPrint("");
    if (output != null && output.isNotEmpty) {
      var conf = double.parse(output.first['confidence'].toString())
          .toStringAsFixed(4);
      var label = output.first['label'].toString().split(' ')[1];
      if (double.parse(conf) < 0.70) {
        label = "Não identificado";
      }
      setState(() {
        hasResult = true;
        result7 = "$conf $label";
      });
    }
  }

  loadAndClassifyModel() async {
    Tflite.loadModel(
            model: "modelos/best_model.tflite",
            labels: "modelos/best_model_labels.txt",
            numThreads: 1,
            isAsset: true,
            useGpuDelegate: false)
        .then((value) {
      debugPrint("value: $value");
      classifyImage(widget.imagePath);
    }).catchError((e) {
      debugPrint("Error loading: $e");
    });
  }

  loadAndClassifyModel7() async {
    Tflite.loadModel(
            model: "modelos/best_model_7.tflite",
            labels: "modelos/best_model_7_labels.txt",
            numThreads: 1,
            isAsset: true,
            useGpuDelegate: false)
        .then((value) {
      debugPrint("value 7: $value");
      classifyImage7(widget.imagePath);
    }).catchError((e) {
      debugPrint("Error loading 7: $e");
    });
  }

  /*void _showToast() {
    Fluttertoast.showToast(
        msg: "Problema registado",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blue[600],
        textColor: Colors.white,
        fontSize: 16.0);
  }*/

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text('Resultados'),
          backgroundColor: Colors.transparent,
        ),
        body: Container(
          width: double.maxFinite,
          height: double.maxFinite,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 0, 110, 255),
              Color.fromARGB(255, 113, 43, 241),
            ],
          )),
          child: SingleChildScrollView(
            child: Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                //Image.file(File(picture.path), fit: BoxFit.cover, width: 250),
                const SizedBox(height: 110),
                Stack(
                  alignment: AlignmentDirectional.centerStart,
                  children: [
                    Image.file(
                      File(widget.imagePath),
                      height: 350,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [_getResult14(), _getResult7()],
                ),
              ]),
            ),
          ),
        ));
  }
}
