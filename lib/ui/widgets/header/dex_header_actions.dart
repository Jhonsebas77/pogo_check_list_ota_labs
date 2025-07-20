part of com.pogo_check_list_ota_labs.app.widgets;

class DexHeaderActions extends StatelessWidget {
  const DexHeaderActions({super.key});
  
  Widget _buildSmallCircle(Color color) => Container(
    width: 22,
    height: 22,
    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
  );

  List<Widget> getActions() => <Widget>[
    _buildSmallCircle(const Color(0xFFA02C2D)),
    const SizedBox(width: 8),
    _buildSmallCircle(const Color(0xFFDDC35B)),
    const SizedBox(width: 8),
    _buildSmallCircle(const Color(0xFF78B47C)),
    const SizedBox(width: 16),
  ];

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError(
      'This widget is not meant to be built directly. Use getActions().',
    );
  }
}
