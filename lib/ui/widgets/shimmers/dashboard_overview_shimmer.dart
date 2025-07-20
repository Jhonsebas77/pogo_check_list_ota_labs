part of com.pogo_check_list_ota_labs.app.widgets;

class DashboardOverviewShimmer extends StatelessWidget {
  const DashboardOverviewShimmer({super.key});
  @override
  Widget build(BuildContext context) => const Wrap(
    spacing: 12,
    runSpacing: 12,
    children: <Widget>[TileItemShimmer(), TileItemShimmer(), TileItemShimmer()],
  );
}

class TileItemShimmer extends StatelessWidget {
  const TileItemShimmer({super.key});

  @override
  Widget build(BuildContext context) => Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: Container(
      padding: const EdgeInsets.only(left: 12, top: 8, bottom: 8, right: 12),
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
          percent: 0,
          backgroundColor: Colors.black45,
          progressColor: Colors.white,
          circularStrokeCap: CircularStrokeCap.square,
          footer: Padding(
            padding: const EdgeInsets.all(8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(width: 100, height: 16, color: Colors.white),
            ),
          ),
        ),
      ),
    ),
  );
}
