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
          return GridView.count(
            crossAxisCount: 3,
            children: List<PokemonListGigantamaxItem>.generate(
              sortedPokemon.length,
              (int index) => PokemonListGigantamaxItem(
                index: index,
                selectPokemon: sortedPokemon[index],
                isGigantamax: true,
              ),
            ),
          );
        }
      },
    ),
  );
}
