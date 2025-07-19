part of com.pogo_check_list_ota_labs.app.widgets;

class PokemonListGigantamaxItem extends StatefulWidget {
  const PokemonListGigantamaxItem({
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
  State<PokemonListGigantamaxItem> createState() =>
      _PokemonListGigantamaxItemState();
}

class _PokemonListGigantamaxItemState extends State<PokemonListGigantamaxItem> {
  bool? _alreadyCatch;
  bool? _alreadyCatchShinyVersion;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.isShiny ?? false) {
        _alreadyCatchShinyVersion =
            widget.selectPokemon.alreadyCatchShinyVersion;
      } else {
        _alreadyCatch = widget.selectPokemon.alreadyCatch;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
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
                FirebaseProvider firebaseProvider =
                    Provider.of<FirebaseProvider>(context, listen: false)
                      ..isLoading = true;
                PokemonModel _pokemon = PokemonModel(
                  alreadyCatch:
                      (widget.isShiny ?? false)
                          ? widget.selectPokemon.alreadyCatch
                          : _alreadyCatch ?? false,
                  alreadyCatchShinyVersion:
                      (widget.isShiny ?? false)
                          ? _alreadyCatchShinyVersion ?? false
                          : widget.selectPokemon.alreadyCatchShinyVersion,
                  available: widget.selectPokemon.available,
                  id: widget.selectPokemon.id,
                  name: widget.selectPokemon.name,
                  shinyAvailable: widget.selectPokemon.shinyAvailable,
                  tradable: widget.selectPokemon.tradable,
                );
                if (widget.isGigantamax ?? false) {
                  await firebaseProvider.updateGigantamaxPokemon(
                    context,
                    widget.index,
                    _pokemon,
                  );
                } else {
                  await firebaseProvider.updatePokemon(
                    context,
                    widget.index,
                    _pokemon,
                  );
                }
                if (context.mounted) {
                  showSuccessSnackBar(
                    context,
                    '''[Registro actualizado]\n${paddingDexNumber(dexNumber: widget.selectPokemon.id)} ${widget.selectPokemon.name}''',
                  );
                }
                firebaseProvider.isLoading = false;
              } else {
                showErrorSnackBar(
                  context,
                  '''[Error actualizando el registro] -> ${widget.index} != ${widget.selectPokemon.id}''',
                );
              }
            }
            : null,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Container(
        padding: const EdgeInsets.only(left: 12, top: 8, bottom: 8, right: 12),
        decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Image.asset(
                  'assets/bg_holder_pokemon.png',
                  height: 80,
                  width: 80,
                  fit: BoxFit.fill,
                ),
                if (widget.isGigantamax ?? false)
                  Image.asset(
                    'assets/pokedex_gigantamax/${widget.selectPokemon.id}.png',
                    height: 80,
                    width: 80,
                    fit: BoxFit.fill,
                  )
                else if (widget.isShiny ?? false)
                  if (widget.selectPokemon.shinyAvailable == false)
                    Image.asset(
                      'assets/pokedex_sprites_shiny/0.png',
                      height: 80,
                      width: 80,
                      fit: BoxFit.fill,
                    )
                  else
                    Image.asset(
                      'assets/pokedex_sprites_shiny/${widget.selectPokemon.id}.png',
                      height: 80,
                      width: 80,
                      fit: BoxFit.fill,
                    )
                else if (!(widget.isShiny ?? false))
                  if (widget.selectPokemon.available == false)
                    Image.asset(
                      'assets/pokedex_sprites_shiny/0.png',
                      height: 80,
                      width: 80,
                      fit: BoxFit.fill,
                    )
                  else
                    Image.asset(
                      'assets/pokedex_sprites/${widget.selectPokemon.id}.png',
                      height: 80,
                      width: 80,
                      fit: BoxFit.fill,
                    ),
              ],
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  widget.selectPokemon.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  paddingDexNumber(dexNumber: widget.selectPokemon.id),
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            // TODO(Sebastian): Add catch and shiny values
          ],
        ),
      ),
    ),
  );
}
