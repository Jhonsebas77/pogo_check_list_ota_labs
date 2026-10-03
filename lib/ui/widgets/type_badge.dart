part of com.pogo_check_list_ota_labs.app.widgets;

class TypeBadge extends StatelessWidget {
  const TypeBadge({
    required this.type,
    required this.color,
    required this.icon,
    super.key,
  });

  final String type;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    Color foreground = readableOn(color);
    return Chip(
      backgroundColor: color.withValues(alpha: 0.9),
      avatar: CircleAvatar(
        backgroundColor: foreground.withValues(alpha: 0.2),
        child: Icon(icon, color: foreground, size: 15),
      ),
      label: Text(
        type.toUpperCase(),
        style: TextStyle(color: foreground, fontWeight: FontWeight.bold),
      ),
    );
  }
}
