part of com.pogo_check_list_ota_labs.app.widgets;

/// Etiqueta con el multiplicador de daño (ej. `×2`, `×0.5`), coloreada según
/// si el daño recibido aumenta, disminuye o es nulo.
class TypeMultiplierPill extends StatelessWidget {
  const TypeMultiplierPill(this.multiplier, {super.key});

  final double multiplier;

  @override
  Widget build(BuildContext context) {
    Color color = switch (multiplier) {
      0 => Colors.blueGrey.shade700,
      >= 4 => Colors.red.shade900,
      > 1 => Colors.red.shade600,
      <= 0.25 => Colors.green.shade900,
      _ => Colors.green.shade600,
    };
    return Container(
      constraints: const BoxConstraints(minWidth: 56),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '×${formatMultiplier(multiplier)}',
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  static String formatMultiplier(double multiplier) {
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

/// Grupo de tipos que comparten el mismo multiplicador de daño.
class TypeMatchupGroup extends StatelessWidget {
  const TypeMatchupGroup({
    required this.multiplier,
    required this.types,
    this.small = false,
    super.key,
  });

  final double multiplier;
  final List<String> types;

  /// Muestra cada tipo con su icono cuadrado `_small` en lugar del banner.
  final bool small;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.only(top: 2),
        child: TypeMultiplierPill(multiplier),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
              types
                  .map(
                    (String type) => TypeImageBadge(
                      type: type,
                      height: small ? 32 : 30,
                      small: small,
                    ),
                  )
                  .toList(),
        ),
      ),
    ],
  );
}
