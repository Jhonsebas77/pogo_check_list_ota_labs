part of com.pogo_check_list_ota_labs.app.widgets;

/// Panel translúcido sobre el fondo primario usado por las secciones del
/// detalle del Pokémon.
class DetailCard extends StatelessWidget {
  const DetailCard({required this.child, this.title, this.icon, super.key});

  final Widget child;
  final String? title;
  final IconData? icon;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.black12,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (title != null) ...<Widget>[
          Row(
            children: <Widget>[
              if (icon != null) ...<Widget>[
                Icon(icon, color: Colors.white, size: 20),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Text(
                  title!,
                  style: Headings.mH4.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
        ],
        child,
      ],
    ),
  );
}

/// Título de sección escrito directamente sobre el fondo primario.
class DetailSectionTitle extends StatelessWidget {
  const DetailSectionTitle(this.title, {super.key});

  final String title;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Text(title, style: Headings.mH3.copyWith(color: Colors.white)),
  );
}
