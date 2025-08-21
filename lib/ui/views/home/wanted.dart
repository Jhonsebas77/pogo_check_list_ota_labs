part of com.pogo_check_list_ota_labs.app.views;

class WantedView extends StatelessWidget {
  const WantedView({super.key});

  @override
  Widget build(BuildContext context) => const SingleChildScrollView(
    child: Padding(
      padding: EdgeInsets.all(8),
      child: Column(
        children: <Widget>[
          SizedBox(
            width: 200,
            child: PokemonTradeCard(pokemonId: 244, pokemonName: 'Entei'),
          ),
          SizedBox(height: 4),
          PokemonTradeCard(pokemonId: 245, pokemonName: 'Suicune'),
          SizedBox(height: 4),
          PokemonTradeCard(pokemonId: 377, pokemonName: 'Regisrock'),
          SizedBox(height: 4),
          PokemonTradeCard(pokemonId: 379, pokemonName: 'Registeel'),
          SizedBox(height: 4),
          PokemonTradeCard(pokemonId: 380, pokemonName: 'Latias'),
          SizedBox(height: 4),
          PokemonTradeCard(pokemonId: 485, pokemonName: 'Heatran'),
          SizedBox(height: 4),
          PokemonTradeCard(pokemonId: 716, pokemonName: 'Xerneas'),
          SizedBox(height: 4),
          PokemonTradeCard(pokemonId: 785, pokemonName: 'Tapu Koko'),
          SizedBox(height: 4),
          PokemonTradeCard(pokemonId: 786, pokemonName: 'Tapu Lele'),
          SizedBox(height: 4),
          PokemonTradeCard(pokemonId: 787, pokemonName: 'Tapu Bulu'),
          SizedBox(height: 4),
          PokemonTradeCard(pokemonId: 788, pokemonName: 'Tapu Fini'),
          SizedBox(height: 4),
          PokemonTradeCard(pokemonId: 795, pokemonName: 'Pheromosa'),
          SizedBox(height: 4),
          PokemonTradeCard(pokemonId: 796, pokemonName: 'Xurkitree'),
          SizedBox(height: 4),
          PokemonTradeCard(pokemonId: 798, pokemonName: 'Kartana'),
          SizedBox(height: 4),
          PokemonTradeCard(pokemonId: 805, pokemonName: 'Stakataka'),
          SizedBox(height: 4),
          PokemonTradeCard(pokemonId: 806, pokemonName: 'Blacephalon'),
          SizedBox(height: 4),
          PokemonTradeCard(pokemonId: 894, pokemonName: 'Regileki'),
          SizedBox(height: 4),
        ],
      ),
    ),
  );
}
