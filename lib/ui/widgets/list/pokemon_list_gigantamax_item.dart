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
  @override
  Widget build(BuildContext context) => Padding(
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
  );
}
