part of com.pogo_check_list_ota_labs.app.widgets;

class PokemonDetailShimmer extends StatelessWidget {
  const PokemonDetailShimmer({super.key});

  Widget _block({required double height, double? width, double radius = 12}) =>
      ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Container(width: width, height: height, color: Colors.white),
      );

  @override
  Widget build(BuildContext context) => Shimmer.fromColors(
    baseColor: Colors.white24,
    highlightColor: Colors.white54,
    child: SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        children: <Widget>[
          _block(width: 180, height: 180, radius: 90),
          const SizedBox(height: 16),
          _block(width: 60, height: 16),
          const SizedBox(height: 8),
          _block(width: 180, height: 32),
          const SizedBox(height: 16),
          _block(width: 200, height: 36, radius: 18),
          const SizedBox(height: 24),
          Row(
            children: <Widget>[
              Expanded(child: _block(height: 100)),
              const SizedBox(width: 12),
              Expanded(child: _block(height: 100)),
              const SizedBox(width: 12),
              Expanded(child: _block(height: 100)),
            ],
          ),
          const SizedBox(height: 16),
          _block(height: 110),
          const SizedBox(height: 16),
          _block(height: 240),
        ],
      ),
    ),
  );
}
