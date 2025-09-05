part of com.pogo_check_list_ota_labs.app.widgets;

class SettingsMenuItem extends StatelessWidget {
  const SettingsMenuItem({
    required this.title,
    required this.leadingIcon,
    required this.viewToNavigate,
    super.key,
  });
  final String title;
  final IconData leadingIcon;
  final Widget viewToNavigate;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(8),
    child: Material(
      color: Theme.of(
        context,
      ).colorScheme.surfaceContainerHighest.withAlpha(100),
      elevation: 1,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.black12, width: 3),
        borderRadius: BorderRadiusGeometry.circular(12),
      ),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
        leading: Icon(
          leadingIcon,
          color: Theme.of(context).colorScheme.onSurface,
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          color: Theme.of(context).colorScheme.onSurface,
        ),
        onTap: () {
          CustomNavigator().push(context, viewToNavigate);
        },
      ),
    ),
  );
}
