part of com.pogo_check_list_ota_labs.app.widgets;

class PokemonList extends StatelessWidget {
  const PokemonList({
    required ScrollController scrollController,
    required this.sortedPokemon,
    this.isShiny = false,
    this.isGigantamax = false,
    super.key,
  }) : _scrollController = scrollController;

  final ScrollController _scrollController;
  final List<PokemonModel> sortedPokemon;
  final bool? isShiny;
  final bool? isGigantamax;

  @override
  Widget build(BuildContext context) => Expanded(
    child: ListView.builder(
      controller: _scrollController,
      shrinkWrap: true,
      itemCount: sortedPokemon.length,
      itemBuilder:
          (BuildContext context, int index) => PokemonListItem(
            selectPokemon: sortedPokemon[index],
            index: sortedPokemon[index].id,
            isShiny: isShiny!,
            isGigantamax: isGigantamax!,
          ),
    ),
  );
}
