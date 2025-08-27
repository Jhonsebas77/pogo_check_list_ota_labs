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
                GestureDetector(
                  onTap: () async {
                    await showDialog<void>(
                      context: context,
                      builder:
                          (BuildContext context) => CountOverviewModal(
                            title: 'Capturados',
                            allItemLength:
                                state.getTotalPokemonLength().toDouble(),
                            counterItemLength:
                                state.getAlreadyCatchPokemonLength().toDouble(),
                          ),
                    );
                  },
                  child: HomeCircularProgressWidget(
                    allItemLength: state.getTotalPokemonLength().toDouble(),
                    counterItemLength:
                        state.getAlreadyCatchPokemonLength().toDouble(),
                    centerWidget: const Icon(
                      Icons.catching_pokemon,
                      color: Colors.white,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    await showDialog<void>(
                      context: context,
                      builder:
                          (BuildContext context) => CountOverviewModal(
                            title: 'Shiny capturados',
                            allItemLength:
                                state
                                    .getShinyAvailablePokemonLength()
                                    .toDouble(),
                            counterItemLength:
                                state
                                    .getAlreadyCatchPokemonShinyLength()
                                    .toDouble(),
                          ),
                    );
                  },
                  child: HomeCircularProgressWidget(
                    allItemLength:
                        state.getShinyAvailablePokemonLength().toDouble(),
                    counterItemLength:
                        state.getAlreadyCatchPokemonShinyLength().toDouble(),
                    centerWidget: const Text('✨', textAlign: TextAlign.start),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    await showDialog<void>(
                      context: context,
                      builder:
                          (BuildContext context) => CountOverviewModal(
                            title: 'Formas Gigantamax capturados',
                            allItemLength:
                                state
                                    .getAllGigantamaxPokemonLength()
                                    .toDouble(),
                            counterItemLength:
                                state
                                    .getAlreadyCatchGigantamaxPokemonLength()
                                    .toDouble(),
                          ),
                    );
                  },
                  child: HomeCircularProgressWidget(
                    allItemLength:
                        state.getAllGigantamaxPokemonLength().toDouble(),
                    counterItemLength:
                        state
                            .getAlreadyCatchGigantamaxPokemonLength()
                            .toDouble(),
                    centerWidget: Image.asset(
                      'assets/gigamax.png',
                      height: 30,
                      width: 30,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    await showDialog<void>(
                      context: context,
                      builder:
                          (BuildContext context) => CountOverviewModal(
                            title: 'Formas Mega evolucionadas capturadas',
                            allItemLength:
                                state
                                    .getAllMegaEvolutionsPokemonLength()
                                    .toDouble(),
                            counterItemLength:
                                state
                                    // ignore: lines_longer_than_80_chars
                                    .getAlreadyCatchMegaEvolutionsPokemonLength()
                                    .toDouble(),
                          ),
                    );
                  },
                  child: HomeCircularProgressWidget(
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
                ),
                GestureDetector(
                  onTap: () async {
                    await showDialog<void>(
                      context: context,
                      builder:
                          (BuildContext context) => ZygardeCellsModal(
                            zygardeCells: state.zygardeCells!,
                          ),
                    );
                  },
                  onLongPress: () {
                    CustomNavigator().push(context, const ZygardeDetails());
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
