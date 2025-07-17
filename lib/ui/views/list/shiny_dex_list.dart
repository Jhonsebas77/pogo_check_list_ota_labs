part of com.pogo_check_list_ota_labs.app.views;

class ShinyPokemonView extends StatefulWidget {
  const ShinyPokemonView({super.key});
  static const String route = '/pokemon/shiny-dex';

  @override
  State<ShinyPokemonView> createState() => _ShinyPokemonViewState();
}

class _ShinyPokemonViewState extends State<ShinyPokemonView> {
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
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      toolbarHeight: 82,
      title: const HeaderFromImage(),
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
          return const LoadingWidget();
        } else if (provider.allPokemon.isEmpty) {
          return const EmptyState();
        } else {
          List<PokemonModel> sortedPokemon =
              provider.allPokemon.where((PokemonModel pokemon) {
                if (displayOnlyMissingPokemon) {
                  return pokemon.shinyAvailable &&
                      !pokemon.alreadyCatchShinyVersion;
                } else {
                  return pokemon.shinyAvailable;
                }
              }).toList();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Builder(
                  builder: (BuildContext context) {
                    List<PokemonModel> _allPokemon =
                        provider.allPokemon
                            .where(
                              (PokemonModel pokemon) => pokemon.shinyAvailable,
                            )
                            .toList();
                    List<PokemonModel> _catchPokemon =
                        provider.allPokemon
                            .where(
                              (PokemonModel pokemon) =>
                                  pokemon.alreadyCatchShinyVersion,
                            )
                            .toList();
                    return Column(
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
                                    'Shiny Pokédex',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    '${_catchPokemon.length}/${_allPokemon.length} (${(_catchPokemon.length / _allPokemon.length * 100).toStringAsFixed(2)}%)',
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
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
                                          FirebaseProvider firebaseProvider =
                                              Provider.of<FirebaseProvider>(
                                                context,
                                                listen: false,
                                              );
                                          await firebaseProvider.getPokemonData(
                                            context,
                                          );
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
                        PokemonList(
                          scrollController: _scrollController,
                          sortedPokemon: sortedPokemon,
                          isShiny: true,
                        ),
                      ],
                    );
                  },
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
