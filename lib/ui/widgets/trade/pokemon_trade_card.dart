part of com.pogo_check_list_ota_labs.app.widgets;

class PokemonTradeCard extends StatelessWidget {
  const PokemonTradeCard({
    required this.pokemonId,
    required this.pokemonName,
    this.wantShiny = false,
    this.wantSpecialBackground = false,
    this.wantAdventureEffect = false,
    this.wantDynamax = false,
    this.wantGigantamax = false,
    this.wantLucky = false,
    this.alreadyCaught = false,
    super.key,
  });

  final int pokemonId;
  final String pokemonName;
  final bool? wantShiny;
  final bool? wantSpecialBackground;
  final bool? wantAdventureEffect;
  final bool? wantDynamax;
  final bool? wantGigantamax;
  final bool? wantLucky;
  final bool? alreadyCaught;

  String get _dex => paddingDexNumber(dexNumber: pokemonId).substring(1);

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      gradient: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: <Color>[Color(0xFFE5F6FF), Color(0xFFA0E1FF)],
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Image.asset(
                    'assets/bg_holder_pokemon.png',
                    height: 80,
                    width: 80,
                    fit: BoxFit.fill,
                  ),
                  if (wantShiny ?? false)
                    Image.asset(
                      'assets/pokedex_sprites_shiny/$pokemonId.png',
                      height: 80,
                      width: 80,
                    )
                  else
                    Image.asset(
                      'assets/pokedex_sprites/$pokemonId.png',
                      height: 80,
                      width: 80,
                    ),
                ],
              ),
              const SizedBox(width: 8),
              const SizedBox(height: 8),
              Expanded(
                child: Center(
                  child: Wrap(
                    spacing: 2,
                    runSpacing: 4,
                    children: <Widget>[
                      if (wantShiny ?? false)
                        Image.asset(
                          'assets/icon_shiny.png',
                          height: 40,
                          width: 40,
                        ),
                      if (wantSpecialBackground ?? false)
                        Image.asset(
                          'assets/icon_special_background.png',
                          height: 40,
                          width: 40,
                        ),
                      if (wantDynamax ?? false)
                        Image.asset(
                          'assets/icon_dinamax.png',
                          height: 40,
                          width: 40,
                        ),
                      if (wantGigantamax ?? false)
                        Image.asset(
                          'assets/icon_gigamax.png',
                          height: 40,
                          width: 40,
                        ),
                      if (wantAdventureEffect ?? false)
                        Image.asset(
                          'assets/icon_adventure_effect.png',
                          height: 40,
                          width: 40,
                        ),
                      if (wantLucky ?? false)
                        Image.asset(
                          'assets/icon_lucky.png',
                          height: 40,
                          width: 40,
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            border: Border(top: BorderSide(color: Colors.grey[300]!, width: 1)),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Text(
                  'N.º $_dex $pokemonName',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              if (alreadyCaught ?? false)
                const Icon(Icons.catching_pokemon, color: Colors.red, size: 18),
            ],
          ),
        ),
      ],
    ),
  );
}

class AvatarImage extends StatelessWidget {
  const AvatarImage({required this.label, super.key});
  final String label;
  @override
  Widget build(BuildContext context) => const CircleAvatar(
    backgroundColor: Colors.amber,
    child: Icon(Icons.catching_pokemon),
  );
}
