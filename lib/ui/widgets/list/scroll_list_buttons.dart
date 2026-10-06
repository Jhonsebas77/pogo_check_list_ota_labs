part of com.pogo_check_list_ota_labs.app.widgets;

/// Botones flotantes reutilizables para desplazar una lista.
///
/// Muestra el botón de subir solo cuando [canScrollUp] es `true` y el de bajar
/// solo cuando [canScrollDown] es `true`, de modo que se ocultan al llegar al
/// inicio o al final de la lista respectivamente.
class ScrollListButtons extends StatelessWidget {
  const ScrollListButtons({
    required this.canScrollUp,
    required this.canScrollDown,
    required this.onScrollUp,
    required this.onScrollDown,
    this.heroTagPrefix = 'scrollList',
    super.key,
  });

  final bool canScrollUp;
  final bool canScrollDown;
  final VoidCallback onScrollUp;
  final VoidCallback onScrollDown;

  /// Prefijo para los `heroTag` de los FAB. Debe ser único por vista para
  /// evitar conflictos de Hero durante las transiciones de navegación.
  final String heroTagPrefix;

  @override
  Widget build(BuildContext context) {
    Color background = Theme.of(context).colorScheme.secondary;
    Color foreground = Theme.of(context).colorScheme.onSecondary;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (canScrollUp)
          FloatingActionButton(
            heroTag: '${heroTagPrefix}_scrollUp',
            mini: true,
            onPressed: onScrollUp,
            backgroundColor: background,
            child: Icon(Icons.keyboard_arrow_up, color: foreground),
          ),
        if (canScrollUp && canScrollDown) const SizedBox(height: 12),
        if (canScrollDown)
          FloatingActionButton(
            heroTag: '${heroTagPrefix}_scrollDown',
            mini: true,
            onPressed: onScrollDown,
            backgroundColor: background,
            child: Icon(Icons.keyboard_arrow_down, color: foreground),
          ),
      ],
    );
  }
}

/// Centraliza la lógica de scroll de las vistas de listas de Pokémon:
/// gestiona el [ScrollController], calcula la visibilidad de los botones de
/// subir/bajar y expone helpers para desplazar la lista una pantalla a la vez.
///
/// La clase que lo use debe:
///  - asignar [scrollController] al `controller` de su `ListView`,
///  - llamar a [scheduleScrollButtonsSync] dentro del `build` de la lista,
///  - y renderizar [buildScrollButtons] como `floatingActionButton`.
mixin PokemonListScrollMixin<T extends ConsumerStatefulWidget>
    on ConsumerState<T> {
  final ScrollController scrollController = ScrollController();
  bool _canScrollUp = false;
  bool _canScrollDown = false;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_updateScrollButtons);
  }

  @override
  void dispose() {
    scrollController
      ..removeListener(_updateScrollButtons)
      ..dispose();
    super.dispose();
  }

  /// Recalcula la visibilidad de los botones según la posición real del scroll.
  void _updateScrollButtons() {
    if (!scrollController.hasClients) {
      return;
    }
    ScrollPosition position = scrollController.position;
    bool canScrollUp = position.pixels > position.minScrollExtent + 8;
    bool canScrollDown = position.pixels < position.maxScrollExtent - 8;
    if (canScrollUp != _canScrollUp || canScrollDown != _canScrollDown) {
      setState(() {
        _canScrollUp = canScrollUp;
        _canScrollDown = canScrollDown;
      });
    }
  }

  /// Sincroniza la visibilidad inicial de los botones tras el primer frame
  /// (p. ej. ocultar "bajar" si la lista cabe entera en pantalla).
  void scheduleScrollButtonsSync() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateScrollButtons());
  }

  /// Desplaza la lista [delta] px sin salirse de sus límites.
  void _scrollBy(double delta) {
    if (!scrollController.hasClients) {
      return;
    }
    ScrollPosition position = scrollController.position;
    double target = (position.pixels + delta).clamp(
      position.minScrollExtent,
      position.maxScrollExtent,
    );
    scrollController.animateTo(
      target,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  /// Sube una pantalla (los elementos visibles).
  void scrollUp() => _scrollBy(-scrollController.position.viewportDimension);

  /// Baja una pantalla (los elementos visibles).
  void scrollDown() => _scrollBy(scrollController.position.viewportDimension);

  /// Construye la columna de botones flotantes, con `heroTag` únicos por vista.
  Widget buildScrollButtons() => ScrollListButtons(
    heroTagPrefix: widget.runtimeType.toString(),
    canScrollUp: _canScrollUp,
    canScrollDown: _canScrollDown,
    onScrollUp: scrollUp,
    onScrollDown: scrollDown,
  );
}
