part of com.pogo_check_list_ota_labs.app.widgets;

class SettingsMenuItem extends StatelessWidget {
  const SettingsMenuItem({
    required this.title,
    required this.leadingIcon,
    required this.viewToNavigate,
    required this.routeName,
    super.key,
  });
  final String title;
  final IconData leadingIcon;
  final Widget viewToNavigate;
  final String routeName;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: Colors.black12,
      borderRadius: BorderRadius.circular(32),
    ),
    child: ListTile(
      title: Text(title, style: const TextStyle(color: Colors.white)),
      leading: Icon(leadingIcon, color: Colors.white),
      trailing: const Icon(
        Icons.arrow_forward_ios_rounded,
        color: Colors.white,
      ),
      onTap: () {
        CustomNavigator().push(
          context,
          viewToNavigate,
          routeName: routeName,
          animation: CustomNavigationAnimation.fade,
        );
      },
    ),
  );
}
