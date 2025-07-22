part of com.pogo_check_list_ota_labs.app.widgets;

class PokemonListMegaEvolutionItem extends StatefulWidget {
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
  State<PokemonListMegaEvolutionItem> createState() =>
      _PokemonListMegaEvolutionItemState();
}

class _PokemonListMegaEvolutionItemState
    extends State<PokemonListMegaEvolutionItem> {
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
              if (widget.selectPokemon.available)
                Image.asset(
                  'assets/pokedex_mega_evolutions/${widget.selectPokemon.id}.png',
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
                    'assets/pokedex_mega_evolutions/${widget.selectPokemon.id}.png',
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
