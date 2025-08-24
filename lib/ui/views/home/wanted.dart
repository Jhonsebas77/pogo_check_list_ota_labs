part of com.pogo_check_list_ota_labs.app.views;

class WantedView extends StatelessWidget {
  const WantedView({super.key});

  @override
  Widget build(BuildContext context) => DefaultTabController(
    length: 2,
    child: Scaffold(
      backgroundColor: const Color.fromRGBO(198, 73, 52, 1),
      appBar: AppBar(
        foregroundColor: const Color.fromRGBO(198, 73, 52, 1),
        backgroundColor: const Color.fromRGBO(198, 73, 52, 1),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(19),
          child: TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            labelStyle: TextStyle(color: Colors.white, fontSize: 18),
            tabs: <Widget>[
              Tab(icon: Icon(Icons.wifi_protected_setup_sharp), text: 'Quiero'),
              Tab(icon: Icon(Icons.catching_pokemon), text: 'Ofreciendo'),
            ],
          ),
        ),
      ),
      body: const TabBarView(
        children: <Widget>[WantedPokemon(), OfferPokemon()],
      ),
    ),
  );
}

class OfferPokemon extends StatelessWidget {
  const OfferPokemon({super.key});

  @override
  Widget build(BuildContext context) => const Center(
    child: SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          children: <Widget>[
            PokemonTradeCard(
              pokemonId: 1,
              pokemonName: 'Bulbasaur',
              wantShiny: true,
              wantMirrorChange: true,
              alreadyCaught: true,
              wantDynamax: true,
            ),
            PokemonTradeCard(
              pokemonId: 4,
              pokemonName: 'Charmander',
              wantShiny: true,
              wantMirrorChange: true,
              alreadyCaught: true,
              wantDynamax: true,
            ),
            PokemonTradeCard(
              pokemonId: 6,
              pokemonName: 'Charizard',
              wantShiny: true,
              wantMirrorChange: true,
              alreadyCaught: true,
              wantGigantamax: true,
            ),
            PokemonTradeCard(
              pokemonId: 66,
              pokemonName: 'Machop',
              wantShiny: true,
              wantMirrorChange: true,
              alreadyCaught: true,
              wantDynamax: true,
            ),
            PokemonTradeCard(
              pokemonId: 131,
              pokemonName: 'Lapras',
              wantShiny: true,
              wantMirrorChange: true,
              alreadyCaught: true,
              wantGigantamax: true,
            ),
            PokemonTradeCard(
              pokemonId: 143,
              pokemonName: 'Snorlax',
              wantShiny: true,
              wantMirrorChange: true,
              alreadyCaught: true,
              wantGigantamax: true,
            ),
            PokemonTradeCard(
              pokemonId: 529,
              pokemonName: 'Drilbur',
              wantShiny: true,
              wantMirrorChange: true,
              alreadyCaught: true,
              wantDynamax: true,
            ),
            PokemonTradeCard(
              pokemonId: 150,
              pokemonName: 'Mewtwo',
              wantShiny: true,
              wantMirrorChange: true,
              alreadyCaught: true,
            ),
            PokemonTradeCard(
              pokemonId: 249,
              pokemonName: 'Lugia',
              wantShiny: true,
              alreadyCaught: true,
              quantity: 2,
            ),
            PokemonTradeCard(
              pokemonId: 381,
              pokemonName: 'Latios',
              wantShiny: true,
              wantMirrorChange: true,
              alreadyCaught: true,
            ),
            PokemonTradeCard(
              pokemonId: 382,
              pokemonName: 'Kyogre',
              wantShiny: true,
              alreadyCaught: true,
            ),
            PokemonTradeCard(
              pokemonId: 382,
              pokemonName: 'Kyogre',
              wantShiny: true,
              wantMirrorChange: true,
              alreadyCaught: true,
            ),
            PokemonTradeCard(
              pokemonId: 383,
              pokemonName: 'Groudon',
              wantShiny: true,
              wantMirrorChange: true,
              alreadyCaught: true,
            ),
            PokemonTradeCard(
              pokemonId: 484,
              pokemonName: 'Palkia',
              wantShiny: true,
              wantMirrorChange: true,
              alreadyCaught: true,
            ),
            PokemonTradeCard(
              pokemonId: 484,
              pokemonName: 'Palkia - Origen',
              wantShiny: true,
              alreadyCaught: true,
              quantity: 2,
            ),
            PokemonTradeCard(
              pokemonId: 554,
              pokemonName: 'Darumaka',
              wantShiny: true,
              wantMirrorChange: true,
              alreadyCaught: true,
              wantDynamax: true,
            ),
            PokemonTradeCard(
              pokemonId: 643,
              pokemonName: 'Reshiram',
              wantShiny: true,
              wantMirrorChange: true,
              alreadyCaught: true,
            ),
            PokemonTradeCard(
              pokemonId: 644,
              pokemonName: 'Reshiram',
              wantShiny: true,
              wantMirrorChange: true,
              alreadyCaught: true,
            ),
            PokemonTradeCard(
              pokemonId: 646,
              pokemonName: 'Kyurem',
              wantShiny: true,
              wantSpecialBackground: true,
              alreadyCaught: true,
            ),
            PokemonTradeCard(
              pokemonId: 888,
              pokemonName: 'Zacian',
              wantShiny: true,
              alreadyCaught: true,
            ),
            PokemonTradeCard(
              pokemonId: 889,
              pokemonName: 'Zamazenta',
              wantShiny: true,
              alreadyCaught: true,
            ),
            PokemonTradeCard(
              pokemonId: 895,
              pokemonName: 'Regidrago',
              wantShiny: true,
              wantMirrorChange: true,
              alreadyCaught: true,
            ),
          ],
        ),
      ),
    ),
  );
}

