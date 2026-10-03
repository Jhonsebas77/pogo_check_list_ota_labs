part of com.pogo_check_list_ota_labs.app.widgets;

/// Campo de búsqueda reutilizable para las vistas de listas de Pokémon.
///
/// Comparte el mismo lenguaje visual que el resto de inputs de la app
/// (fondo oscuro translúcido, bordes redondeados) y muestra un botón para
/// limpiar el texto únicamente cuando hay contenido escrito.
class PokemonSearchField extends StatelessWidget {
  const PokemonSearchField({
    required this.controller,
    required this.onChanged,
    required this.onClear,
    this.hintText = 'Buscar por nombre',
    this.padding = const EdgeInsets.fromLTRB(24, 0, 24, 8),
    this.fillHeight = false,
    super.key,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final String hintText;
  final EdgeInsetsGeometry padding;

  /// Si es `true`, el campo ocupa todo el alto disponible con el texto
  /// centrado verticalmente (p. ej. para igualar el alto de otro control en
  /// la misma fila, ver [SearchHeaderRow]).
  final bool fillHeight;

  @override
  Widget build(BuildContext context) => Padding(
    padding: padding,
    child:
        fillHeight
            // El Focus no toma el foco; solo expone si el TextField interno lo
            // tiene, para pintar el mismo borde de foco que el resto de inputs.
            ? Focus(
              canRequestFocus: false,
              skipTraversal: true,
              child: Builder(
                builder:
                    (BuildContext context) => DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color:
                              Focus.of(context).hasFocus
                                  ? Theme.of(context).colorScheme.secondary
                                  : Colors.transparent,
                        ),
                      ),
                      child: Center(child: _buildTextField(context)),
                    ),
              ),
            )
            : MaxWidthInput(child: _buildTextField(context)),
  );

  Widget _buildTextField(BuildContext context) => TextField(
    controller: controller,
    textAlignVertical: TextAlignVertical.center,
    onChanged: onChanged,
    textInputAction: TextInputAction.search,
    style: const TextStyle(color: Colors.white),
    decoration: InputDecoration(
      isDense: true,
      hintText: hintText,
      hintStyle: const TextStyle(color: onPrimaryMuted),
      // Con fillHeight el fondo lo pinta el contenedor que ocupa todo el alto.
      filled: !fillHeight,
      fillColor: Colors.black12,
      prefixIcon: const Icon(Icons.search, color: Colors.white70),
      // Solo se reconstruye el sufijo cuando cambia el texto, evitando
      // rebuilds de toda la vista para mostrar/ocultar el botón de limpiar.
      suffixIcon: ValueListenableBuilder<TextEditingValue>(
        valueListenable: controller,
        builder:
            (BuildContext context, TextEditingValue value, Widget? child) =>
                value.text.isEmpty
                    ? const SizedBox.shrink()
                    : IconButton(
                      icon: const Icon(Icons.close, color: Colors.white70),
                      tooltip: 'Limpiar búsqueda',
                      onPressed: onClear,
                    ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(32),
        borderSide: const BorderSide(color: Colors.transparent),
      ),
      focusedBorder:
          fillHeight
              ? InputBorder.none
              : OutlineInputBorder(
                borderRadius: BorderRadius.circular(32),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
    ),
  );
}

/// Fila del header de las listas de Pokémon: [trailing] (switch y filtro)
/// queda pegado a la derecha y [search] centrado en x y en y, con el mismo
/// alto que [trailing].
///
/// Si no hay espacio para centrar el buscador sin que se monte sobre
/// [trailing] (pantallas angostas), el buscador ocupa el espacio libre a su
/// izquierda.
class SearchHeaderRow extends StatelessWidget {
  const SearchHeaderRow({
    required this.search,
    required this.trailing,
    super.key,
  });

  final Widget search;
  final Widget trailing;

  static const double _gap = 12;

  /// Ancho reservado a cada lado del buscador centrado para [trailing].
  static const double _trailingReserve = 160;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (BuildContext context, BoxConstraints constraints) {
      bool canCenter =
          constraints.maxWidth >=
          kMaxInputWidth + 2 * (_trailingReserve + _gap);
      if (!canCenter) {
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(child: search),
              const SizedBox(width: _gap),
              trailing,
            ],
          ),
        );
      }
      return Stack(
        children: <Widget>[
          Align(
            alignment: AlignmentDirectional.centerEnd,
            heightFactor: 1,
            child: trailing,
          ),
          Positioned.fill(
            child: Center(
              child: SizedBox(width: kMaxInputWidth, child: search),
            ),
          ),
        ],
      );
    },
  );
}

/// Centraliza la lógica de búsqueda por nombre de las vistas de listas de
/// Pokémon: gestiona el [TextEditingController], normaliza la consulta,
/// aplica un *debounce* para no filtrar en cada pulsación y expone helpers
/// para filtrar la lista y construir el campo de búsqueda.
///
/// La clase que lo use debe:
///  - renderizar [buildSearchField] (normalmente en el `bottom` del `AppBar`),
///  - y filtrar su lista con [applySearchFilter] antes de mostrarla.
mixin PokemonSearchMixin<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  final TextEditingController searchController = TextEditingController();

  /// Retardo entre la última pulsación y la aplicación del filtro.
  static const Duration _debounceDuration = Duration(milliseconds: 250);

  Timer? _debounce;

  /// Consulta ya normalizada (recortada y en minúsculas) que se usa al filtrar.
  String _searchQuery = '';

  String get searchQuery => _searchQuery;
  bool get hasSearchQuery => _searchQuery.isNotEmpty;

  @override
  void dispose() {
    _debounce?.cancel();
    searchController.dispose();
    super.dispose();
  }

  /// Programa la aplicación del filtro tras [_debounceDuration] sin escribir,
  /// normalizando la consulta una sola vez y evitando `setState` redundantes.
  void onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(_debounceDuration, () {
      String normalized = value.trim().toLowerCase();
      if (normalized == _searchQuery) {
        return;
      }
      setState(() => _searchQuery = normalized);
    });
  }

  /// Limpia el campo y el filtro de forma inmediata.
  void clearSearch() {
    _debounce?.cancel();
    searchController.clear();
    if (_searchQuery.isNotEmpty) {
      setState(() => _searchQuery = '');
    }
  }

  /// Devuelve solo los Pokémon cuyo nombre contiene la consulta activa.
  /// Si no hay búsqueda, retorna la misma lista sin copiarla.
  List<PokemonModel> applySearchFilter(List<PokemonModel> pokemon) {
    if (_searchQuery.isEmpty) {
      return pokemon;
    }
    return pokemon
        .where(
          (PokemonModel item) => item.name.toLowerCase().contains(_searchQuery),
        )
        .toList();
  }

  /// Construye el campo de búsqueda enlazado a este mixin.
  Widget buildSearchField({
    EdgeInsetsGeometry padding = const EdgeInsets.fromLTRB(24, 0, 24, 8),
    bool fillHeight = false,
  }) => PokemonSearchField(
    controller: searchController,
    onChanged: onSearchChanged,
    onClear: clearSearch,
    padding: padding,
    fillHeight: fillHeight,
  );
}
