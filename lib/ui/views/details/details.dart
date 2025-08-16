part of com.pogo_check_list_ota_labs.app.views;

class DetailsScreen extends ConsumerStatefulWidget {
  const DetailsScreen({required this.pokemonId, super.key});
  final int pokemonId;

  @override
  ConsumerState<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends ConsumerState<DetailsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AsyncValue<PokemonDetail> pokemonAsyncValue = ref.watch(
      pokemonProvider('${widget.pokemonId}'),
    );

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          elevation: 0,
          toolbarHeight: 82,
          leading: const DexHeaderLeading(),
          actions: const DexHeaderActions().getActions(),
        ),
        backgroundColor: const Color.fromRGBO(198, 73, 52, 1),

        body: pokemonAsyncValue.when(
          // State 1: The Future is loading
          loading: () => const Center(child: CircularProgressIndicator()),

          // State 2: The Future completed with an error
          error:
              (Object error, StackTrace stackTrace) => SimpleErrorChip(
                iconData: Icons.catching_pokemon,
                error: error.toString(),
                stackTrace: stackTrace,
                text: 'Con el detalle del Pokémon ${widget.pokemonId}',
              ),

          // State 3: The Future completed successfully with data
          data:
              (PokemonDetail pokemon) => Center(
                child: Column(
                  children: <Widget>[
                    Text(
                      pokemon.name,
                      style: const TextStyle(fontSize: 24, color: Colors.white),
                    ),
                    Stack(
                      children: <Widget>[
                        Image.asset(
                          'assets/bg_holder_pokemon.png',
                          height: 120,
                          width: 120,
                          fit: BoxFit.fill,
                        ),
                        Hero(
                          tag: pokemon.id,
                          // child: Image.asset(
                          //   'assets/pokedex_sprites/${pokemon.id}.png',
                          //   height: 120,
                          //   width: 120,
                          //   fit: BoxFit.fill,
                          // ),
                          child: Image.network(
                            pokemon.imageUrl,
                            height: 120,
                            width: 120,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ],
                    ),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children:
                          pokemon.types
                              .map(
                                (String type) =>
                                    Chip(label: Text(type.toUpperCase())),
                              )
                              .toList(),
                    ),
                  ],
                ),
              ),
        ),
      ),
    );
  }
}
