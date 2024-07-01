import 'package:flutter/material.dart';
import 'package:flutter_dl_project/preview_page.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,

        floatingActionButtonTheme: const FloatingActionButtonThemeData(
            foregroundColor: Colors.black, backgroundColor: Colors.white),

        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black, backgroundColor: Colors.white)),

        // Define the default brightness and colors.
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.purple,
          brightness: Brightness.dark,
        ),

        // Define the default `TextTheme`. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 72,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: const MyHomePage(title: 'Classificador de veículos'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isLoadingBeforePreview = false;

  Future<void> _showLoadingDialog() async {
    isLoadingBeforePreview = true;
    await showDialog<bool>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return const PopScope(
            canPop: false,
            child: AlertDialog(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              content: Center(
                heightFactor: double.maxFinite,
                widthFactor: double.maxFinite,
                child: SpinKitDoubleBounce(
                  color: Color.fromARGB(255, 33, 82, 243),
                  size: 150.0,
                ),
              ),
            ));
      },
    );
  }

  void _goToPreview(String imagePath) async {
    if (context.mounted) {
      if (isLoadingBeforePreview == true) {
        Navigator.pop(context);
      }
      isLoadingBeforePreview = false;
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PreviewPage(
                    imagePath: imagePath,
                  )));
    }
  }

  void _getFromCamera() async {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      _showLoadingDialog();
      _goToPreview(pickedFile.path);
    }
  }

  void _getFromGallery() async {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _showLoadingDialog();
      String auxPath = pickedFile.path;
      _goToPreview(auxPath);
    }
  }

  void nextScreen(bool camera) async {
    if (camera) {
      _getFromCamera();
    } else {
      _getFromGallery();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(widget.title),
          elevation: 0.0,
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
              ])),
          child: Column(
            children: [
              Expanded(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 10.0),
                            child: FloatingActionButton(
                              heroTag: 'nextScreen',
                              onPressed: () {
                                nextScreen(true);
                              },
                              child: const Icon(Icons.camera),
                            ),
                          ),
                          Container(
                              margin: const EdgeInsets.only(left: 10.0),
                              child: FloatingActionButton(
                                heroTag: 'nextScreen2',
                                onPressed: () {
                                  nextScreen(false);
                                },
                                child: const Icon(Icons.image),
                              ))
                        ],
                      ),
                    ],
                  )
                ],
              ))
            ],
          ),
        ));
  }
}
