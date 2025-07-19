part of com.pogo_check_list_ota_labs.app.widgets;

class PokemonListItem extends ConsumerStatefulWidget {
  const PokemonListItem({
    required this.selectPokemon,
    required this.index,
    this.isShiny = false,
    this.isGigantamax = false,
    super.key,
  });

  final PokemonModel selectPokemon;
  final int index;
  final bool? isShiny;
  final bool? isGigantamax;

  @override
  ConsumerState<PokemonListItem> createState() => _PokemonListItemState();
}

class _PokemonListItemState extends ConsumerState<PokemonListItem> {
  bool? _alreadyCatch;
  bool? _alreadyCatchShinyVersion;

  @override
  Widget build(BuildContext context) {
    bool isAlreadyCaught =
        (widget.isShiny ?? false)
            ? (_alreadyCatchShinyVersion ?? false)
            : (_alreadyCatch ?? false);
    Color colorPokeball = isAlreadyCaught ? Colors.black : Colors.white;

    return GestureDetector(
      onTap: () {
        CustomNavigator().push(context, DetailsScreen(pokemonId: widget.index));
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
                        if (widget.isGigantamax ?? false)
                          Image.asset(
                            'assets/pokedex_gigantamax/${widget.selectPokemon.id}.png',
                            height: 50,
                            width: 50,
                            fit: BoxFit.fill,
                          )
                        else if (widget.isShiny ?? false)
                          if (widget.selectPokemon.shinyAvailable == false)
                            Image.asset(
                              'assets/pokedex_sprites_shiny/0.png',
                              height: 50,
                              width: 50,
                              fit: BoxFit.fill,
                            )
                          else
                            Image.asset(
                              'assets/pokedex_sprites_shiny/${widget.selectPokemon.id}.png',
                              height: 50,
                              width: 50,
                              fit: BoxFit.fill,
                            )
                        else if (!(widget.isShiny ?? false))
                          if (widget.selectPokemon.available == false)
                            Image.asset(
                              'assets/pokedex_sprites_shiny/0.png',
                              height: 50,
                              width: 50,
                              fit: BoxFit.fill,
                            )
                          else
                            Hero(
                              tag: widget.selectPokemon.id,
                              child: Image.asset(
                                'assets/pokedex_sprites/${widget.selectPokemon.id}.png',
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
                          paddingDexNumber(dexNumber: widget.selectPokemon.id),
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          widget.selectPokemon.name,
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
                      widget.selectPokemon.available
                          ? () async {
                            if (widget.index == widget.selectPokemon.id) {
                              setState(() {
                                if (widget.isShiny ?? false) {
                                  _alreadyCatchShinyVersion =
                                      !(_alreadyCatchShinyVersion ?? false);
                                } else {
                                  _alreadyCatch = !(_alreadyCatch ?? false);
                                }
                              });

                              if (context.mounted) {
                                showSuccessSnackBar(
                                  context,
                                  '''[Registro actualizado]\n${paddingDexNumber(dexNumber: widget.selectPokemon.id)} ${widget.selectPokemon.name}''',
                                );
                              }
                            } else {
                              showErrorSnackBar(
                                context,
                                '''[Error actualizando el registro] -> ${widget.index} != ${widget.selectPokemon.id}''',
                              );
                            }
                          }
                          : null,
                  child: Row(
                    children: <Widget>[
                      if (!widget.selectPokemon.tradable)
                        Image.asset(
                          'assets/transfer_blocked.png',
                          height: 50,
                          width: 50,
                          fit: BoxFit.fill,
                        ),
                      if (!widget.selectPokemon.shinyAvailable)
                        Image.asset(
                          'assets/shiny_blocked.png',
                          height: 50,
                          width: 50,
                          fit: BoxFit.fill,
                        ),
                      if (isAlreadyCaught)
                        Image.asset(
                          'assets/catch_pokemon.png',
                          height: 50,
                          width: 50,
                          fit: BoxFit.fill,
                        )
                      else if (widget.selectPokemon.available)
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
