part of com.pogo_check_list_ota_labs.app.widgets;

class HomeLinearProgressWidget extends StatelessWidget {
  const HomeLinearProgressWidget({
    required this.allItemLength,
    required this.counterItemLength,
    required this.centerWidget,
    super.key,
  });
  final num allItemLength;
  final num counterItemLength;
  final Widget centerWidget;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.only(left: 12, top: 8, bottom: 8, right: 12),
    decoration: BoxDecoration(
      color: Colors.black12,
      borderRadius: BorderRadius.circular(16),
    ),
    child: SizedBox(
      height: 100,
      width: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          centerWidget,
          LinearProgressIndicator(
            value: counterItemLength / allItemLength,
            borderRadius: BorderRadius.circular(50),
          ),
          Text(
            '$counterItemLength / $allItemLength',
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.start,
          ),
        ],
      ),
    ),
  );
}
