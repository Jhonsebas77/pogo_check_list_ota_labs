part of com.pogo_check_list_ota_labs.app.widgets;
class VersionWidget extends StatelessWidget {
  const VersionWidget({super.key});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(8),
    child: Container(
      width: 200,
      padding: const EdgeInsets.only(left: 12, top: 8, bottom: 8, right: 12),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(50),
      ),
      child: const SelectableText(
        'By Ota_Labs V.1.0.0+8',
        textAlign: TextAlign.center,
      ),
    ),
  );
}
