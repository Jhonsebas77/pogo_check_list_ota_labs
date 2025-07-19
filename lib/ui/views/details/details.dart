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
    Widget _buildSmallCircle(Color color) => Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        elevation: 0,
        // title: const HeaderFromImage(),
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: GestureDetector(
            onTap: () {
              if (CustomNavigator().canPop(context)) {
                CustomNavigator().pop(context);
              }
            },
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFF5A79C8),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 4),
              ),
              child:
                  CustomNavigator().canPop(context)
                      ? const Icon(Icons.arrow_back_ios)
                      : null,
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
        toolbarHeight: 82,
      ),
      backgroundColor: const Color.fromRGBO(198, 73, 52, 1),

      body: pokemonAsyncValue.when(
        // State 1: The Future is loading
        loading: () => const CircularProgressIndicator(),

        // State 2: The Future completed with an error
        error: (Object error, StackTrace stackTrace) => Text('Error: $error'),

        // State 3: The Future completed successfully with data
        data:
            (PokemonDetail pokemon) => Center(
              child: Column(
                children: <Widget>[
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
                  Text('Hola Mundo ${pokemon.name}'),

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
    );
  }
}
