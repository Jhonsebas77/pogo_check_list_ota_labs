part of com.pogo_check_list_ota_labs.app.views;

class HomePoGoView extends StatelessWidget {
  const HomePoGoView({super.key});
  static const String route = '/home';

  @override
  Widget build(BuildContext context) => const Column(
    children: <Widget>[
      TrainerInformation(),
      Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Divider()),
      DashboardOverview(),
    ],
  );
}
