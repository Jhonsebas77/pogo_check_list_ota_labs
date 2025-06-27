part of com.pogo_check_list_ota_labs.app.views;

class AllPokemonAvailableView extends StatefulWidget {
  const AllPokemonAvailableView({super.key});
  static const String route = '/pokemon/all-available';

  @override
  State<AllPokemonAvailableView> createState() =>
      _AllPokemonAvailableViewState();
}

class _AllPokemonAvailableViewState extends State<AllPokemonAvailableView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      toolbarHeight: 60,
      title: Stack(
        children: <Widget>[
          SafeArea(
            child: Image.asset(
              'assets/BG_Header.png',
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.fitWidth,
            ),
          ),
          Positioned(
            top: 30,
            left: MediaQuery.of(context).size.width / 5,
            child: const Center(
              child: Text(
                'Pokédex',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ],
      ),
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
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Builder(
                  builder: (BuildContext context) {
                    List<PokemonModel> sortedPokemon =
                        provider.allPokemon
                            .where((PokemonModel pokemon) => pokemon.available)
                            .toList();
                    return Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              const Text(
                                'Mis Pokemones',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.start,
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.catching_pokemon_rounded,
                                ),
                                iconSize: 27,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: sortedPokemon.length,
                            itemBuilder:
                                (BuildContext context, int index) =>
                                    PokemonListItem(
                                      selectPokemon: sortedPokemon[index],
                                      index: index + 1,
                                      displayOnlyMissingPokemon: false,
                                    ),
                          ),
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
  );
}
