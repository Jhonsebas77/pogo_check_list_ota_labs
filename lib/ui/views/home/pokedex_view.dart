part of com.pogo_check_list_ota_labs.app.views;

class PokedexView extends StatelessWidget {
  const PokedexView({super.key});

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    controller: ScrollController(),
    child: const Column(
      children: <HomeMenuItem>[
        HomeMenuItem(
          image: 'assets/icon_pokedex.png',
          label: 'Pokédex',
          viewToNavigate: AllPokemonAvailableView(),
        ),
        HomeMenuItem(
          image: 'assets/icon_pokedex.png',
          label: 'Shiny Pokédex',
          viewToNavigate: ShinyPokemonView(),
        ),
        HomeMenuItem(
          image: 'assets/icon_gigantamax.png',
          label: 'Gigantamax',
          viewToNavigate: GigantamaxPokemonView(),
        ),
        HomeMenuItem(
          image: 'assets/icon_mega.png',
          label: 'Mega evolutions',
          viewToNavigate: MegaEvolutionPokemonView(),
        ),
      ],
    ),
  );
}
