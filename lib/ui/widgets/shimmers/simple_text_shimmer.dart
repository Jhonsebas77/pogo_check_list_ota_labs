part of com.pogo_check_list_ota_labs.app.widgets;

class SimpleTextShimmer extends StatelessWidget {
  const SimpleTextShimmer({
    this.widthShimmer = 100,
    this.heightShimmer = 8,
    super.key,
  });
  final double? widthShimmer;
  final double? heightShimmer;
  @override
  Widget build(BuildContext context) => Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: widthShimmer,
        height: heightShimmer,
        color: Colors.white,
      ),
    ),
  );
}
