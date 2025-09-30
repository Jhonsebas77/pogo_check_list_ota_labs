part of com.pogo_check_list_ota_labs.app.widgets;

class TrainerInformation extends ConsumerWidget {
  const TrainerInformation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<PokemonFirebaseState> firebasePokemonState = ref.watch(
      firebasePokemonProvider,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: firebasePokemonState.when(
        data: (PokemonFirebaseState state) {
          TrainerModel? _trainerInfo = state.trainerInformation;
          return Container(
            width: 400,
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Stack(
                        alignment: AlignmentDirectional.center,
                        children: <Widget>[
                          Image.asset(
                            'assets/bg_holder_pokemon.png',
                            height: 64,
                            width: 64,
                            fit: BoxFit.fill,
                          ),
                          Image.asset(
                            'assets/team_${_trainerInfo?.team ?? ''}.png',
                            height: 50,
                            width: 50,
                            fit: BoxFit.fill,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        FittedBox(
                          child: Text(
                            _trainerInfo?.nickName ?? '',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
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
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(
                      ClipboardData(text: _trainerInfo?.trainerId ?? ''),
                    );
                    if (context.mounted) {
                      showSuccessSnackBar(
                        context,
                        '''[Trainer ID copiado]\n${_trainerInfo?.trainerId ?? ''}''',
                      );
                    }
                  },
                  child: Chip(
                    label: Text(
                      'Copiar ID',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    avatar: Icon(
                      Icons.copy,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        error:
            (Object error, StackTrace stackTrace) => SimpleErrorChip(
              iconData: Icons.person,
              error: error.toString(),
              stackTrace: stackTrace,
              text: 'Con la información del entrenador',
            ),
        loading: TrainerInfoShimmer.new,
      ),
    );
  }
}
