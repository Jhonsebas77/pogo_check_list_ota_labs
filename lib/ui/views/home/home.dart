part of com.pogo_check_list_ota_labs.app.views;

class HomePoGoView extends StatelessWidget {
  const HomePoGoView({super.key});
  static const String route = '/home';

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Consumer<FirebaseProvider>(
          builder: (
            BuildContext context,
            FirebaseProvider provider,
            Widget? child,
          ) {
            if (provider.isLoading) {
              return Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              );
            } else if (provider.allPokemon.isEmpty) {
              return const EmptyState();
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Builder(
                    builder: (BuildContext context) {
                      List<PokemonModel> _allPokemon =
                          provider.allPokemon
                              .where(
                                (PokemonModel pokemon) => pokemon.available,
                              )
                              .toList();
                      List<PokemonModel> _allShinyPokemon =
                          provider.allPokemon
                              .where(
                                (PokemonModel pokemon) =>
                                    pokemon.shinyAvailable,
                              )
                              .toList();
                      List<PokemonModel> _catchPokemon =
                          provider.allPokemon
                              .where(
                                (PokemonModel pokemon) => pokemon.alreadyCatch,
                              )
                              .toList();
                      List<PokemonModel> _catchShinyPokemon =
                          provider.allPokemon
                              .where(
                                (PokemonModel pokemon) =>
                                    pokemon.alreadyCatchShinyVersion,
                              )
                              .toList();
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: SizedBox(
                              height: 100,
                              width: 100,
                              child: CircularPercentIndicator(
                                radius: 28,
                                lineWidth: 6,
                                percent:
                                    _catchPokemon.length.toDouble() /
                                    _allPokemon.length.toDouble(),
                                backgroundColor: Colors.black45,
                                progressColor: Colors.white,
                                circularStrokeCap: CircularStrokeCap.square,
                                center: const Icon(
                                  Icons.catching_pokemon,
                                  color: Colors.white,
                                ),
                                footer: Text(
                                  '''${(_catchPokemon.length.toDouble() / _allPokemon.length.toDouble() * 100).floor()}%''',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            padding: const EdgeInsets.only(
                              left: 12,
                              top: 8,
                              bottom: 8,
                              right: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: SizedBox(
                              height: 100,
                              width: 100,
                              child: CircularPercentIndicator(
                                radius: 28,
                                lineWidth: 6,
                                percent:
                                    _catchShinyPokemon.length.toDouble() /
                                    _allShinyPokemon.length.toDouble(),
                                backgroundColor: Colors.black45,
                                progressColor: Colors.white,
                                circularStrokeCap: CircularStrokeCap.square,
                                center: const Text(
                                  '✨',
                                  textAlign: TextAlign.start,
                                ),
                                footer: Text(
                                  '''${(_catchShinyPokemon.length.toDouble() / _allShinyPokemon.length.toDouble() * 100).floor()}%''',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ),
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
      ),
      const HomeMenuItem(
        image: 'assets/Icon_Pokedex.png',
        label: 'Pokédex',
        viewToNavigate: AllPokemonAvailableView(),
      ),
      const HomeMenuItem(
        image: 'assets/Icon_Pokedex.png',
        label: 'Shiny Pokédex',
        viewToNavigate: ShinyPokemonView(),
      ),
    ],
  );
}
