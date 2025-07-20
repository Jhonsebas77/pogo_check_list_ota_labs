part of com.pogo_check_list_ota_labs.app.views;

class AllPokemonAvailableView extends ConsumerStatefulWidget {
  const AllPokemonAvailableView({super.key});
  static const String route = '/pokemon/all-available';

  @override
  ConsumerState<AllPokemonAvailableView> createState() =>
      _AllPokemonAvailableViewState();
}

class _AllPokemonAvailableViewState
    extends ConsumerState<AllPokemonAvailableView> {
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
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
    isInTheEndOfTheList = true;
    setState(() {});
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(seconds: 1),
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
    ref.listen(firebasePokemonProvider, (
      AsyncValue<PokemonFirebaseState>? previous,
      AsyncValue<PokemonFirebaseState> next,
    ) {
      if (next is AsyncError) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${next.error}')));
      }
    });

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          toolbarHeight: 82,
          elevation: 0,
          leading: const DexHeaderLeading(),
          actions: const DexHeaderActions().getActions(),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50),
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
                            data:
                                (PokemonFirebaseState state) => Text(
                                  '${state.getAlreadyCatchPokemonLength()}/${state.getTotalPokemonLength()} (${(state.getAlreadyCatchPokemonLength() / state.getTotalPokemonLength() * 100).toStringAsFixed(2)}%)',
                                ),
                            error:
                                (Object error, StackTrace stackTrace) =>
                                    Center(child: Text('Error: $error')),
                            loading:
                                () => const Center(
                                  child: CircularProgressIndicator(),
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
                                activeColor: Colors.indigo,
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
                              const Icon(Icons.filter_list_rounded),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
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
                    return pokemon.available && !pokemon.alreadyCatch;
                  } else {
                    return pokemon.available;
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
