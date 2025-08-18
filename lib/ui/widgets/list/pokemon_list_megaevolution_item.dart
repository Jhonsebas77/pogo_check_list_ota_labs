part of com.pogo_check_list_ota_labs.app.widgets;

class PokemonListMegaEvolutionItem extends ConsumerWidget {
  const PokemonListMegaEvolutionItem({
    required this.selectPokemon,
    required this.index,
    this.isShiny = false,
    super.key,
  });

  final PokemonModel selectPokemon;
  final int index;
  final bool? isShiny;

  @override
  Widget build(BuildContext context, WidgetRef ref) => GestureDetector(
    onTap: () async {
      PokemonModel _pokemon = PokemonModel(
        alreadyCatch: !selectPokemon.alreadyCatch,
        alreadyCatchShinyVersion: selectPokemon.alreadyCatchShinyVersion,
        available: selectPokemon.available,
        id: selectPokemon.id,
        name: selectPokemon.name,
        shinyAvailable: selectPokemon.shinyAvailable,
        tradable: selectPokemon.tradable,
      );
      await ref
          .read(firebasePokemonProvider.notifier)
          .updateMegaEvolutionPokemon(index, _pokemon, context);
      if (context.mounted) {
        showSuccessSnackBar(
          context,
          '''[Registro actualizado]\n${paddingDexNumber(dexNumber: selectPokemon.id)} ${selectPokemon.name}''',
        );
      }
    },
    onLongPress: () {
      CustomNavigator().push(
        context,
        DetailsScreen(pokemonId: selectPokemon.id),
      );
    },
    child: DecoratedBox(
      decoration: BoxDecoration(
        color: selectPokemon.alreadyCatch ? Colors.white12 : Colors.black12,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        alignment: AlignmentDirectional.center,
        fit: StackFit.passthrough,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 10),
              Stack(
                children: <Widget>[
                  Image.asset(
                    'assets/bg_holder_pokemon.png',
                    height: 80,
                    width: 80,
                    fit: BoxFit.fill,
                  ),
                  if (selectPokemon.available)
                    Image.asset(
                      'assets/pokedex_mega_evolutions/${selectPokemon.id}.png',
                      height: 80,
                      width: 80,
                      fit: BoxFit.fill,
                    )
                  else
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      enabled: false,
                      child: Image.asset(
                        'assets/pokedex_mega_evolutions/${selectPokemon.id}.png',
                        height: 80,
                        width: 80,
                        fit: BoxFit.fill,
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  FittedBox(
                    child: Text(
                      textAlign: TextAlign.center,
                      selectPokemon.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    paddingDexNumber(dexNumber: selectPokemon.id),
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
          if (selectPokemon.alreadyCatch)
            Positioned(
              top: -7,
              right: -7,
              child: Image.asset(
                'assets/icon_mega.png',
                height: 50,
                width: 50,
                fit: BoxFit.fill,
              ),
            ),
        ],
      ),
    ),
  );
}
