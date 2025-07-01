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
              return const LoadingWidget();
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
                      List<PokemonModel> _allGigantamaxPokemon =
                          provider.allGigantamaxPokemon
                              .where(
                                (PokemonModel pokemon) => pokemon.available,
                              )
                              .toList();
                      List<PokemonModel> _catchGigantamaxPokemon =
                          provider.allGigantamaxPokemon
                              .where(
                                (PokemonModel pokemon) => pokemon.alreadyCatch,
                              )
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
                            counterItemLength:
                                _catchShinyPokemon.length.toDouble(),
                            centerWidget: const Text(
                              '✨',
                              textAlign: TextAlign.start,
                            ),
                          ),
                          HomeCircularWidget(
                            allItemLength:
                                _allGigantamaxPokemon.length.toDouble(),
                            counterItemLength:
                                _catchGigantamaxPokemon.length.toDouble(),
                            centerWidget: Image.asset(
                              'assets/Gigamax.png',
                              height: 30,
                              width: 30,
                              fit: BoxFit.fill,
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
      const HomeMenuItem(
        image: 'assets/Icon_Gigantamax.png',
        label: 'Gigantamax',
        viewToNavigate: GigantamaxPokemonView(),
      ),
    ],
  );
}
