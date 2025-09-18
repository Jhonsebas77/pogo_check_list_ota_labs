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
  Widget build(BuildContext context) => Chip(
    backgroundColor: color.withValues(alpha: 0.9),
    avatar: CircleAvatar(
      backgroundColor: Colors.white.withValues(alpha: 0.25),
      child: Icon(icon, color: Colors.white, size: 15,),
    ),
    label: Text(
      type.toUpperCase(),
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
  );
}
