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
    onTap:
        selectPokemon.available
            ? () async {
              PokemonModel _pokemon = selectPokemon.copyWith(
                alreadyCatch: !selectPokemon.alreadyCatch,
              );
              if (selectPokemon.isAlternativeForm) {
                await ref
                    .read(firebasePokemonProvider.notifier)
                    .updateMegaEvolutionPokemonForm(
                      _pokemon.id,
                      _pokemon,
                      context,
                    );
              } else {
                await ref
                    .read(firebasePokemonProvider.notifier)
                    .updateMegaEvolutionPokemon(index, _pokemon, context);
              }
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
                      'assets/pokedex_mega_evolutions/'
                      '${selectPokemon.id}${selectPokemon.formSuffix}.png',
                      height: 80,
                      width: 80,
                      fit: BoxFit.fill,
                      errorBuilder:
                          (
                            BuildContext context,
                            Object error,
                            StackTrace? stackTrace,
                          ) => Image.asset(
                            'assets/pokedex_mega_evolutions/'
                            '${selectPokemon.id}.png',
                            height: 80,
                            width: 80,
                            fit: BoxFit.fill,
                          ),
                    )
                  else
                    Shimmer.fromColors(
                      baseColor: Theme.of(context).colorScheme.onSurfaceVariant,
                      highlightColor:
                          Theme.of(context).colorScheme.onSurfaceVariant,
                      enabled: false,
                      child: Image.asset(
                        'assets/pokedex_mega_evolutions/'
                        '${selectPokemon.id}${selectPokemon.formSuffix}.png',
                        height: 80,
                        width: 80,
                        fit: BoxFit.fill,
                        errorBuilder:
                            (
                              BuildContext context,
                              Object error,
                              StackTrace? stackTrace,
                            ) => Image.asset(
                              'assets/pokedex_mega_evolutions/'
                              '${selectPokemon.id}.png',
                              height: 80,
                              width: 80,
                              fit: BoxFit.fill,
                            ),
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
                      selectPokemon.isAlternativeForm
                          ? '${selectPokemon.name} '
                              '(${selectPokemon.formTag!.name})'
                          : selectPokemon.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color:
                            selectPokemon.alreadyCatch
                                ? Theme.of(context).colorScheme.surface
                                : Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
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
