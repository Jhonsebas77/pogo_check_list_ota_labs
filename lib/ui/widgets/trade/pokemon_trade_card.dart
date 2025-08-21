part of com.pogo_check_list_ota_labs.app.widgets;

class PokemonTradeCard extends StatelessWidget {
  const PokemonTradeCard({
    required this.pokemonId,
    required this.pokemonName,
    super.key,
  });

  final int pokemonId;
  final String pokemonName;

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
                  Image.asset(
                    'assets/pokedex_sprites/$pokemonId.png',
                    height: 80,
                    width: 80,
                  ),
                ],
              ),
              const SizedBox(width: 8),
              const SizedBox(height: 8),
              const Expanded(
                child: Center(
                  child: Wrap(
                    spacing: 2,
                    runSpacing: 4,
                    children: <Widget>[
                      AvatarImage(label: 'Shiny'),
                      AvatarImage(label: 'Fondo especial'),
                      AvatarImage(label: 'Dinamax'),
                      AvatarImage(label: 'Gigantamax'),
                      AvatarImage(label: 'Efecto de aventura'),
                      AvatarImage(label: 'Suerte'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
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
                  ),
                ),
              ),
              const Icon(
                Icons.catching_pokemon,
                color: Color(0xFFF37A24),
                size: 18,
              ),
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
