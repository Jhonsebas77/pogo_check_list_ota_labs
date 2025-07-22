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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          toolbarHeight: 82,
          leading: const DexHeaderLeading(),
          actions: const DexHeaderActions().getActions(),
          title: const Text(
            'Gigantamax',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        backgroundColor: const Color.fromRGBO(198, 73, 52, 1),
        body: firebasePokemonState.when(
          data: (PokemonFirebaseState state) {
            if (state.allGigantamaxPokemon.isEmpty) {
              return const EmptyState();
            }
            List<PokemonModel> sortedPokemon =
                state.allGigantamaxPokemon.where((PokemonModel pokemon) {
                    if (displayOnlyMissingPokemon) {
                      return !pokemon.alreadyCatch;
                    } else {
                      return pokemon.id != 0;
                    }
                  }).toList()
                  ..sort(
                    (PokemonModel a, PokemonModel b) => a.id.compareTo(b.id),
                  );
            return GridView.count(
              crossAxisCount: 3,
              children: List<PokemonListGigantamaxItem>.generate(
                sortedPokemon.length,
                (int index) => PokemonListGigantamaxItem(
                  index: index,
                  selectPokemon: sortedPokemon[index],
                ),
              ),
            );
          },
          error:
              (Object error, StackTrace stackTrace) =>
                  Center(child: Text('Error: $error')),
          loading: PokemonGigantamaxListShimmer.new,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await ref.read(firebasePokemonProvider.notifier).refreshData();
          },
          child: const Icon(Icons.update),
        ),
      ),
    );
  }
}
