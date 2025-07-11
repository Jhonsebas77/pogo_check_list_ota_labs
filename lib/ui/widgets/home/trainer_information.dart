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
                  return Column(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.only(
                          left: 12,
                          top: 8,
                          bottom: 8,
                          right: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Image.asset(
                                'assets/team_${_trainerInfo?.team ?? ''}.png',
                                height: 80,
                                width: 80,
                                fit: BoxFit.fill,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  _trainerInfo?.nickName ?? '',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'Lv. ${_trainerInfo?.level}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 24),
                            GestureDetector(
                              onTap:
                                  () => Clipboard.setData(
                                    ClipboardData(
                                      text: _trainerInfo?.trainerId ?? '',
                                    ),
                                  ),
                              child: Chip(
                                label: const Text('Copiar ID'),
                                avatar: const Icon(Icons.copy),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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
