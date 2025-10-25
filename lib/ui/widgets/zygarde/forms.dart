part of com.pogo_check_list_ota_labs.app.widgets;

class ZygardeForms extends StatelessWidget {
  const ZygardeForms({required this.zygardeCells, super.key});
  final ZygardeCells zygardeCells;

  String witchFormIsActive(ZygardeCells zygardeCells) {
    String previousForm = '';
    if (zygardeCells.actualForm ==
        zygardeCells.forms?[1].alternativeForm?.name) {
      previousForm = '10%-50%';
    }
    if (zygardeCells.actualForm ==
        zygardeCells.forms?[2].alternativeForm?.name) {
      previousForm = '10%-50%-100%';
    }
    return previousForm;
  }

  Widget buildForms(String previousForms) {
    switch (previousForms) {
      case '10%-50%':
        return Row(
          children: <Widget>[
            Image.asset(
              'assets/pokedex_sprites/718_10.png',
              height: 50,
              width: 50,
              fit: BoxFit.fill,
            ),
            Image.asset(
              'assets/pokedex_sprites/718_50.png',
              height: 50,
              width: 50,
              fit: BoxFit.fill,
            ),
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              enabled: false,
              child: Image.asset(
                'assets/pokedex_sprites/718_100.png',
                height: 50,
                width: 50,
                fit: BoxFit.fill,
              ),
            ),
          ],
        );
      case '10%-50%-100%':
        return Row(
          children: <Widget>[
            Image.asset(
              'assets/pokedex_sprites/718_10.png',
              height: 50,
              width: 50,
              fit: BoxFit.fill,
            ),
            Image.asset(
              'assets/pokedex_sprites/718_50.png',
              height: 50,
              width: 50,
              fit: BoxFit.fill,
            ),
            Image.asset(
              'assets/pokedex_sprites/718_100.png',
              height: 50,
              width: 50,
              fit: BoxFit.fill,
            ),
          ],
        );
      default:
        return Row(
          children: <Widget>[
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              enabled: false,
              child: Image.asset(
                'assets/pokedex_sprites/718_10.png',
                height: 50,
                width: 50,
                fit: BoxFit.fill,
              ),
            ),
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              enabled: false,
              child: Image.asset(
                'assets/pokedex_sprites/718_50.png',
                height: 50,
                width: 50,
                fit: BoxFit.fill,
              ),
            ),
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              enabled: false,
              child: Image.asset(
                'assets/pokedex_sprites/718_100.png',
                height: 50,
                width: 50,
                fit: BoxFit.fill,
              ),
            ),
          ],
        );
    }
  }

  @override
  Widget build(BuildContext context) => Card(
    color: Colors.black.withValues(alpha: 0.35),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[buildForms(witchFormIsActive(zygardeCells))],
      ),
    ),
  );
}
