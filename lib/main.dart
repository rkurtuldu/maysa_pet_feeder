import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:maysa/interval.dart';
import 'firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('tr'), Locale('en')],
      title: 'Maysa Feeder',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.pets),
        centerTitle: true,
        title: const Text("Maysa Otomatik Besleyici"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                "assets/kedi.png",
                height: 180,
              ),
              const SizedBox(
                height: 100,
              ),
              ElevatedButton(
                  style: const ButtonStyle(
                      elevation: MaterialStatePropertyAll(5),
                      fixedSize: MaterialStatePropertyAll(Size.fromWidth(240))),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) {
                        return const IntervalFeed();
                      },
                    ));
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text("Otomatik Besleme Ayarları"),
                  )),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                  style: const ButtonStyle(
                      elevation: MaterialStatePropertyAll(5),
                      fixedSize: MaterialStatePropertyAll(Size.fromWidth(240))),
                  onPressed: () {
                    feedNow();
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Besleme Yapıldı")));
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text("Şimdi Besle"),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  void feedNow() async {
    final ref = FirebaseDatabase.instance.ref();
    await ref.update({
      "main/feedNow": "feed",
    });
  }
}
