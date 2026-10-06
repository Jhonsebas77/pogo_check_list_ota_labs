part of com.pogo_check_list_ota_labs.app.widgets;

/// Debilidades, resistencias e inmunidades calculadas con [kTypeChart] a
/// partir de los tipos que entrega la API (en inglés).
class TypeMatchupCard extends StatelessWidget {
  const TypeMatchupCard({required this.types, super.key});

  final List<String> types;

  @override
  Widget build(BuildContext context) {
    TypeEffectiveness effectiveness = getTypeEffectiveness(
      types
          .map((String type) => kPokemonTypesTranslated[type] ?? type)
          .toList(),
    );
    return DetailCard(
      title: 'Efectividad de tipos',
      icon: Icons.shield_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _MatchupSection(
            title: 'Debilidades',
            matchup: effectiveness.weaknesses,
          ),
          _MatchupSection(
            title: 'Resistencias',
            matchup: effectiveness.resistances,
          ),
          if (effectiveness.immunities.isNotEmpty)
            _MatchupSection(
              title: 'Inmunidades',
              matchup: effectiveness.immunities,
            ),
        ],
      ),
    );
  }
}

class _MatchupSection extends StatelessWidget {
  const _MatchupSection({required this.title, required this.matchup});

  final String title;
  final List<TypeMatchup> matchup;

  @override
  Widget build(BuildContext context) {
    // Agrupa los tipos por multiplicador, conservando el orden recibido.
    Map<double, List<String>> groups = <double, List<String>>{};
    for (TypeMatchup m in matchup) {
      groups.putIfAbsent(m.multiplier, () => <String>[]).add(m.type);
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title.toUpperCase(),
            style: Paragraphs.disclaimerSemiBold.copyWith(
              color: onPrimaryMuted,
            ),
          ),
          const SizedBox(height: 8),
          if (matchup.isEmpty)
            Text(
              'Ninguna',
              style: Paragraphs.small.copyWith(color: Colors.white),
            )
          else
            for (MapEntry<double, List<String>> group in groups.entries)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: TypeMatchupGroup(
                  multiplier: group.key,
                  types: group.value,
                  small: true,
                ),
              ),
        ],
      ),
    );
  }
}
