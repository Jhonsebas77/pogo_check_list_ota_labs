part of com.pogo_check_list_ota_labs.app.widgets;

class SettingsTitleSection extends StatelessWidget {
  const SettingsTitleSection({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(8),
    child: Text(
      title,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
  );
}
