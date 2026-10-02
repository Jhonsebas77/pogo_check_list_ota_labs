part of com.pogo_check_list_ota_labs.app.views;

class ZygardeDetails extends ConsumerStatefulWidget {
  const ZygardeDetails({super.key});

  @override
  ConsumerState<ZygardeDetails> createState() => _ZygardeDetailsState();
}

class _ZygardeDetailsState extends ConsumerState<ZygardeDetails> {
  @override
  void initState() {
    super.initState();
  }

  String getZygardeActualForm(ZygardeCells zygardeCells) {
    String zygardeId = '';
    switch (zygardeCells.actualForm) {
      case '10%':
        zygardeId = zygardeCells.alternativeForms![0].formTag?.id ?? '10';
      case '50%':
        zygardeId = zygardeCells.alternativeForms![1].formTag?.id ?? '50';
      case '100%':
        zygardeId = zygardeCells.alternativeForms![2].formTag?.id ?? '100';
    }
    return zygardeId;
  }

  @override
  Widget build(BuildContext context) {
    AsyncValue<PokemonFirebaseState> firebasePokemonState = ref.watch(
      firebasePokemonProvider,
    );

    return SafeArea(
      child: Scaffold(
        appBar: const CustomAppBar(title: 'Células Zygarde'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: Center(
          child: SingleChildScrollView(
            child: SizedBox(
              width: 271,
              child: Column(
                children: <Widget>[
                  firebasePokemonState.when(
                    data:
                        (PokemonFirebaseState state) => Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Card(
                                  color: Colors.black.withValues(alpha: 0.35),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Column(
                                          children: <Widget>[
                                            Image.asset(
                                              'assets/pokedex_sprites/718_${getZygardeActualForm(state.zygardeCells!)}.png',
                                              height: 50,
                                              width: 50,
                                              fit: BoxFit.fill,
                                            ),
                                            Text(
                                              state.zygardeCells!.actualForm,
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Column(
                                            children: <Widget>[
                                              SizedBox(
                                                width: 80,
                                                child: LinearProgressIndicator(
                                                  value:
                                                      state
                                                          .zygardeCells!
                                                          .quantity /
                                                      state.zygardeCells!.limit,
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .secondaryContainer,
                                                  color:
                                                      Theme.of(
                                                        context,
                                                      ).colorScheme.secondary,
                                                ),
                                              ),
                                              Text(
                                                '${state.zygardeCells!.quantity} / ${state.zygardeCells!.limit} ',
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
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Image.asset(
                                      'assets/zygarde_cell.png',
                                      height: 50,
                                      width: 50,
                                      fit: BoxFit.fill,
                                    ),
                                    Text('${state.zygardeCells!.quantity}'),
                                  ],
                                ),
                              ],
                            ),
                            ZygardeForms(zygardeCells: state.zygardeCells!),
                          ],
                        ),
                    error:
                        (Object error, StackTrace stackTrace) =>
                            SimpleErrorChip(
                              iconData: Icons.dashboard,
                              error: error.toString(),
                              stackTrace: stackTrace,
                              text: 'Con la información de Zygarde',
                            ),
                    loading: DashboardOverviewShimmer.new,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
