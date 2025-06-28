part of com.pogo_check_list_ota_labs.app.widgets;

class PokemonListItem extends StatefulWidget {
  const PokemonListItem({
    required this.selectPokemon,
    required this.index,
    required this.displayOnlyMissingPokemon,
    this.isShiny = false,
    super.key,
  });

  final PokemonModel selectPokemon;
  final int index;
  final bool? isShiny;
  final bool displayOnlyMissingPokemon;

  @override
  State<PokemonListItem> createState() => _PokemonListItemState();
}

class _PokemonListItemState extends State<PokemonListItem> {
  bool? _alreadyCatch;
  bool? _alreadyCatchShinyVersion;

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'DISMISS',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

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
  Widget build(BuildContext context) {
    bool isAlreadyCaught =
        (widget.isShiny ?? false)
            ? (_alreadyCatchShinyVersion ?? false)
            : (_alreadyCatch ?? false);
    Color colorPokeball = isAlreadyCaught ? Colors.black : Colors.white;
    return GestureDetector(
      onTap:
          !widget.displayOnlyMissingPokemon
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
                  await firebaseProvider.updatePokemon(widget.index, _pokemon);
                  firebaseProvider.isLoading = false;
                } else {
                  _showErrorSnackBar(
                    context,
                    '''[Error when updatePokemon] -> ${widget.index} != ${widget.selectPokemon.id}''',
                  );
                }
              }
              : null,
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Image.asset(
                        'assets/BG_Holder_Pkmn_B.png',
                        height: 50,
                        width: 50,
                        fit: BoxFit.fill,
                      ),
                      if (widget.isShiny ?? false)
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
                          Image.asset(
                            'assets/pokedex_sprites/${widget.selectPokemon.id}.png',
                            height: 50,
                            width: 50,
                            fit: BoxFit.fill,
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
              Row(
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
                  else
                    Icon(
                      Icons.catching_pokemon,
                      color: colorPokeball,
                      size: 50,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
