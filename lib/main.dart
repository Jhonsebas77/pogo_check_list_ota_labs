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
import 'core/utils/utils.dart';
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
    return MaterialApp(
      title: 'Pogo Checks',
      theme: appTheme,
      darkTheme: appDarkTheme,
      themeMode: themeMode,
      navigatorObservers: <NavigatorObserver>[RootRouteObserver.instance],
      // No se usa `home`: Flutter no lo permite junto a
      // `onGenerateInitialRoutes`. La entrada `/` queda como respaldo.
      routes: <String, WidgetBuilder>{
        Navigator.defaultRouteName: (BuildContext context) => const _RootGate(),
      },
      onGenerateInitialRoutes: _generateInitialRoutes,
    );
  }

  static const Logger _log = Logger('MyApp');

  /// En web la ruta inicial es la URL del navegador (p. ej. `/pokedex`, que
  /// escribe [RootRouteObserver]). La app no usa rutas nombradas, así que
  /// siempre se arranca en la raíz `/` y solo se usa la URL para elegir el
  /// tab inicial; sin esto Flutter lanza "Could not navigate to initial route".
  static List<Route<dynamic>> _generateInitialRoutes(String initialRoute) =>
      <Route<dynamic>>[
        MaterialPageRoute<void>(
          settings: const RouteSettings(name: Navigator.defaultRouteName),
          builder:
              (BuildContext context) =>
                  _RootGate(initialTabRoute: _resolveTabRoute(initialRoute)),
        ),
      ];

  static String? _resolveTabRoute(String initialRoute) {
    Uri? uri = Uri.tryParse(initialRoute);
    if (uri == null) {
      _log.error('Ruta inicial inválida "$initialRoute"; se usa Inicio.');
      return null;
    }
    String path = uri.path;
    if (MyHomePage.tabRoutes.contains(path)) return path;
    if (path != Navigator.defaultRouteName && path != LoginView.route) {
      _log.warning(
        'La ruta inicial "$path" no se puede restaurar; se usa Inicio.',
      );
    }
    return null;
  }
}

/// Raíz de la app: muestra el login o el home según la sesión.
class _RootGate extends ConsumerWidget {
  const _RootGate({this.initialTabRoute});

  final String? initialTabRoute;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isAuthenticated = ref.watch(
      authProvider.select((AuthStatus auth) => auth.isAuthenticated),
    );
    return isAuthenticated
        ? MyHomePage(title: 'Pogo Checks', initialTabRoute: initialTabRoute)
        : const LoginView();
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({required this.title, this.initialTabRoute, super.key});

  final String title;

  /// Ruta del tab con el que arranca (una de [tabRoutes]); `null` es Inicio.
  final String? initialTabRoute;

  static const List<String> tabRoutes = <String>[
    HomePoGoView.route,
    PokedexView.route,
    SettingsView.route,
  ];

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController = TabController(
    length: MyHomePage.tabRoutes.length,
    initialIndex: _initialTabIndex,
    vsync: this,
  )..addListener(_reportTabRoute);

  int get _initialTabIndex {
    int index = MyHomePage.tabRoutes.indexOf(widget.initialTabRoute ?? '');
    return index < 0 ? 0 : index;
  }

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

  void _reportTabRoute() => RootRouteObserver.instance.setRootRoute(
    MyHomePage.tabRoutes[_tabController.index],
  );

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
