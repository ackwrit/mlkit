import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mlkit/firebase_options.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  //variable
  late TextEditingController controller;
  late LanguageIdentifier identifer;
  String langSimple = "";
  String langMultiple ="";



  //méthode
  getSimple() async{
    langSimple ="";
    if(controller.text == "") return;
    String phrase = controller.text;
    final langageIdenfied = await  identifer.identifyLanguage(phrase);
    setState(() {
      langSimple = langageIdenfied;
    });

  }

  getMultiple() async{
    langMultiple = "";
    if(controller.text == "") return;
    String phrase = controller.text;
    final langsIdenfied = await identifer.identifyPossibleLanguages(phrase);
    if(langsIdenfied.isEmpty){
      langMultiple = "Nous n'avons pas pu trouver de corrsepondance";
    }
    else
      {
        for(var lang in langsIdenfied){
          setState(() {
            langMultiple += "${lang.languageTag}, confiance : ${(lang.confidence * 100).toInt()} %";
          });

        }
      }

  }

  @override
  void initState() {
    controller = TextEditingController();
    identifer = LanguageIdentifier(confidenceThreshold: 0.4);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    identifer.close();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text("Machine Learning"),
      ),
      body:  Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: "Texte à identifié"
              ),

            ),

            Text("Texte simple identifié : $langSimple"),

            Text("Text multiple identifiés :$langMultiple"),

            ElevatedButton(
                onPressed: getSimple,
                child: const Text("Une langue")
            ),
            ElevatedButton(
                onPressed: getMultiple,
                child: const Text("Plusieurs Langues")
            ),
          ],
        ),
      )
    );
  }
}
