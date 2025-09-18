part of com.pogo_check_list_ota_labs.app.widgets;

class TypeSection extends StatelessWidget {
  const TypeSection({required this.title, required this.matchup, super.key});

  final String title;
  final List<TypeMatchup> matchup;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
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
              const SizedBox(height: 12),
              if (matchup.isEmpty)
                Text('Ninguna', style: theme.textTheme.bodyMedium)
              else
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: matchup.map(TypeMatchupChip.new).toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
