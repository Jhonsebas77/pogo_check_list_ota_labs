part of com.pogo_check_list_ota_labs.app.views;

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) => const Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SettingsTitleSection(title: 'Herramientas'),
            SettingsMenuItem(
              title: 'Intercambios',
              leadingIcon: Icons.search,
              viewToNavigate: WantedForTradeView(),
            ),
            SettingsMenuItem(
              title: 'Tabla de tipos',
              leadingIcon: Icons.apps,
              viewToNavigate: TypeChartView(),
            ),
            SettingsMenuItem(
              title: 'Amistades con suerte',
              leadingIcon: Icons.supervised_user_circle,
              viewToNavigate: LuckyFriendsView(),
            ),
          ],
        ),
        SizedBox(height: 16),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SettingsTitleSection(title: 'Aplicación'),
            SettingsMenuItem(
              title: 'Aspecto',
              leadingIcon: Icons.palette,
              viewToNavigate: ColorSchemeView(),
            ),
          ],
        ),
        Column(children: <Widget>[Divider(), VersionWidget()]),
      ],
    ),
  );
}
