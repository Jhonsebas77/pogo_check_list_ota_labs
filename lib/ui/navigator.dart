library com.pogo_check_list_ota_labs.app.navigator;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/enums/enums.dart';
import '../core/utils/utils.dart';
import 'widgets/widgets.dart';

class CustomNavigator {
  static const Logger _log = Logger('CustomNavigator');

  /// [routeName] es la ruta que se muestra en la barra del navegador (web);
  /// usa la constante `route` de la vista, p. ej. `DetailsScreen.route`.
  void push(
    BuildContext context,
    Widget view, {
    required String routeName,
    CustomNavigationAnimation animation = CustomNavigationAnimation.slideRight,
  }) {
    Navigator.of(context).push(
      AnimationRoute(
        page: view,
        animationType: animation,
        settings: RouteSettings(name: routeName),
      ),
    );
  }

  void pop(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.of(context).pop();
    } else {
      _log.error('pop: no hay más páginas para hacer pop.');
      if (context.mounted) {
        showErrorSnackBar(context, 'No hay mas páginas');
      }
    }
  }

  bool canPop(BuildContext context) => Navigator.canPop(context);
}

/// Mantiene en la barra del navegador (web) la ruta de lo que se ve en la
/// ruta raíz (login o el tab activo). Flutter siempre nombra la ruta raíz
/// `/`, y el [Navigator] vuelve a anunciar ese nombre al hacer pop.
class RootRouteObserver extends NavigatorObserver {
  RootRouteObserver._();

  static final RootRouteObserver instance = RootRouteObserver._();

  String? _rootRoute;

  void setRootRoute(String route) {
    if (_rootRoute == route) return;
    _rootRoute = route;
    _report(route);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    String? rootRoute = _rootRoute;
    if (rootRoute == null || !(previousRoute?.isFirst ?? false)) return;
    // El Navigator anuncia `/` después de notificar a los observers, así que
    // se sobrescribe en un microtask.
    scheduleMicrotask(() => _report(rootRoute));
  }

  static void _report(String route) => SystemNavigator.routeInformationUpdated(
    uri: Uri.parse(route),
    replace: true,
  );
}

class AnimationRoute extends PageRouteBuilder<Widget> {
  AnimationRoute({
    required this.page,
    CustomNavigationAnimation animationType =
        CustomNavigationAnimation.slideRight,
    super.settings,
  }) : super(
         transitionDuration: const Duration(milliseconds: 300),
         pageBuilder:
             (
               BuildContext context,
               Animation<double> animation,
               Animation<double> secondaryAnimation,
             ) => page,
         transitionsBuilder:
             (
               BuildContext context,
               Animation<double> animation,
               Animation<double> secondaryAnimation,
               Widget child,
             ) => switch (animationType) {
               CustomNavigationAnimation.fade => FadeTransition(
                 opacity: animation,
                 child: child,
               ),
               CustomNavigationAnimation.slideRight => SlideTransition(
                 position: animation.drive(_slideFromRight),
                 child: child,
               ),
               CustomNavigationAnimation.scale => ScaleTransition(
                 scale: animation.drive(_scaleUp),
                 child: child,
               ),
               CustomNavigationAnimation.scaleFade => ScaleTransition(
                 scale: animation.drive(_scaleUp),
                 child: FadeTransition(opacity: animation, child: child),
               ),
               CustomNavigationAnimation.slideBottom => SlideTransition(
                 position: animation.drive(_slideFromBottom),
                 child: child,
               ),
             },
       );
  final Widget page;

  static final Tween<Offset> _slideFromRight = Tween<Offset>(
    begin: const Offset(1, 0),
    end: Offset.zero,
  );
  static final Tween<Offset> _slideFromBottom = Tween<Offset>(
    begin: const Offset(0, 1),
    end: Offset.zero,
  );
  static final Tween<double> _scaleUp = Tween<double>(begin: 0.5, end: 1);
}
