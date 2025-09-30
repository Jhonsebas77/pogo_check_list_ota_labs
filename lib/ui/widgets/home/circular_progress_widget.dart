part of com.pogo_check_list_ota_labs.app.widgets;

class HomeCircularProgressWidget extends StatelessWidget {
  const HomeCircularProgressWidget({
    required this.allItemLength,
    required this.centerWidget,
    required this.counterItemLength,
    super.key,
  });

  final double allItemLength;
  final double counterItemLength;
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
      child: CircularPercentIndicator(
        radius: 28,
        lineWidth: 6,
        percent: counterItemLength / allItemLength,
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        progressColor: Theme.of(context).colorScheme.secondary,
        circularStrokeCap: CircularStrokeCap.square,
        center: centerWidget,
        footer: Text(
          '''${(counterItemLength / allItemLength * 100).toStringAsFixed(2)}%''',
          style: const TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.start,
        ),
      ),
    ),
  );
}
