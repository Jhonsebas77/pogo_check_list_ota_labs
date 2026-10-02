part of com.pogo_check_list_ota_labs.app.views;

class GigantamaxPokemonView extends ConsumerStatefulWidget {
  const GigantamaxPokemonView({super.key});
  static const String route = '/pokemon/gigantamax-dex';

  @override
  ConsumerState<GigantamaxPokemonView> createState() =>
      _GigantamaxPokemonViewState();
}

class _GigantamaxPokemonViewState extends ConsumerState<GigantamaxPokemonView> {
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
        appBar: const CustomAppBar(title: 'Gigantamax'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: firebasePokemonState.when(
              data: (PokemonFirebaseState state) {
                if (state.allGigantamaxPokemon.isEmpty) {
                  return const EmptyState();
                }
                List<PokemonModel> expandedPokemon = <PokemonModel>[
                  for (final PokemonModel pokemon in state.allGigantamaxPokemon)
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
                        child: PokemonListGigantamaxItem(
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
                    text: 'Con la información de los Pokemon Gigantamax',
                  ),
              loading: PokemonGigantamaxListShimmer.new,
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
