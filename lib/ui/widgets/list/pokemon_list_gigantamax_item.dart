part of com.pogo_check_list_ota_labs.app.widgets;

class PokemonListGigantamaxItem extends ConsumerWidget {
  const PokemonListGigantamaxItem({
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
    onTap:
        selectPokemon.available
            ? () async {
              PokemonModel _pokemon = PokemonModel(
                alreadyCatch: !selectPokemon.alreadyCatch,
                alreadyCatchShinyVersion:
                    selectPokemon.alreadyCatchShinyVersion,
                available: selectPokemon.available,
                id: selectPokemon.id,
                name: selectPokemon.name,
                shinyAvailable: selectPokemon.shinyAvailable,
                tradable: selectPokemon.tradable,
              );
              await ref
                  .read(firebasePokemonProvider.notifier)
                  .updateGigantamaxPokemon(index, _pokemon, context);
              if (context.mounted) {
                showSuccessSnackBar(
                  context,
                  '''[Registro actualizado]\n${paddingDexNumber(dexNumber: selectPokemon.id)} ${selectPokemon.name}''',
                );
              }
            }
            : null,
    onLongPress: () {
      CustomNavigator().push(
        context,
        DetailsScreen(pokemonId: selectPokemon.id),
        animation: CustomNavigationAnimation.fade,
      );
    },
    child: DecoratedBox(
      decoration: BoxDecoration(
        color:
            selectPokemon.alreadyCatch
                ? Theme.of(context).colorScheme.onSurface.withAlpha(100)
                : Theme.of(
                  context,
                ).colorScheme.surfaceContainerHighest.withAlpha(100),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 16),
          Stack(
            children: <Widget>[
              if (selectPokemon.alreadyCatch)
                Image.asset(
                  'assets/gigamax.png',
                  height: 80,
                  width: 80,
                  fit: BoxFit.fill,
                )
              else
                Image.asset(
                  'assets/bg_holder_pokemon.png',
                  height: 80,
                  width: 80,
                  fit: BoxFit.fill,
                ),
              if (selectPokemon.available)
                Image.asset(
                  'assets/pokedex_gigantamax/${selectPokemon.id}.png',
                  height: 80,
                  width: 80,
                  fit: BoxFit.fill,
                )
              else
                Shimmer.fromColors(
                  baseColor: Theme.of(context).colorScheme.onSurfaceVariant,
                  highlightColor:
                      Theme.of(context).colorScheme.onSurfaceVariant,
                  enabled: false,
                  child: Image.asset(
                    'assets/pokedex_gigantamax/${selectPokemon.id}.png',
                    height: 80,
                    width: 80,
                    fit: BoxFit.fill,
                  ),
                ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              FittedBox(
                child: Text(
                  textAlign: TextAlign.center,
                  selectPokemon.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color:
                        selectPokemon.alreadyCatch
                            ? Theme.of(context).colorScheme.surface
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              Text(
                paddingDexNumber(dexNumber: selectPokemon.id),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color:
                      selectPokemon.alreadyCatch
                          ? Theme.of(context).colorScheme.surface
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    ),
  );
}
