import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

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
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const ProviderScope(child: MyApp()));
  FlutterNativeSplash.remove();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
  ]);
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ThemeMode themeMode = ref.watch(themeModeProvider);
    return MaterialApp(
      title: 'Pogo Checks',
      theme: appTheme,
      darkTheme: appDarkTheme,
      themeMode: themeMode,
      home: const MyHomePage(title: 'Pogo Checks'),
    );
  }
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
        appBar: const CustomAppBar(),
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: const TabBarView(
          children: <Widget>[HomePoGoView(), PokedexView(), SettingsView()],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          child: SizedBox(
            height: 60,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                child: TabBar(
                  indicatorColor: Colors.transparent,
                  labelColor: Colors.white,
                  dividerColor: Colors.transparent,
                  labelStyle: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.4,
                  ),
                  tabs: const <Widget>[
                    Tab(icon: Icon(Icons.home_rounded), text: 'Inicio'),
                    Tab(
                      icon: Icon(Icons.catching_pokemon_rounded),
                      text: 'Pokédex',
                    ),
                    Tab(icon: Icon(Icons.settings_rounded), text: 'Ajustes'),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
