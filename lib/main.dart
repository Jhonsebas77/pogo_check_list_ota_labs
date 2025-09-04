import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'core/utils/constants.dart';
import 'firebase_options.dart';
import 'ui/theme.dart';
import 'ui/views/views.dart';
import 'ui/widgets/widgets.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initializeDateFormatting();
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const ProviderScope(child: MyApp()));
  FlutterNativeSplash.remove();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
  ]);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Pogo Checks',
    theme: appTheme,
    darkTheme: appDarkTheme,
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
          leading: const DexHeaderLeading(),
          actions: const DexHeaderActions().getActions(),
        ),
        backgroundColor: const Color.fromRGBO(198, 73, 52, 1),
        body: const TabBarView(
          children: <Widget>[HomePoGoView(), PokedexView(), SettingsView()],
        ),
        bottomNavigationBar: const TabBar(
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          labelStyle: TextStyle(color: Colors.white, fontSize: 18),
          tabs: <Widget>[
            Tab(icon: Icon(Icons.home), text: 'Inicio'),
            Tab(icon: Icon(Icons.catching_pokemon), text: 'Pokedex'),
            Tab(icon: Icon(Icons.settings), text: 'Ajustes'),
          ],
        ),
      ),
    ),
  );
}
