import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/constants/constants.dart';
import 'core/providers/providers.dart';
import 'firebase_options.dart';
import 'ui/navigator.dart';
import 'ui/theme.dart';
import 'ui/views/views.dart';
import 'ui/widgets/widgets.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  if (supabaseUrl.isEmpty ||
      supabasePublishableKey.isEmpty ||
      hardcodedEmail.isEmpty ||
      databaseURL.isEmpty) {
    throw StateError(
      'Faltan las credenciales. Corre la app con '
      '--dart-define=SUPABASE_URL=... '
      '--dart-define=SUPABASE_PUBLISHABLE_KEY=... '
      '--dart-define=AUTH_EMAIL=... '
      '--dart-define=FIREBASE_DATABASE_URL=... '
      '(o --dart-define-from-file=config/dart_defines.local.json).',
    );
  }
  await Supabase.initialize(
    url: supabaseUrl,
    publishableKey: supabasePublishableKey,
  );
  await initializeDateFormatting();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
  ]);
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const ProviderScope(child: MyApp()));
  FlutterNativeSplash.remove();
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ThemeMode themeMode = ref.watch(themeModeProvider);
    bool isAuthenticated = ref.watch(
      authProvider.select((AuthStatus auth) => auth.isAuthenticated),
    );
    return MaterialApp(
      title: 'Pogo Checks',
      theme: appTheme,
      darkTheme: appDarkTheme,
      themeMode: themeMode,
      navigatorObservers: <NavigatorObserver>[RootRouteObserver.instance],
      home:
          isAuthenticated
              ? const MyHomePage(title: 'Pogo Checks')
              : const LoginView(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({required this.title, super.key});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  static const List<String> _tabRoutes = <String>[
    HomePoGoView.route,
    PokedexView.route,
    SettingsView.route,
  ];

  late final TabController _tabController = TabController(
    length: _tabRoutes.length,
    vsync: this,
  )..addListener(_reportTabRoute);

  @override
  void initState() {
    super.initState();
    _reportTabRoute();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _reportTabRoute() =>
      RootRouteObserver.instance.setRootRoute(_tabRoutes[_tabController.index]);

  void initializeFirebase() {
    FirebaseApp firebaseApp = Firebase.app();
    FirebaseDatabase.instanceFor(app: firebaseApp, databaseURL: databaseURL);
  }

  @override
  Widget build(BuildContext context) => SafeArea(
    child: Scaffold(
      appBar: const CustomAppBar(),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: WebContent(
        child: TabBarView(
          controller: _tabController,
          children: const <Widget>[
            HomePoGoView(),
            PokedexView(),
            SettingsView(),
          ],
        ),
      ),
      bottomNavigationBar: MaxWidthInput(
        maxWidth: kMaxContentWidth,
        child: Padding(
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
                  controller: _tabController,
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
