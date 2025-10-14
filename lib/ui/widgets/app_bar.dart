part of com.pogo_check_list_ota_labs.app.widgets;

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({this.isTransparent = false, this.title, super.key});
  final String? title;
  final bool? isTransparent;
  @override
  Widget build(BuildContext context) => AppBar(
    backgroundColor:
        (isTransparent ?? false)
            ? Colors.transparent
            : Theme.of(context).colorScheme.primary,
    systemOverlayStyle: getSystemOverlayStyle(context),
    toolbarHeight: 82,
    leading: const DexHeaderLeading(),
    actions: const DexHeaderActions().getActions(),
    title: Text(
      title ?? '',
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    centerTitle: true,
    elevation: 0,
  );

  @override
  Size get preferredSize => const Size.fromHeight(82);
}
