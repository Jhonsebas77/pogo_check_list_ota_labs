part of com.pogo_check_list_ota_labs.app.widgets;

class CountOverviewModal extends StatelessWidget {
  const CountOverviewModal({
    required this.title,
    required this.allItemLength,
    required this.counterItemLength,
    super.key,
  });

  final String title;
  final num allItemLength;
  final num counterItemLength;

  @override
  Widget build(BuildContext context) => ModalBase(
    title: title,
    centerTitle: true,
    titleStyle: const TextStyle(
      fontSize: 20,
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            LinearProgressIndicator(
              value: counterItemLength / allItemLength,
              borderRadius: BorderRadius.circular(50),
              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
              color: Theme.of(context).colorScheme.secondary,
            ),
            Text(
              '${counterItemLength.floor()} / ${allItemLength.floor()}',
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 20),
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    ],
  );
}
