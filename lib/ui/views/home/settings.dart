part of com.pogo_check_list_ota_labs.app.views;

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});
  static const String route = '/settings';

  @override
  Widget build(BuildContext context) => const Center(
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4,
            children: <Widget>[
              SettingsTitleSection(title: 'Herramientas'),
              SettingsMenuItem(
                title: 'Amistades con suerte',
                leadingIcon: Icons.supervised_user_circle,
                viewToNavigate: LuckyFriendsView(),
                routeName: LuckyFriendsView.route,
              ),
              SettingsMenuItem(
                title: 'Editar perfil de entrenador',
                leadingIcon: Icons.mode_edit_rounded,
                viewToNavigate: TrainerEditorView(),
                routeName: TrainerEditorView.route,
              ),
              SettingsMenuItem(
                title: 'Intercambios',
                leadingIcon: Icons.search,
                viewToNavigate: WantedForTradeView(),
                routeName: WantedForTradeView.route,
              ),
              SettingsMenuItem(
                title: 'Tabla de tipos',
                leadingIcon: Icons.apps,
                viewToNavigate: TypeChartView(),
                routeName: TypeChartView.route,
              ),
            ],
          ),
          SizedBox(height: 16),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4,
            children: <Widget>[
              SettingsTitleSection(title: 'Aplicación'),
              SettingsMenuItem(
                title: 'Aspecto',
                leadingIcon: Icons.palette,
                viewToNavigate: ColorSchemeView(),
                routeName: ColorSchemeView.route,
              ),
              SignOutMenuItem(),
            ],
          ),
          Column(children: <Widget>[Divider(), VersionWidget()]),
        ],
      ),
    ),
  );
}
