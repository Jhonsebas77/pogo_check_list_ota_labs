part of com.pogo_check_list_ota_labs.app.views;

class MegaEvolutionPokemonView extends ConsumerStatefulWidget {
  const MegaEvolutionPokemonView({super.key});
  static const String route = '/pokemon/megaevolution-dex';

  @override
  ConsumerState<MegaEvolutionPokemonView> createState() =>
      _MegaEvolutionPokemonState();
}

class _MegaEvolutionPokemonState
    extends ConsumerState<MegaEvolutionPokemonView> {
  bool displayOnlyMissingPokemon = false;
  final ScrollController _scrollController = ScrollController();
  bool isInTheEndOfTheList = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AsyncValue<PokemonFirebaseState> firebasePokemonState = ref.watch(
      firebasePokemonProvider,
    );
    double itemWidth = 150;
    return SafeArea(
      child: Scaffold(
        appBar: const CustomAppBar(title: 'Mega Evolution'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: WebContent(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: firebasePokemonState.when(
                data: (PokemonFirebaseState state) {
                  if (state.allMegaEvolutionPokemon.isEmpty) {
                    return const EmptyState();
                  }
                  List<PokemonModel> expandedPokemon = <PokemonModel>[
                    for (final PokemonModel pokemon
                        in state.allMegaEvolutionPokemon)
                      ...pokemon.withForms,
                  ];
                  List<PokemonModel> sortedPokemon =
                      expandedPokemon.where((PokemonModel pokemon) {
                          if (displayOnlyMissingPokemon) {
                            return !pokemon.alreadyCatch;
                          } else {
                            return pokemon.id != 0;
                          }
                        }).toList()
                        ..sort((PokemonModel a, PokemonModel b) {
                          int byId = a.id.compareTo(b.id);
                          return byId != 0
                              ? byId
                              : a.formOrder.compareTo(b.formOrder);
                        });
                  return SingleChildScrollView(
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: List<Widget>.generate(
                        sortedPokemon.length,
                        (int index) => SizedBox(
                          width: itemWidth,
                          child: PokemonListMegaEvolutionItem(
                            index: index,
                            selectPokemon: sortedPokemon[index],
                          ),
                        ),
                      ),
                    ),
                  );
                },
                error:
                    (Object error, StackTrace stackTrace) => SimpleErrorChip(
                      iconData: Icons.catching_pokemon,
                      error: error.toString(),
                      stackTrace: stackTrace,
                      text: 'Con la información de los Pokemon Mega',
                    ),
                loading: PokemonGigantamaxListShimmer.new,
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: ref.read(firebasePokemonProvider.notifier).refreshData,
          backgroundColor: Theme.of(context).colorScheme.secondary,
          child: Icon(
            Icons.update,
            color: Theme.of(context).colorScheme.onSecondary,
          ),
        ),
      ),
    );
  }
}
