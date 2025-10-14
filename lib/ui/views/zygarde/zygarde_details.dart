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

  String? getZygardeFormAccordToCells(ZygardeCells _zygardeCells) {
    if (_zygardeCells.quantity >= 200) {
      return _zygardeCells.forms?[2].alternativeForm?.id;
    } else if (_zygardeCells.quantity >= 50) {
      return _zygardeCells.forms?[1].alternativeForm?.id;
    } else {
      return _zygardeCells.forms?[0].alternativeForm?.id;
    }
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
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const Text('Zygarde'),
              firebasePokemonState.when(
                data:
                    (PokemonFirebaseState state) => Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Image.asset(
                                  'assets/pokedex_sprites/718_${getZygardeFormAccordToCells(state.zygardeCells!)}.png',
                                  height: 50,
                                  width: 50,
                                  fit: BoxFit.fill,
                                ),
                                Text(state.zygardeCells!.actualForm),
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
                                          state.zygardeCells!.quantity /
                                          state.zygardeCells!.limit,
                                      borderRadius: BorderRadius.circular(50),
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
                        const Padding(
                          padding: EdgeInsets.all(8),
                          child: Divider(thickness: 2),
                        ),
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
                        const Padding(
                          padding: EdgeInsets.all(8),
                          child: Divider(thickness: 2),
                        ),
                        const Text('Forms'),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            if (state.zygardeCells!.actualForm ==
                                state
                                    .zygardeCells!
                                    .forms?[0]
                                    .alternativeForm
                                    ?.name)
                              Image.asset(
                                'assets/pokedex_sprites/718_10.png',
                                height: 50,
                                width: 50,
                                fit: BoxFit.fill,
                              )
                            else
                              Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                enabled: false,
                                child: Image.asset(
                                  'assets/pokedex_sprites/718_10.png',
                                  height: 50,
                                  width: 50,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            if (state.zygardeCells!.actualForm ==
                                state
                                    .zygardeCells!
                                    .forms?[1]
                                    .alternativeForm
                                    ?.name)
                              Image.asset(
                                'assets/pokedex_sprites/718_50.png',
                                height: 50,
                                width: 50,
                                fit: BoxFit.fill,
                              )
                            else
                              Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                enabled: false,
                                child: Image.asset(
                                  'assets/pokedex_sprites/718_50.png',
                                  height: 50,
                                  width: 50,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            if (state.zygardeCells!.actualForm ==
                                state
                                    .zygardeCells!
                                    .forms?[2]
                                    .alternativeForm
                                    ?.name)
                              Image.asset(
                                'assets/pokedex_sprites/718_100.png',
                                height: 50,
                                width: 50,
                                fit: BoxFit.fill,
                              )
                            else
                              Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                enabled: false,
                                child: Image.asset(
                                  'assets/pokedex_sprites/718_100.png',
                                  height: 50,
                                  width: 50,
                                  fit: BoxFit.fill,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                error:
                    (Object error, StackTrace stackTrace) => SimpleErrorChip(
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
    );
  }
}
