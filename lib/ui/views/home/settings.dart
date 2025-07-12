part of com.pogo_check_list_ota_labs.app.views;

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) => const Center(
    child: Column(
      children: <Widget>[
        Text(
          'Settings View',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        VersionWidget(),
      ],
    ),
  );
}
