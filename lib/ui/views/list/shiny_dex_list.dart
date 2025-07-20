part of com.pogo_check_list_ota_labs.app.views;

class ShinyPokemonView extends ConsumerStatefulWidget {
  const ShinyPokemonView({super.key});
  static const String route = '/pokemon/shiny-dex';

  @override
  ConsumerState<ShinyPokemonView> createState() => _ShinyPokemonViewState();
}

class _ShinyPokemonViewState extends ConsumerState<ShinyPokemonView> {
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

  void _scrollToEnd() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 2),
      curve: Curves.easeInOut,
    );
    isInTheEndOfTheList = true;
    setState(() {});
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(seconds: 2),
      curve: Curves.easeInOut,
    );
    isInTheEndOfTheList = false;
    setState(() {});
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
          elevation: 0,
        ),
        backgroundColor: const Color.fromRGBO(198, 73, 52, 1),
        body: firebasePokemonState.when(
          data: (PokemonFirebaseState state) {
            if (state.allPokemon.isEmpty) {
              return const EmptyState();
            }
            List<PokemonModel> sortedPokemon =
                state.allPokemon.where((PokemonModel pokemon) {
                  if (displayOnlyMissingPokemon) {
                    return pokemon.shinyAvailable &&
                        !pokemon.alreadyCatchShinyVersion;
                  } else {
                    return pokemon.shinyAvailable;
                  }
                }).toList();
            return ListView.builder(
              controller: _scrollController,
              shrinkWrap: true,
              itemCount: sortedPokemon.length,
              itemBuilder: (BuildContext context, int index) {
                PokemonModel pokemon = sortedPokemon[index];
                return PokemonListItem(
                  index: pokemon.id,
                  selectPokemon: pokemon,
                  isShiny: true,
                );
              },
            );
          },
          error:
              (Object error, StackTrace stackTrace) =>
                  Center(child: Text('Error: $error')),
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: isInTheEndOfTheList ? _scrollToTop : _scrollToEnd,
          backgroundColor: Colors.indigo,
          child: Icon(
            isInTheEndOfTheList ? Icons.arrow_upward : Icons.arrow_downward,
          ),
        ),
      ),
    );
  }
}
