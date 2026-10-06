part of com.pogo_check_list_ota_labs.app.views;

class PokedexView extends StatelessWidget {
  const PokedexView({super.key});
  static const String route = '/pokedex';

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    controller: ScrollController(),
    child: const Column(
      children: <HomeMenuItem>[
        HomeMenuItem(
          image: 'assets/icon_pokedex.png',
          label: 'Pokédex',
          viewToNavigate: AllPokemonAvailableView(),
          routeName: AllPokemonAvailableView.route,
        ),
        HomeMenuItem(
          image: 'assets/icon_pokedex.png',
          label: 'Shiny Pokédex',
          viewToNavigate: ShinyPokemonView(),
          routeName: ShinyPokemonView.route,
        ),
        HomeMenuItem(
          image: 'assets/icon_gigantamax.png',
          label: 'Gigantamax',
          viewToNavigate: GigantamaxPokemonView(),
          routeName: GigantamaxPokemonView.route,
        ),
        HomeMenuItem(
          image: 'assets/icon_mega.png',
          label: 'Mega evolutions',
          viewToNavigate: MegaEvolutionPokemonView(),
          routeName: MegaEvolutionPokemonView.route,
        ),
      ],
    ),
  );
}
