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
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          toolbarHeight: 82,
          leading: const DexHeaderLeading(),
          actions: const DexHeaderActions().getActions(),
          title: const Text(
            'Mega Evolution',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: firebasePokemonState.when(
              data: (PokemonFirebaseState state) {
                if (state.allMegaEvolutionPokemon.isEmpty) {
                  return const EmptyState();
                }
                List<PokemonModel> sortedPokemon =
                    state.allMegaEvolutionPokemon.where((PokemonModel pokemon) {
                        if (displayOnlyMissingPokemon) {
                          return !pokemon.alreadyCatch;
                        } else {
                          return pokemon.id != 0;
                        }
                      }).toList()
                      ..sort(
                        (PokemonModel a, PokemonModel b) =>
                            a.id.compareTo(b.id),
                      );
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
