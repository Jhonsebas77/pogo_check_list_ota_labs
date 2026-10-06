part of com.pogo_check_list_ota_labs.app.views;

class DetailsScreen extends ConsumerStatefulWidget {
  const DetailsScreen({required this.pokemonId, super.key});
  static const String route = '/pokemon/details';
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
        appBar: pokemonAsyncValue.when(
          loading: () => const CustomAppBar(isLoading: true),
          error:
              (Object error, StackTrace stackTrace) =>
                  CustomAppBar(title: '${widget.pokemonId}'),

          data: (PokemonDetail pokemon) => CustomAppBar(title: pokemon.name),
        ),
        body: WebContent(
          child: pokemonAsyncValue.when(
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
                (PokemonDetail pokemon) => SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Center(
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            Image.asset(
                              'assets/bg_holder_pokemon.png',
                              height: 180,
                              width: 180,
                              fit: BoxFit.fill,
                            ),
                            Hero(
                              tag: pokemon.id,
                              child: Image.network(
                                pokemon.imageUrl,
                                height: 180,
                                width: 180,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '#${pokemon.id.toString().padLeft(3, '0')}',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 12,
                        runSpacing: 12,
                        children:
                            pokemon.types
                                .map(
                                  (String type) => TypeImageBadge(type: type),
                                )
                                .toList(),
                      ),
                    ],
                  ),
                ),
          ),
        ),
      ),
    );
  }
}
