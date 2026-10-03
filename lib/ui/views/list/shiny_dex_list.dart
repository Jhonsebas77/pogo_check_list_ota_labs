part of com.pogo_check_list_ota_labs.app.views;

class ShinyPokemonView extends ConsumerStatefulWidget {
  const ShinyPokemonView({super.key});
  static const String route = '/pokemon/shiny-dex';

  @override
  ConsumerState<ShinyPokemonView> createState() => _ShinyPokemonViewState();
}

class _ShinyPokemonViewState extends ConsumerState<ShinyPokemonView>
    with
        PokemonListScrollMixin<ShinyPokemonView>,
        PokemonSearchMixin<ShinyPokemonView> {
  bool displayOnlyMissingPokemon = false;
  bool isFilterApply = false;
  PokemonSortCriteria _currentSortCriteria = PokemonSortCriteria.byDex;

  IconData getFilterIcon() {
    switch (_currentSortCriteria) {
      case PokemonSortCriteria.byName:
        return Icons.sort_by_alpha;
      case PokemonSortCriteria.byEvolution:
        return Icons.upgrade;
      case PokemonSortCriteria.byDex:
        return Icons.numbers;
    }
  }

  @override
  Widget build(BuildContext context) {
    AsyncValue<PokemonFirebaseState> firebasePokemonState = ref.watch(
      firebasePokemonProvider,
    );
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          systemOverlayStyle: getSystemOverlayStyle(context),
          toolbarHeight: 82,
          leading: const DexHeaderLeading(),
          actions: const DexHeaderActions().getActions(),
          title: const Text(
            'ShinyDex',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(100),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 4,
                  ),
                  child: Center(
                    child: firebasePokemonState.when(
                      data:
                          (PokemonFirebaseState state) => Text(
                            '${state.getAlreadyCatchPokemonShinyLength()}/${state.getShinyAvailablePokemonLength()} (${(state.getAlreadyCatchPokemonShinyLength() / state.getShinyAvailablePokemonLength() * 100).toStringAsFixed(2)}%)',
                            style: const TextStyle(color: Colors.white),
                          ),
                      error:
                          (Object error, StackTrace stackTrace) =>
                              SimpleErrorChip(
                                iconData: Icons.catching_pokemon,
                                error: error.toString(),
                                stackTrace: stackTrace,
                                isSmall: true,
                              ),
                      loading:
                          () => const SimpleTextShimmer(
                            widthShimmer: 100,
                            heightShimmer: 10,
                          ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
                  child: SearchHeaderRow(
                    search: buildSearchField(
                      padding: EdgeInsets.zero,
                      fillHeight: true,
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.only(
                        left: 12,
                        top: 8,
                        bottom: 8,
                        right: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Switch(
                            value: displayOnlyMissingPokemon,
                            thumbIcon: thumbIcon,
                            activeThumbColor:
                                Theme.of(context).colorScheme.secondary,
                            onChanged: (_) async {
                              setState(() {
                                displayOnlyMissingPokemon =
                                    !displayOnlyMissingPokemon;
                              });
                              await ref
                                  .read(firebasePokemonProvider.notifier)
                                  .refreshData();
                            },
                          ),
                          const SizedBox(width: 16),
                          PopupMenuButton<PokemonSortCriteria>(
                            icon:
                                isFilterApply
                                    ? Row(
                                      children: <Widget>[
                                        Icon(
                                          getFilterIcon(),
                                          color: Colors.white,
                                        ),
                                        const Icon(
                                          Icons.filter_list_rounded,
                                          color: Colors.white,
                                        ),
                                      ],
                                    )
                                    : const Icon(Icons.filter_list_rounded),
                            tooltip: 'Ordenar Pokémones',
                            color: Theme.of(context).colorScheme.primary,
                            offset: const Offset(0, 60),
                            onSelected: (PokemonSortCriteria result) {
                              setState(() {
                                _currentSortCriteria = result;
                                isFilterApply = true;
                              });
                            },
                            itemBuilder:
                                (BuildContext context) =>
                                    <PopupMenuEntry<PokemonSortCriteria>>[
                                      const PopupMenuItem<PokemonSortCriteria>(
                                        value: PokemonSortCriteria.byName,
                                        child: SimpleChipWithIcon(
                                          iconData: Icons.sort_by_alpha,
                                          text: 'Nombre',
                                        ),
                                      ),
                                      const PopupMenuItem<PokemonSortCriteria>(
                                        value: PokemonSortCriteria.byDex,
                                        child: SimpleChipWithIcon(
                                          iconData: Icons.numbers,
                                          text: 'Déx',
                                        ),
                                      ),
                                    ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: WebContent(
          child: firebasePokemonState.when(
            data: (PokemonFirebaseState state) {
              if (state.allPokemon.isEmpty) {
                return const EmptyState();
              }
              // Cada especie se expande a base + formas para mostrar
              // todas sus formas alternativas (p. ej. Raichu y
              // Raichu-Alola) en filas.
              List<PokemonModel> expandedPokemon = <PokemonModel>[
                for (final PokemonModel pokemon in state.allPokemon)
                  ...pokemon.withForms,
              ];
              // Se copia la lista (List.of) para no mutar el estado del
              // provider al ordenar in-place con sort().
              List<PokemonModel> sortedPokemon =
                  displayOnlyMissingPokemon
                      ? expandedPokemon
                          .where(
                            (PokemonModel pokemon) =>
                                pokemon.shinyAvailable &&
                                !pokemon.alreadyCatchShinyVersion,
                          )
                          .toList()
                      : List<PokemonModel>.of(expandedPokemon);
              // Se filtra por nombre antes de ordenar para ordenar menos ítems.
              sortedPokemon = applySearchFilter(sortedPokemon);
              switch (_currentSortCriteria) {
                case PokemonSortCriteria.byName:
                  sortedPokemon.sort(
                    (PokemonModel a, PokemonModel b) =>
                        a.name.toLowerCase().compareTo(b.name.toLowerCase()),
                  );
                  break;
                case PokemonSortCriteria.byDex:
                  sortedPokemon.sort((PokemonModel a, PokemonModel b) {
                    int byId = a.id.compareTo(b.id);
                    // Desempate: la base (order 0) antes que sus formas.
                    return byId != 0
                        ? byId
                        : a.formOrder.compareTo(b.formOrder);
                  });
                  break;
                case PokemonSortCriteria.byEvolution:
                  sortedPokemon.sort(
                    (PokemonModel a, PokemonModel b) =>
                        a.name.compareTo(b.name),
                  );
                  break;
              }
              if (sortedPokemon.isEmpty) {
                return EmptyState(
                  message:
                      hasSearchQuery
                          ? 'No hay Pokémon que coincidan con "$searchQuery"'
                          : 'Lo sentimos, aun no tenemos registros',
                );
              }
              // Sincroniza la visibilidad inicial de los botones tras el primer
              // frame (p. ej. ocultar "bajar" si la lista cabe en pantalla).
              scheduleScrollButtonsSync();
              return ListView.separated(
                separatorBuilder:
                    (BuildContext _, int __) => const Padding(
                      padding: EdgeInsets.symmetric(vertical: 4),
                    ),
                controller: scrollController,
                itemCount: sortedPokemon.length,
                itemBuilder: (BuildContext context, int index) {
                  PokemonModel pokemon = sortedPokemon[index];
                  if (pokemon.id == 0) {
                    return const SizedBox();
                  } else {
                    return PokemonListItem(
                      index: pokemon.id,
                      selectPokemon: pokemon,
                      isShiny: true,
                    );
                  }
                },
              );
            },
            error:
                (Object error, StackTrace stackTrace) => SimpleErrorChip(
                  iconData: Icons.catching_pokemon,
                  error: error.toString(),
                  stackTrace: stackTrace,
                  text: 'Con la información de los Pokemon Shiny',
                ),
            loading: PokemonListShimmer.new,
          ),
        ),
        floatingActionButton: buildScrollButtons(),
      ),
    );
  }
}
