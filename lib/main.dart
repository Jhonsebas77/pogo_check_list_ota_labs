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
import 'ui/widgets/widgets.dart';

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
      await firebaseProvider.getPokemonData(context);
      if (mounted) await firebaseProvider.getPokemonGigantamaxData(context);
      if (mounted) await firebaseProvider.getTrainerData(context);
    });
    super.initState();
  }

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
          title: const HeaderFromImage(),
          toolbarHeight: 82,
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
