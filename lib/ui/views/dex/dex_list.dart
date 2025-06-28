part of com.pogo_check_list_ota_labs.app.views;

class AllPokemonAvailableView extends StatefulWidget {
  const AllPokemonAvailableView({super.key});
  static const String route = '/pokemon/all-available';

  @override
  State<AllPokemonAvailableView> createState() =>
      _AllPokemonAvailableViewState();
}

class _AllPokemonAvailableViewState extends State<AllPokemonAvailableView> {
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

  final WidgetStateProperty<Icon?> thumbIcon =
      WidgetStateProperty.resolveWith<Icon?>((Set<WidgetState> states) {
        if (states.contains(WidgetState.selected)) {
          return const Icon(Icons.catching_pokemon);
        }
        return const Icon(Icons.catching_pokemon);
      });

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      toolbarHeight: 82,
      title: const HeaderFromImage(title: 'Pokédex'),
      elevation: 0,
    ),
    backgroundColor: const Color.fromRGBO(198, 73, 52, 1),
    body: Consumer<FirebaseProvider>(
      builder: (
        BuildContext context,
        FirebaseProvider provider,
        Widget? child,
      ) {
        if (provider.isLoading) {
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          );
        } else if (provider.allPokemon.isEmpty) {
          return const EmptyState();
        } else {
          List<PokemonModel> sortedPokemon =
              provider.allPokemon.where((PokemonModel pokemon) {
                if (displayOnlyMissingPokemon) {
                  return pokemon.available && !pokemon.alreadyCatch;
                } else {
                  return pokemon.available;
                }
              }).toList();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Builder(
                  builder:
                      (BuildContext context) => Column(
                        children: <Widget>[
                          SizedBox(
                            width: 250,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 4,
                              ),
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      displayOnlyMissingPokemon
                                          ? 'Sin capturar'
                                          : 'Capturados',
                                      style: TextStyle(
                                        color:
                                            displayOnlyMissingPokemon
                                                ? Colors.white
                                                : Colors.black,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Switch(
                                      value: displayOnlyMissingPokemon,
                                      thumbIcon: thumbIcon,
                                      activeColor: Colors.indigo,
                                      onChanged: (_) async {
                                        setState(() {
                                          displayOnlyMissingPokemon =
                                              !displayOnlyMissingPokemon;
                                        });
                                        FirebaseProvider firebaseProvider =
                                            Provider.of<FirebaseProvider>(
                                              context,
                                              listen: false,
                                            );
                                        await firebaseProvider.getPokemonData();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              controller: _scrollController,
                              shrinkWrap: true,
                              itemCount: sortedPokemon.length,
                              itemBuilder:
                                  (BuildContext context, int index) =>
                                      PokemonListItem(
                                        selectPokemon: sortedPokemon[index],
                                        index: index + 1,
                                        displayOnlyMissingPokemon:
                                            displayOnlyMissingPokemon,
                                      ),
                            ),
                          ),
                        ],
                      ),
                ),
              ),
            ],
          );
        }
      },
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
