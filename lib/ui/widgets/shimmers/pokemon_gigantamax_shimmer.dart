part of com.pogo_check_list_ota_labs.app.widgets;

class PokemonGigantamaxListShimmer extends StatelessWidget {
  const PokemonGigantamaxListShimmer({super.key});

  @override
  Widget build(BuildContext context) => GridView.count(
    crossAxisCount: 3,
    children: List<TileShimmerGigantamax>.generate(
      12,
      (int _) => const TileShimmerGigantamax(),
    ),
  );
}

class TileShimmerGigantamax extends StatelessWidget {
  const TileShimmerGigantamax({super.key});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
    child: Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        padding: const EdgeInsets.only(left: 12, top: 8, bottom: 8, right: 12),
        decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/bg_holder_pokemon.png',
              height: 80,
              width: 80,
              fit: BoxFit.fill,
            ),
            const SizedBox(width: 16),
            Column(
              children: <Widget>[
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(width: 100, height: 20, color: Colors.white),
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(width: 50, height: 16, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
