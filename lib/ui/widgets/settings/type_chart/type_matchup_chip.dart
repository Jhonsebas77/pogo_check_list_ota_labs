part of com.pogo_check_list_ota_labs.app.widgets;

class TypeMatchupChip extends StatelessWidget {
  const TypeMatchupChip(this.matchup, {super.key});

  final TypeMatchup matchup;

  @override
  Widget build(BuildContext context) {
    Color baseColor = kTypeColors[matchup.type] ?? Colors.grey;
    IconData icon = kTypeIcons[matchup.type] ?? Icons.help_outline;

    return Chip(
      backgroundColor: baseColor.withValues(alpha: 0.9),
      avatar: CircleAvatar(
        backgroundColor: Colors.white.withValues(alpha: 0.25),
        child: Icon(icon, color: Colors.white, size: 15),
      ),
      label: Text(
        '''${matchup.type.toUpperCase()} · ${_formatMultiplier(matchup.multiplier)}x''',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _formatMultiplier(double multiplier) {
    if (multiplier == multiplier.roundToDouble()) {
      return multiplier.toStringAsFixed(0);
    }
    if (multiplier < 1) {
      String formatted = multiplier.toStringAsFixed(2);
      return formatted.endsWith('0')
          ? formatted.substring(0, formatted.length - 1)
          : formatted;
    }
    return multiplier.toStringAsFixed(1);
  }
}
