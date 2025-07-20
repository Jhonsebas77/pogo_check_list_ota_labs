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

  // bool isAlreadyCaught =
  //       (isShiny ?? false)
  //           ? (_alreadyCatchShinyVersion ?? false)
  //           : (_alreadyCatch ?? false);
  //   Color colorPokeball = isAlreadyCaught ? Colors.black : Colors.white;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Color colorPokeball = isAlreadyCaught ? Colors.black : Colors.white;

    return GestureDetector(
      onTap: () {
        CustomNavigator().push(context, DetailsScreen(pokemonId: index));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Container(
          padding: const EdgeInsets.only(
            left: 12,
            top: 8,
            bottom: 8,
            right: 12,
          ),
          decoration: BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.circular(50),
          ),
          child: SizedBox(
            width: 200,
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
                            Image.asset(
                              'assets/pokedex_sprites_shiny/0.png',
                              height: 50,
                              width: 50,
                              fit: BoxFit.fill,
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
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          selectPokemon.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
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
                                        ? !selectPokemon
                                            .alreadyCatchShinyVersion
                                        : selectPokemon
                                            .alreadyCatchShinyVersion,
                                available: selectPokemon.available,
                                id: selectPokemon.id,
                                name: selectPokemon.name,
                                shinyAvailable: selectPokemon.shinyAvailable,
                                tradable: selectPokemon.tradable,
                              );
                              await ref
                                  .read(firebasePokemonProvider.notifier)
                                  .updatePokemon(
                                    _pokemon.id,
                                    _pokemon,
                                    context,
                                  );
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
                        Image.asset(
                          'assets/transfer_blocked.png',
                          height: 50,
                          width: 50,
                          fit: BoxFit.fill,
                        ),
                      if (!selectPokemon.shinyAvailable)
                        Image.asset(
                          'assets/shiny_blocked.png',
                          height: 50,
                          width: 50,
                          fit: BoxFit.fill,
                        ),
                      if (isShiny
                          ? selectPokemon.alreadyCatchShinyVersion
                          : selectPokemon.alreadyCatch)
                        Image.asset(
                          'assets/catch_pokemon.png',
                          height: 50,
                          width: 50,
                          fit: BoxFit.fill,
                        )
                      else if (selectPokemon.available)
                        Icon(
                          Icons.catching_pokemon,
                          color: colorPokeball,
                          size: 50,
                        )
                      else
                        const Icon(
                          Icons.catching_pokemon,
                          color: Colors.blueGrey,
                          size: 50,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
