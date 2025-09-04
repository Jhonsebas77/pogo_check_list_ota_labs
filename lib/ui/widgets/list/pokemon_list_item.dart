part of com.pogo_check_list_ota_labs.app.widgets;

class PokemonListItem extends ConsumerWidget {
  const PokemonListItem({
    required this.selectPokemon,
    required this.index,
    this.isShiny = false,
    this.isAlreadyCaught = false,
    this.isGigantamax = false,
    super.key,
  });

  final bool isGigantamax;
  final PokemonModel selectPokemon;
  final int index;
  final bool isShiny;
  final bool isAlreadyCaught;

  @override
  Widget build(BuildContext context, WidgetRef ref) => GestureDetector(
    onTap: () {
      CustomNavigator().push(context, DetailsScreen(pokemonId: index));
    },
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.only(left: 12, top: 8, bottom: 8, right: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Image.asset(
                      'assets/bg_holder_pokemon.png',
                      height: 50,
                      width: 50,
                      fit: BoxFit.fill,
                    ),
                    if (isGigantamax)
                      Image.asset(
                        'assets/pokedex_gigantamax/${selectPokemon.id}.png',
                        height: 50,
                        width: 50,
                        fit: BoxFit.fill,
                      )
                    else if (isShiny)
                      if (selectPokemon.shinyAvailable == false)
                        Image.asset(
                          'assets/pokedex_sprites_shiny/0.png',
                          height: 50,
                          width: 50,
                          fit: BoxFit.fill,
                        )
                      else
                        Image.asset(
                          'assets/pokedex_sprites_shiny/${selectPokemon.id}.png',
                          height: 50,
                          width: 50,
                          fit: BoxFit.fill,
                        )
                    else if (!isShiny)
                      if (selectPokemon.available == false)
                        Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Image.asset(
                            'assets/pokedex_sprites/${selectPokemon.id}.png',
                            height: 50,
                            width: 50,
                            fit: BoxFit.fill,
                          ),
                        )
                      else
                        Hero(
                          tag: selectPokemon.id,
                          child: Image.asset(
                            'assets/pokedex_sprites/${selectPokemon.id}.png',
                            height: 50,
                            width: 50,
                            fit: BoxFit.fill,
                          ),
                        ),
                  ],
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      paddingDexNumber(dexNumber: selectPokemon.id),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      selectPokemon.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (selectPokemon.available)
              GestureDetector(
                onTap:
                    selectPokemon.available
                        ? () async {
                          if (index == selectPokemon.id) {
                            PokemonModel _pokemon = PokemonModel(
                              alreadyCatch:
                                  isShiny
                                      ? selectPokemon.alreadyCatch
                                      : !selectPokemon.alreadyCatch,
                              alreadyCatchShinyVersion:
                                  isShiny
                                      ? !selectPokemon.alreadyCatchShinyVersion
                                      : selectPokemon.alreadyCatchShinyVersion,
                              available: selectPokemon.available,
                              id: selectPokemon.id,
                              name: selectPokemon.name,
                              shinyAvailable: selectPokemon.shinyAvailable,
                              tradable: selectPokemon.tradable,
                            );
                            await ref
                                .read(firebasePokemonProvider.notifier)
                                .updatePokemon(_pokemon.id, _pokemon, context);
                            if (context.mounted) {
                              showSuccessSnackBar(
                                context,
                                '''[Registro actualizado]\n${paddingDexNumber(dexNumber: selectPokemon.id)} ${selectPokemon.name}''',
                              );
                            }
                          } else {
                            showErrorSnackBar(
                              context,
                              '''[Error actualizando el registro] -> $index != ${selectPokemon.id}''',
                            );
                          }
                        }
                        : null,
                child: Row(
                  children: <Widget>[
                    if (!selectPokemon.tradable)
                      const Stack(
                        children: <Widget>[
                          CircleAvatar(
                            backgroundColor: Color(0xFFA0E1FF),
                            child: Icon(
                              Icons.wifi_protected_setup_sharp,
                              color: Colors.white,
                            ),
                          ),
                          Icon(Icons.block, color: Colors.red, size: 40),
                        ],
                      ),
                    if (!selectPokemon.shinyAvailable)
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Stack(
                          children: <Widget>[
                            Image.asset(
                              'assets/icon_shiny.png',
                              height: 40,
                              width: 40,
                            ),
                            const Icon(
                              Icons.block,
                              color: Colors.red,
                              size: 40,
                            ),
                          ],
                        ),
                      ),
                    if (isShiny
                        ? selectPokemon.alreadyCatchShinyVersion
                        : selectPokemon.alreadyCatch)
                      Stack(
                        alignment: AlignmentDirectional.topEnd,
                        children: <Widget>[
                          Icon(
                            Icons.catching_pokemon,
                            color: Theme.of(context).colorScheme.inverseSurface,
                            size: 50,
                          ),
                          const Icon(
                            Icons.check_circle,
                            color: Colors.lightGreen,
                            size: 30,
                          ),
                        ],
                      )
                    else if (selectPokemon.available)
                      Icon(
                        Icons.catching_pokemon,
                        color: Theme.of(context).colorScheme.inverseSurface,
                        size: 50,
                      ),
                  ],
                ),
              )
            else
              const Stack(
                alignment: AlignmentDirectional.topEnd,
                children: <Widget>[
                  Icon(
                    Icons.catching_pokemon,
                    color: Colors.blueGrey,
                    size: 50,
                  ),
                  Icon(Icons.block, color: Colors.red, size: 30),
                ],
              ),
          ],
        ),
      ),
    ),
  );
}
