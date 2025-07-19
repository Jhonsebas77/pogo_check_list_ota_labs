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
        data: (PokemonFirebaseState state) {
          List<PokemonModel> _allPokemon =
              state.allPokemon
                  .where((PokemonModel pokemon) => pokemon.available)
                  .toList();
          List<PokemonModel> _allShinyPokemon =
              state.allPokemon
                  .where((PokemonModel pokemon) => pokemon.shinyAvailable)
                  .toList();
          List<PokemonModel> _catchPokemon =
              state.allPokemon
                  .where((PokemonModel pokemon) => pokemon.alreadyCatch)
                  .toList();
          List<PokemonModel> _catchShinyPokemon =
              state.allPokemon
                  .where(
                    (PokemonModel pokemon) => pokemon.alreadyCatchShinyVersion,
                  )
                  .toList();
          List<PokemonModel> _allGigantamaxPokemon = state.allGigantamaxPokemon;
          List<PokemonModel> _catchGigantamaxPokemon =
              state.allGigantamaxPokemon
                  .where((PokemonModel pokemon) => pokemon.alreadyCatch)
                  .toList();
          return Wrap(
            spacing: 12,
            runSpacing: 12,
            children: <Widget>[
              HomeCircularWidget(
                allItemLength: _allPokemon.length.toDouble(),
                counterItemLength: _catchPokemon.length.toDouble(),
                centerWidget: const Icon(
                  Icons.catching_pokemon,
                  color: Colors.white,
                ),
              ),
              HomeCircularWidget(
                allItemLength: _allShinyPokemon.length.toDouble(),
                counterItemLength: _catchShinyPokemon.length.toDouble(),
                centerWidget: const Text('✨', textAlign: TextAlign.start),
              ),
              HomeCircularWidget(
                allItemLength: _allGigantamaxPokemon.length.toDouble(),
                counterItemLength: _catchGigantamaxPokemon.length.toDouble(),
                centerWidget: Image.asset(
                  'assets/gigamax.png',
                  height: 30,
                  width: 30,
                  fit: BoxFit.fill,
                ),
              ),
            ],
          );
        },
        error:
            (Object error, StackTrace stackTrace) =>
                Center(child: Text('Error: $error')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