class WantedPokemon extends StatelessWidget {
  const WantedPokemon({super.key});

  @override
  Widget build(BuildContext context) => const Center(
    child: SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          children: <Widget>[
            PokemonTradeCard(
              pokemonId: 244,
              pokemonName: 'Entei',
              wantShiny: true,
              wantLucky: true,
            ),
            PokemonTradeCard(
              pokemonId: 245,
              pokemonName: 'Suicune',
              wantShiny: true,
              wantLucky: true,
            ),
            PokemonTradeCard(
              pokemonId: 377,
              pokemonName: 'Regisrock',
              wantShiny: true,
              wantLucky: true,
              wantSpecialBackground: true,
            ),
            PokemonTradeCard(
              pokemonId: 379,
              pokemonName: 'Registeel',
              wantShiny: true,
              wantLucky: true,
            ),
            PokemonTradeCard(
              pokemonId: 380,
              pokemonName: 'Latias',
              wantShiny: true,
              wantLucky: true,
              wantDynamax: true,
            ),
            PokemonTradeCard(
              pokemonId: 485,
              pokemonName: 'Heatran',
              wantShiny: true,
              wantLucky: true,
            ),
            PokemonTradeCard(
              pokemonId: 716,
              pokemonName: 'Xerneas',
              wantShiny: true,
              wantLucky: true,
            ),
            PokemonTradeCard(
              pokemonId: 785,
              pokemonName: 'Tapu Koko',
              wantShiny: true,
              wantLucky: true,
            ),
            PokemonTradeCard(
              pokemonId: 786,
              pokemonName: 'Tapu Lele',
              wantShiny: true,
            ),
            PokemonTradeCard(
              pokemonId: 787,
              pokemonName: 'Tapu Bulu',
              wantShiny: true,
              wantLucky: true,
            ),
            PokemonTradeCard(
              pokemonId: 788,
              pokemonName: 'Tapu Fini',
              wantShiny: true,
              wantLucky: true,
            ),
            PokemonTradeCard(
              pokemonId: 795,
              pokemonName: 'Pheromosa',
              wantShiny: true,
              wantLucky: true,
            ),
            PokemonTradeCard(
              pokemonId: 796,
              pokemonName: 'Xurkitree',
              wantShiny: true,
              wantLucky: true,
            ),
            PokemonTradeCard(
              pokemonId: 798,
              pokemonName: 'Kartana',
              wantShiny: true,
              wantLucky: true,
            ),
            PokemonTradeCard(
              pokemonId: 805,
              pokemonName: 'Stakataka',
              wantShiny: true,
              wantLucky: true,
            ),
            PokemonTradeCard(
              pokemonId: 806,
              pokemonName: 'Blacephalon',
              wantShiny: true,
              wantLucky: true,
            ),
          ],
        ),
      ),
    ),
  );
}
