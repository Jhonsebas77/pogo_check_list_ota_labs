part of com.pogo_check_list_ota_labs.app.widgets;

class TrainerInformation extends StatelessWidget {
  const TrainerInformation({super.key});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: Consumer<FirebaseProvider>(
      builder: (
        BuildContext context,
        FirebaseProvider firebaseProvider,
        Widget? child,
      ) {
        if (firebaseProvider.isLoading) {
          return const LoadingWidget();
        } else if (firebaseProvider.trainerInformation == null) {
          return const EmptyState();
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Builder(
                builder: (BuildContext context) {
                  TrainerModel? _trainerInfo =
                      firebaseProvider.trainerInformation;
                  return Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: <Widget>[
                      Text('${_trainerInfo?.level}'),
                      Text(_trainerInfo?.nickName ?? ''),
                      Text(_trainerInfo?.team ?? ''),
                      Text('${_trainerInfo?.trainerId}'),
                    ],
                  );
                },
              ),
            ],
          );
        }
      },
    ),
  );
}
