part of com.pogo_check_list_ota_labs.app.views;

class HomePoGoView extends StatelessWidget {
  const HomePoGoView({super.key});
  static const String route = '/home';

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      const TrainerInformation(),
      SingleChildScrollView(
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
            // HomeMenuItem(
            //   image: 'assets/pokedex_sprites/201.png',
            //   label: 'Unown',
            //   viewToNavigate: AllPokemonAvailableView(),
            //   isAvailable: false,
            // ),
            // HomeMenuItem(
            //   image: 'assets/pokedex_sprites/666.png',
            //   label: 'Vivillon',
            //   viewToNavigate: AllPokemonAvailableView(),
            //   isAvailable: false,
            // ),
            // HomeMenuItem(
            //   image: 'assets/icon_pokedex.png',
            //   label: 'Mega evolutions',
            //   viewToNavigate: AllPokemonAvailableView(),
            //   isAvailable: false,
            // ),
          ],
        ),
      ),
      const DashboardOverview(),
    ],
  );
}
