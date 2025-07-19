part of com.pogo_check_list_ota_labs.app.widgets;

class HeaderFromImage extends StatelessWidget {
  const HeaderFromImage({this.title, super.key});
  final String? title;
  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      Container(
        height: 70,
        color: const Color.fromRGBO(198, 73, 52, 1),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            // Container(
            //   width: 50,
            //   height: 50,
            //   decoration: BoxDecoration(
            //     color: const Color(0xFF5A79C8),
            //     shape: BoxShape.circle,
            //     border: Border.all(color: Colors.white, width: 4),
            //   ),
            // ),
            if (title != null && title!.isNotEmpty)
              Text(
                title!,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            // Row(
            //   children: <Widget>[
            //     _buildSmallCircle(const Color(0xFFA02C2D)),
            //     const SizedBox(width: 8),
            //     _buildSmallCircle(const Color(0xFFDDC35B)),
            //     const SizedBox(width: 8),
            //     _buildSmallCircle(const Color(0xFF78B47C)),
            //   ],
            // ),
          ],
        ),
      ),
    ],
  );

  Widget _buildSmallCircle(Color color) => Container(
    width: 22,
    height: 22,
    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
  );
}
