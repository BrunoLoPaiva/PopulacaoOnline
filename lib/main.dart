import 'package:app/data/requests.dart';
import 'package:app/web/web_login.dart';
import 'package:app/widgets/firebase_config.dart';
import 'package:flutter/material.dart';
import 'mobile/mobile_home.dart';
import 'web/web_home.dart';
import 'package:firebase_core/firebase_core.dart';

var curPosition = [0.0, 0.0];
bool userAutenticated = true;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: firebase_options);

  runApp(const MyApp());
  allRequests.forEach((k, v) => v.update());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'População Online',
      theme:
          ThemeData.dark() /*(
        primarySwatch: Colors.blue,
      )*/
      ,
      home: const MyHomePage(title: 'Mapa'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return MediaQuery.of(context).size.width < 850
        ? MobileHome()
        : userAutenticated
            ? WebHome()
            : WebLogin();
  }
}
