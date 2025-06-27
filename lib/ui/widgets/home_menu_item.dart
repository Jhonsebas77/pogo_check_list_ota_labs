part of com.pogo_check_list_ota_labs.app.widgets;

class HomeMenuItem extends StatelessWidget {
  const HomeMenuItem({
    required this.label,
    required this.image,
    required this.viewToNavigate,
    super.key,
  });
  final String label;
  final String image;
  final Widget viewToNavigate;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: GestureDetector(
      onTap: () {
        CustomNavigator().push(context, viewToNavigate);
      },
      child: Container(
        padding: const EdgeInsets.only(left: 12, top: 8, bottom: 8, right: 12),
        decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Row(
          children: <Widget>[
            Image.asset(image, height: 80, width: 80, fit: BoxFit.fill),
            const SizedBox(width: 16),
            Text(
              label,
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
