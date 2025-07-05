part of com.pogo_check_list_ota_labs.app.views;

class GigantamaxPokemonView extends StatefulWidget {
  const GigantamaxPokemonView({super.key});
  static const String route = '/pokemon/gigantamax-dex';

  @override
  State<GigantamaxPokemonView> createState() => _GigantamaxPokemonViewState();
}

class _GigantamaxPokemonViewState extends State<GigantamaxPokemonView> {
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
      title: const HeaderFromImage(title: 'Gigantamax'),
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
        } else if (provider.allGigantamaxPokemon.isEmpty) {
          return const EmptyState();
        } else {
          List<PokemonModel> sortedPokemon =
              provider.allGigantamaxPokemon.where((PokemonModel pokemon) {
                  if (displayOnlyMissingPokemon) {
                    return !pokemon.alreadyCatch;
                  } else {
                    return pokemon.id != 0;
                  }
                }).toList()
                ..sort(
                  (PokemonModel a, PokemonModel b) => a.id.compareTo(b.id),
                );
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Builder(
                  builder:
                      (BuildContext context) => Column(
                        children: <Widget>[
                          PokemonList(
                            scrollController: _scrollController,
                            sortedPokemon: sortedPokemon,
                            isGigantamax: true,
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
