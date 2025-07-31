part of com.pogo_check_list_ota_labs.app.widgets;

class DashboardOverview extends ConsumerWidget {
  const DashboardOverview({super.key});

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
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<PokemonFirebaseState> firebasePokemonState = ref.watch(
      firebasePokemonProvider,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: firebasePokemonState.when(
        data:
            (PokemonFirebaseState state) => Wrap(
              spacing: 12,
              runSpacing: 12,
              children: <Widget>[
                HomeCircularProgressWidget(
                  allItemLength: state.getTotalPokemonLength().toDouble(),
                  counterItemLength:
                      state.getAlreadyCatchPokemonLength().toDouble(),
                  centerWidget: const Icon(
                    Icons.catching_pokemon,
                    color: Colors.white,
                  ),
                ),
                HomeCircularProgressWidget(
                  allItemLength:
                      state.getShinyAvailablePokemonLength().toDouble(),
                  counterItemLength:
                      state.getAlreadyCatchPokemonShinyLength().toDouble(),
                  centerWidget: const Text('✨', textAlign: TextAlign.start),
                ),
                HomeCircularProgressWidget(
                  allItemLength:
                      state.getAllGigantamaxPokemonLength().toDouble(),
                  counterItemLength:
                      state.getAlreadyCatchGigantamaxPokemonLength().toDouble(),
                  centerWidget: Image.asset(
                    'assets/gigamax.png',
                    height: 30,
                    width: 30,
                    fit: BoxFit.fill,
                  ),
                ),
                HomeCircularProgressWidget(
                  allItemLength:
                      state.getAllMegaEvolutionsPokemonLength().toDouble(),
                  counterItemLength:
                      state
                          .getAlreadyCatchMegaEvolutionsPokemonLength()
                          .toDouble(),
                  centerWidget: Image.asset(
                    'assets/icon_mega.png',
                    height: 30,
                    width: 30,
                    fit: BoxFit.fill,
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    await showModalBottomSheet<void>(
                      context: context,
                      builder:
                          (
                            BuildContext context,
                          ) => ZygardeInformationBottomSheet(
                            zygardeCells: state.zygardeCells!,
                            actualFormImage:
                                'assets/pokedex_sprites/718_${getZygardeFormAccordToCells(state.zygardeCells!)}.png',
                          ),
                    );
                  },
                  child: HomeLinearProgressWidget(
                    allItemLength: state.zygardeCells?.limit ?? 0,
                    counterItemLength: state.zygardeCells?.quantity ?? 0,
                    centerWidget: Image.asset(
                      'assets/pokedex_sprites/718_${getZygardeFormAccordToCells(state.zygardeCells!)}.png',
                      height: 50,
                      width: 50,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ],
            ),
        error:
            (Object error, StackTrace stackTrace) => SimpleErrorChip(
              iconData: Icons.dashboard,
              error: error.toString(),
              stackTrace: stackTrace,
              text: 'Con la información del resumen',
            ),
        loading: DashboardOverviewShimmer.new,
      ),
    );
  }
}

class ZygardeInformationBottomSheet extends StatelessWidget {
  const ZygardeInformationBottomSheet({
    required this.zygardeCells,
    required this.actualFormImage,
    super.key,
  });
  final ZygardeCells zygardeCells;
  final String actualFormImage;
  @override
  Widget build(BuildContext context) => DecoratedBox(
    key: const Key('bottom_sheet'),
    decoration: const BoxDecoration(
      color: Colors.black54,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    ),
    child: ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text(
            'Células Zygarde',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Image.asset(
                    actualFormImage,
                    height: 50,
                    width: 50,
                    fit: BoxFit.fill,
                  ),
                  Text(zygardeCells.actualForm),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      width: 80,
                      child: LinearProgressIndicator(
                        value: zygardeCells.quantity / zygardeCells.limit,
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    Text(
                      '${zygardeCells.quantity} / ${zygardeCells.limit} ',
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
              Text('${zygardeCells.quantity}'),
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
              if (zygardeCells.actualForm ==
                  zygardeCells.forms?[0].alternativeForm?.name)
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
              if (zygardeCells.actualForm ==
                  zygardeCells.forms?[1].alternativeForm?.name)
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
              if (zygardeCells.actualForm ==
                  zygardeCells.forms?[2].alternativeForm?.name)
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
          const Padding(
            padding: EdgeInsets.all(8),
            child: Divider(thickness: 2),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(onPressed: () {}, icon: const Icon(Icons.plus_one)),
              Image.asset(
                'assets/zygarde_cube.png',
                height: 50,
                width: 50,
                fit: BoxFit.fill,
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.exposure_minus_1),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    ),
  );
}
