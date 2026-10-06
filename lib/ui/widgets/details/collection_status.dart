part of com.pogo_check_list_ota_labs.app.widgets;

/// Estado del Pokémon en la colección del entrenador (solo lectura).
class CollectionStatusRow extends StatelessWidget {
  const CollectionStatusRow({required this.pokemon, super.key});

  final PokemonModel pokemon;

  @override
  Widget build(BuildContext context) {
    if (!pokemon.available) {
      return const DetailCard(
        child: Row(
          children: <Widget>[
            Icon(Icons.block, color: Colors.white),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Aún no disponible en Pokémon GO',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: _StatusTile(
            icon: const Icon(Icons.catching_pokemon, color: Colors.white),
            label: 'Capturado',
            active: pokemon.alreadyCatch,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatusTile(
            icon: Image.asset('assets/icon_shiny.png', height: 24, width: 24),
            label: 'Shiny',
            active: pokemon.alreadyCatchShinyVersion,
            unavailable: !pokemon.shinyAvailable,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatusTile(
            icon: const Icon(
              Icons.wifi_protected_setup_sharp,
              color: Colors.white,
            ),
            label: 'Intercambio',
            active: pokemon.tradable,
          ),
        ),
      ],
    );
  }
}

class _StatusTile extends StatelessWidget {
  const _StatusTile({
    required this.icon,
    required this.label,
    required this.active,
    this.unavailable = false,
  });

  final Widget icon;
  final String label;
  final bool active;
  final bool unavailable;

  @override
  Widget build(BuildContext context) {
    String status =
        unavailable
            ? 'No disp.'
            : active
            ? 'Sí'
            : 'No';
    return Semantics(
      label: '$label: $status',
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: <Widget>[
            icon,
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Paragraphs.small.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: BoxDecoration(
                color:
                    active && !unavailable ? Colors.lightGreen : Colors.black26,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (active && !unavailable) ...<Widget>[
                    const Icon(Icons.check, size: 14, color: onLightAccent),
                    const SizedBox(width: 4),
                  ],
                  Text(
                    status,
                    style: Paragraphs.disclaimerSemiBold.copyWith(
                      color:
                          active && !unavailable
                              ? onLightAccent
                              : onPrimaryMuted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
