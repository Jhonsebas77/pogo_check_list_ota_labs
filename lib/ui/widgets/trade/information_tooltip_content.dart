part of com.pogo_check_list_ota_labs.app.widgets;

class InformationTradeCard extends StatelessWidget {
  const InformationTradeCard({super.key});

  @override
  Widget build(BuildContext context) => Container(
    constraints: const BoxConstraints(maxWidth: 300),
    padding: const EdgeInsets.all(8),
    child: Column(
      spacing: 8,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        const Text(
          'Información',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              spacing: 8,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Image.asset('assets/icon_shiny.png', height: 40, width: 40),
                    const SizedBox(width: 4),
                    const Text('Shiny', style: TextStyle(color: Colors.white)),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Image.asset(
                      'assets/icon_dinamax.png',
                      height: 40,
                      width: 40,
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'Dynamax',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Image.asset(
                      'assets/icon_special_background.png',
                      height: 40,
                      width: 40,
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'Fondo especial',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              spacing: 8,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Image.asset('assets/icon_lucky.png', height: 40, width: 40),
                    const SizedBox(width: 4),
                    const Text('Suerte', style: TextStyle(color: Colors.white)),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Image.asset(
                      'assets/icon_gigamax.png',
                      height: 40,
                      width: 40,
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'Gigamax',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                const Row(
                  children: <Widget>[
                    CircleAvatar(
                      backgroundColor: Color(0xFFA0E1FF),
                      child: Icon(
                        Icons.safety_divider_sharp,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 4),
                    Text('Espejo', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ],
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Image.asset(
              'assets/icon_adventure_effect.png',
              height: 40,
              width: 40,
            ),
            const SizedBox(width: 4),
            const Text(
              'Efecto aventura',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ],
    ),
  );
}
