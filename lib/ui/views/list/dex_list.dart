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
    Widget _buildSmallCircle(Color color) => Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        toolbarHeight: 82,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFF5A79C8),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4),
            ),
          ),
        ),
        actions: <Widget>[
          _buildSmallCircle(const Color(0xFFA02C2D)),
          const SizedBox(width: 8),
          _buildSmallCircle(const Color(0xFFDDC35B)),
          const SizedBox(width: 8),
          _buildSmallCircle(const Color(0xFF78B47C)),
        ],
      ),
      backgroundColor: const Color.fromRGBO(198, 73, 52, 1),
      body: firebasePokemonState.when(
        data: (PokemonFirebaseState state) {
          if (state.allPokemon.isEmpty) {
            return const Center(child: Text('No Pokémon found.'));
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
              return PokemonListItem(index: pokemon.id, selectPokemon: pokemon);
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
    );
  }
}
