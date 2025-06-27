import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:nested/nested.dart';
import 'package:provider/provider.dart';

import 'core/providers/providers.dart';
import 'core/utils/constants.dart';
import 'firebase_options.dart';
import 'ui/theme.dart';
import 'ui/views/views.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initializeDateFormatting();
  runApp(const MyApp());
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
  ]);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MultiProvider(
    providers: <SingleChildWidget>[
      ChangeNotifierProvider<FirebaseProvider>(
        create: (_) => FirebaseProvider(),
      ),
    ],
    child: MaterialApp(
      title: 'Pogo Checks',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      home: const MyHomePage(title: 'Pogo Checks'),
    ),
  );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({required this.title, super.key});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      FirebaseProvider firebaseProvider = Provider.of<FirebaseProvider>(
        context,
        listen: false,
      )..initializeFirebase();
      await firebaseProvider.getPokemonData();
    });
    super.initState();
  }

  void initializeFirebase() {
    FirebaseApp firebaseApp = Firebase.app();
    FirebaseDatabase.instanceFor(app: firebaseApp, databaseURL: databaseURL);
  }

  @override
  Widget build(BuildContext context) => Stack(
    children: <Widget>[
      SafeArea(
        child: Image.asset(
          'assets/BG_Home.png',
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.fill,
        ),
      ),
      Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          elevation: 0,
        ),
        backgroundColor: Colors.transparent,
        body: const HomePoGoView(),
        bottomNavigationBar: const Padding(
          padding: EdgeInsets.all(8),
          child: SelectableText(
            'By Ota_Labs V.1.0.0+2',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ],
  );
}
