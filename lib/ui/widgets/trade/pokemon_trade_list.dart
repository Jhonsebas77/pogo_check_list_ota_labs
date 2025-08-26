part of com.pogo_check_list_ota_labs.app.widgets;

class PokemonTradeList extends StatelessWidget {
  const PokemonTradeList({required this.pokemonList, super.key});

  final List<PokemonTradeItem> pokemonList;
  @override
  Widget build(BuildContext context) => Center(
    child: SingleChildScrollView(
      primary: false,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          children: List<Widget>.generate(
            pokemonList.length,
            (int index) => PokemonTradeCard(
              pokemonId: pokemonList[index].id,
              pokemonName: pokemonList[index].name,
              alreadyCaught: pokemonList[index].alreadyCaught,
              quantity: pokemonList[index].quantity ?? 1,
              wantAdventureEffect: pokemonList[index].haveAdventureEffect,
              wantDynamax: pokemonList[index].isDynamax,
              wantGigantamax: pokemonList[index].isGigantamax,
              wantLucky: pokemonList[index].isLucky,
              wantMirrorChange: pokemonList[index].isMirrorChange,
              wantShiny: pokemonList[index].isShiny,
              wantSpecialBackground: pokemonList[index].haveSpecialBackground,
            ),
          ),
        ),
      ),
    ),
  );
}
