part of com.pogo_check_list_ota_labs.app.widgets;

class DashboardOverview extends ConsumerWidget {
  const DashboardOverview({super.key});

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
                HomeCircularWidget(
                  allItemLength: state.getTotalPokemonLength().toDouble(),
                  counterItemLength:
                      state.getAlreadyCatchPokemonLength().toDouble(),
                  centerWidget: const Icon(
                    Icons.catching_pokemon,
                    color: Colors.white,
                  ),
                ),
                HomeCircularWidget(
                  allItemLength:
                      state.getShinyAvailablePokemonLength().toDouble(),
                  counterItemLength:
                      state.getAlreadyCatchPokemonShinyLength().toDouble(),
                  centerWidget: const Text('✨', textAlign: TextAlign.start),
                ),
                HomeCircularWidget(
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
                HomeCircularWidget(
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
              ],
            ),
        error:
            (Object error, StackTrace stackTrace) =>
                Center(child: Text('Error: $error')),
        loading: DashboardOverviewShimmer.new,
      ),
    );
  }
}
