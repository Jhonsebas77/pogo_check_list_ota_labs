import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'core/utils/constants.dart';
import 'firebase_options.dart';
import 'ui/theme.dart';
import 'ui/views/views.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initializeDateFormatting();
  runApp(const ProviderScope(child: MyApp()));
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
  ]);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Pogo Checks',
    theme: lightTheme,
    darkTheme: darkTheme,
    themeMode: ThemeMode.system,
    home: const MyHomePage(title: 'Pogo Checks'),
  );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({required this.title, super.key});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void initializeFirebase() {
    FirebaseApp firebaseApp = Firebase.app();
    FirebaseDatabase.instanceFor(app: firebaseApp, databaseURL: databaseURL);
  }
    Widget _buildSmallCircle(Color color) => Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  @override
  Widget build(BuildContext context) => DefaultTabController(
    length: 3,
    child: SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          elevation: 0,
          toolbarHeight: 82,
                 leading: Padding(
          padding: const EdgeInsets.all(8),
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFF5A79C8),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4),
            ),
          ),
        ),
        actions: <Widget>[
          _buildSmallCircle(const Color(0xFFA02C2D)),
          const SizedBox(width: 8),
          _buildSmallCircle(const Color(0xFFDDC35B)),
          const SizedBox(width: 8),
          _buildSmallCircle(const Color(0xFF78B47C)),
        ],
        ),
        backgroundColor: const Color.fromRGBO(198, 73, 52, 1),
        body: const TabBarView(
          children: <Widget>[HomePoGoView(), PokedexView(), SettingsView()],
        ),
        bottomNavigationBar: const TabBar(
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          tabs: <Widget>[
            Tab(icon: Icon(Icons.home, color: Colors.white), text: 'Inicio'),
            Tab(
              icon: Icon(Icons.catching_pokemon, color: Colors.white),
              text: 'Pokedex',
            ),
            Tab(
              icon: Icon(Icons.settings, color: Colors.white),
              text: 'Ajustes',
            ),
          ],
        ),
      ),
    ),
  );
}
