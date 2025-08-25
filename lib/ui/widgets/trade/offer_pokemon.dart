part of com.pogo_check_list_ota_labs.app.widgets;

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
              pokemonName: 'Origen',
              wantShiny: true,
              alreadyCaught: true,
              quantity: 2,
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
