part of com.pogo_check_list_ota_labs.app.views;

class AllPokemonAvailableView extends ConsumerStatefulWidget {
  const AllPokemonAvailableView({super.key});
  static const String route = '/pokemon/all-available';

  @override
  ConsumerState<AllPokemonAvailableView> createState() =>
      _AllPokemonAvailableViewState();
}

class _AllPokemonAvailableViewState
    extends ConsumerState<AllPokemonAvailableView>
    with
        PokemonListScrollMixin<AllPokemonAvailableView>,
        PokemonSearchMixin<AllPokemonAvailableView> {
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
          backgroundColor: Theme.of(context).colorScheme.primary,
          systemOverlayStyle: getSystemOverlayStyle(context),
          toolbarHeight: 82,
          elevation: 0,
          leading: const DexHeaderLeading(),
          actions: const DexHeaderActions().getActions(),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(104),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 4,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text(
                            'Pokédex',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          firebasePokemonState.when(
                            data: (PokemonFirebaseState state) {
                              int total = state.getTotalPokemonLength();
                              int caught = state.getAlreadyCatchPokemonLength();
                              String pct =
                                  total > 0
                                      ? (caught / total * 100).toStringAsFixed(
                                        2,
                                      )
                                      : '0.00';
                              return Text(
                                '$caught/$total ($pct%)',
                                style: const TextStyle(color: Colors.white54),
                              );
                            },
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
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Container(
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
                                    (
                                      BuildContext context,
                                    ) => <PopupMenuEntry<PokemonSortCriteria>>[
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
                    ],
                  ),
                ),
                buildSearchField(),
              ],
            ),
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: firebasePokemonState.when(
          data: (PokemonFirebaseState state) {
            if (state.allPokemon.isEmpty) {
              return const EmptyState();
            }
            // Se copia la lista (List.of) para no mutar el estado del provider
            // al ordenar in-place con sort().
            List<PokemonModel> sortedPokemon =
                displayOnlyMissingPokemon
                    ? state.allPokemon
                        .where(
                          (PokemonModel pokemon) =>
                              pokemon.available && !pokemon.alreadyCatch,
                        )
                        .toList()
                    : List<PokemonModel>.of(state.allPokemon);
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
                sortedPokemon.sort(
                  (PokemonModel a, PokemonModel b) => a.id.compareTo(b.id),
                );
                break;
              case PokemonSortCriteria.byEvolution:
                sortedPokemon.sort(
                  (PokemonModel a, PokemonModel b) => a.name.compareTo(b.name),
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
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: ListView.separated(
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
                    );
                  }
                },
              ),
            );
          },
          error:
              (Object error, StackTrace stackTrace) => SimpleErrorChip(
                iconData: Icons.catching_pokemon,
                error: error.toString(),
                stackTrace: stackTrace,
                text: 'Con la información de los Pokemon',
              ),
          loading: PokemonListShimmer.new,
        ),
        floatingActionButton: buildScrollButtons(),
      ),
    );
  }
}
