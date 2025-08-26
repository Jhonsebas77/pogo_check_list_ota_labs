part of com.pogo_check_list_ota_labs.app.views;

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          children: <Widget>[
            const Text(
              'Herramientas',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Material(
                color: Colors.black12,
                elevation: 1,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.black12, width: 3),
                  borderRadius: BorderRadiusGeometry.circular(12),
                ),
                child: ListTile(
                  title: const Text(
                    'Intercambios',
                    style: TextStyle(color: Colors.white),
                  ),
                  leading: const Icon(Icons.search, color: Colors.white),
                  trailing: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.white,
                  ),
                  onTap: () {
                    CustomNavigator().push(context, const WantedView());
                  },
                ),
              ),
            ),
          ],
        ),
        const Column(children: <Widget>[Divider(), VersionWidget()]),
      ],
    ),
  );
}
