part of com.pogo_check_list_ota_labs.app.widgets;

/// Estadísticas base de la serie principal con su barra de progreso.
class BaseStatsCard extends StatelessWidget {
  const BaseStatsCard({required this.stats, required this.total, super.key});

  final List<PokemonStat> stats;
  final int total;

  /// Valor base más alto posible en la serie principal (PS de Blissey).
  static const double _maxStat = 255;

  @override
  Widget build(BuildContext context) => DetailCard(
    title: 'Estadísticas base',
    icon: Icons.bar_chart,
    child: Column(
      children: <Widget>[
        for (PokemonStat stat in stats)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Semantics(
              label: '${stat.label}: ${stat.baseStat}',
              excludeSemantics: true,
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 80,
                    child: Text(
                      stat.label,
                      style: Paragraphs.small.copyWith(color: onPrimaryMuted),
                    ),
                  ),
                  SizedBox(
                    width: 36,
                    child: Text(
                      '${stat.baseStat}',
                      textAlign: TextAlign.end,
                      style: Paragraphs.smallSemiBold.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: (stat.baseStat / _maxStat).clamp(0, 1),
                        minHeight: 6,
                        color: secondaryDarkColor,
                        backgroundColor: Colors.white24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        const Divider(color: Colors.white24, height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'TOTAL',
              style: Paragraphs.smallSemiBold.copyWith(color: onPrimaryMuted),
            ),
            Text(
              '$total',
              style: Paragraphs.mediumSemiBold.copyWith(color: Colors.white),
            ),
          ],
        ),
      ],
    ),
  );
}
