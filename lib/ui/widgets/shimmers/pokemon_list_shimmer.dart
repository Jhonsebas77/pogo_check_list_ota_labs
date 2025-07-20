part of com.pogo_check_list_ota_labs.app.widgets;

class PokemonListShimmer extends StatelessWidget {
  const PokemonListShimmer({super.key});

  @override
  Widget build(BuildContext context) => ListView.builder(
    itemCount: 11,
    itemBuilder:
        (BuildContext context, int index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Container(
            padding: const EdgeInsets.only(
              left: 12,
              top: 8,
              bottom: 8,
              right: 12,
            ),
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Shimmer.fromColors(
                        baseColor: Colors.white,
                        highlightColor: Colors.white,
                        child: Image.asset(
                          'assets/bg_holder_pokemon.png',
                          height: 50,
                          width: 50,
                          fit: BoxFit.fill,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              width: 30,
                              height: 10,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              width: 80,
                              height: 18,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(32),
                        child: const ColoredBox(
                          color: Colors.white,
                          child: SizedBox(height: 30, width: 30),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(32),
                        child: const ColoredBox(
                          color: Colors.white,
                          child: SizedBox(height: 30, width: 30),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(32),
                        child: const ColoredBox(
                          color: Colors.white,
                          child: SizedBox(height: 30, width: 30),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
  );
}
