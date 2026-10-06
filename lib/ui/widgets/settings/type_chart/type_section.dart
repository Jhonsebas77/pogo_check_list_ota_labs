part of com.pogo_check_list_ota_labs.app.widgets;

class TypeSection extends StatelessWidget {
  const TypeSection({
    required this.title,
    required this.matchup,
    this.subtitle,
    super.key,
  });

  final String title;
  final String? subtitle;
  final List<TypeMatchup> matchup;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    // Agrupa los tipos por multiplicador, conservando el orden recibido.
    Map<double, List<String>> groups = <double, List<String>>{};
    for (TypeMatchup m in matchup) {
      groups.putIfAbsent(m.multiplier, () => <String>[]).add(m.type);
    }
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              if (subtitle != null)
                Text(subtitle!, style: theme.textTheme.bodySmall),
              const SizedBox(height: 12),
              if (matchup.isEmpty)
                Text('Ninguna', style: theme.textTheme.bodyMedium)
              else
                for (MapEntry<double, List<String>> group in groups.entries)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: TypeMatchupGroup(
                      multiplier: group.key,
                      types: group.value,
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
