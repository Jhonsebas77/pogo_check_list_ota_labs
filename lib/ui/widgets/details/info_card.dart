part of com.pogo_check_list_ota_labs.app.widgets;

/// Altura, peso y habilidades del Pokémon.
class PokemonInfoCard extends StatelessWidget {
  const PokemonInfoCard({required this.pokemon, super.key});

  final PokemonDetail pokemon;

  @override
  Widget build(BuildContext context) {
    NumberFormat format = NumberFormat('0.0#', 'es');
    return DetailCard(
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: _InfoColumn(
                icon: Icons.height,
                value: '${format.format(pokemon.heightInMeters)} m',
                label: 'Altura',
              ),
            ),
            const VerticalDivider(color: Colors.white24, width: 16),
            Expanded(
              child: _InfoColumn(
                icon: Icons.scale_outlined,
                value: '${format.format(pokemon.weightInKg)} kg',
                label: 'Peso',
              ),
            ),
            const VerticalDivider(color: Colors.white24, width: 16),
            Expanded(
              child: _InfoColumn(
                icon: Icons.bolt,
                value: pokemon.abilities
                    .where((PokemonAbility a) => !a.isHidden)
                    .map((PokemonAbility a) => a.displayName)
                    .join('\n'),
                detail: pokemon.abilities
                    .where((PokemonAbility a) => a.isHidden)
                    .map((PokemonAbility a) => '${a.displayName} (oculta)')
                    .join('\n'),
                label: 'Habilidades',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoColumn extends StatelessWidget {
  const _InfoColumn({
    required this.icon,
    required this.value,
    required this.label,
    this.detail = '',
  });

  final IconData icon;
  final String value;
  final String label;
  final String detail;

  @override
  Widget build(BuildContext context) => Column(
    children: <Widget>[
      Icon(icon, color: Colors.white, size: 20),
      const SizedBox(height: 8),
      Text(
        value,
        textAlign: TextAlign.center,
        style: Paragraphs.mediumSemiBold.copyWith(color: Colors.white),
      ),
      if (detail.isNotEmpty)
        Text(
          detail,
          textAlign: TextAlign.center,
          style: Paragraphs.disclaimer.copyWith(color: onPrimaryMuted),
        ),
      const SizedBox(height: 4),
      Text(label, style: Paragraphs.disclaimer.copyWith(color: onPrimaryMuted)),
    ],
  );
}
