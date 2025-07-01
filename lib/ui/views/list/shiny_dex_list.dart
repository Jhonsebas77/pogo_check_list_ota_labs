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
      title: const HeaderFromImage(title: 'Shiny'),
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
                                        await firebaseProvider.getPokemonData(
                                          context,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          PokemonList(
                            scrollController: _scrollController,
                            sortedPokemon: sortedPokemon,
                            isShiny: true,
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
