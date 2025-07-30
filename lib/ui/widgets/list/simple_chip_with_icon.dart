part of com.pogo_check_list_ota_labs.app.widgets;

class SimpleChipWithIcon extends StatelessWidget {
  const SimpleChipWithIcon({
    required this.text,
    required this.iconData,
    super.key,
  });

  final String text;
  final IconData iconData;

  @override
  Widget build(BuildContext context) => Row(
    children: <Widget>[
      Icon(iconData, color: Colors.black87, size: 14),
      const SizedBox(width: 4),
      Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black87,
          fontWeight: FontWeight.normal,
        ),
      ),
    ],
  );
}
