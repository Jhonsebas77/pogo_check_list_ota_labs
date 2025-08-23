part of com.pogo_check_list_ota_labs.app.views;

class WantedView extends StatelessWidget {
  const WantedView({super.key});

  @override
  Widget build(BuildContext context) => const Center(
    child: SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          children: <Widget>[
            SizedBox(
              width: 200,
              child: PokemonTradeCard(
                pokemonId: 244,
                pokemonName: 'Entei',
                wantShiny: true,
                wantLucky: true,
              ),
            ),
            SizedBox(
              width: 200,
              child: PokemonTradeCard(
                pokemonId: 245,
                pokemonName: 'Suicune',
                wantShiny: true,
                wantLucky: true,
              ),
            ),
            SizedBox(
              width: 200,
              child: PokemonTradeCard(
                pokemonId: 377,
                pokemonName: 'Regisrock',
                wantShiny: true,
                wantLucky: true,
                wantSpecialBackground: true,
              ),
            ),
            SizedBox(
              width: 200,
              child: PokemonTradeCard(
                pokemonId: 379,
                pokemonName: 'Registeel',
                wantShiny: true,
                wantLucky: true,
              ),
            ),
            SizedBox(
              width: 200,
              child: PokemonTradeCard(
                pokemonId: 380,
                pokemonName: 'Latias',
                wantShiny: true,
                wantLucky: true,
                wantDynamax: true,
              ),
            ),
            SizedBox(
              width: 200,
              child: PokemonTradeCard(
                pokemonId: 485,
                pokemonName: 'Heatran',
                wantShiny: true,
                wantLucky: true,
              ),
            ),
            SizedBox(
              width: 200,
              child: PokemonTradeCard(
                pokemonId: 716,
                pokemonName: 'Xerneas',
                wantShiny: true,
                wantLucky: true,
              ),
            ),
            SizedBox(
              width: 200,
              child: PokemonTradeCard(
                pokemonId: 785,
                pokemonName: 'Tapu Koko',
                wantShiny: true,
                wantLucky: true,
              ),
            ),
            SizedBox(
              width: 200,
              child: PokemonTradeCard(
                pokemonId: 786,
                pokemonName: 'Tapu Lele',
                wantShiny: true,
              ),
            ),
            SizedBox(
              width: 200,
              child: PokemonTradeCard(
                pokemonId: 787,
                pokemonName: 'Tapu Bulu',
                wantShiny: true,
                wantLucky: true,
              ),
            ),
            SizedBox(
              width: 200,
              child: PokemonTradeCard(
                pokemonId: 788,
                pokemonName: 'Tapu Fini',
                wantShiny: true,
                wantLucky: true,
              ),
            ),
            SizedBox(
              width: 200,
              child: PokemonTradeCard(
                pokemonId: 795,
                pokemonName: 'Pheromosa',
                wantShiny: true,
                wantLucky: true,
              ),
            ),
            SizedBox(
              width: 200,
              child: PokemonTradeCard(
                pokemonId: 796,
                pokemonName: 'Xurkitree',
                wantShiny: true,
                wantLucky: true,
              ),
            ),
            SizedBox(
              width: 200,
              child: PokemonTradeCard(
                pokemonId: 798,
                pokemonName: 'Kartana',
                wantShiny: true,
                wantLucky: true,
              ),
            ),

            SizedBox(
              width: 200,
              child: PokemonTradeCard(
                pokemonId: 805,
                pokemonName: 'Stakataka',
                wantShiny: true,
                wantLucky: true,
              ),
            ),
            SizedBox(
              width: 200,
              child: PokemonTradeCard(
                pokemonId: 806,
                pokemonName: 'Blacephalon',
                wantShiny: true,
                wantLucky: true,
              ),
            ),
            SizedBox(
              width: 200,
              child: PokemonTradeCard(
                pokemonId: 894,
                pokemonName: 'Regileki',
                wantShiny: true,
                wantLucky: true,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
