part of com.pogo_check_list_ota_labs.app.widgets;

class InformationTradeCard extends StatelessWidget {
  const InformationTradeCard({super.key});

  @override
  Widget build(BuildContext context) => Column(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Text(
        'Información',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onPrimaryContainer,
        ),
      ),
      const SizedBox(height: 12),
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
                  Text(
                    'Shiny',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Image.asset('assets/icon_dinamax.png', height: 40, width: 40),
                  const SizedBox(width: 4),
                  Text(
                    'Dynamax',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
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
                  Text(
                    'Fondo especial',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
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
                  Text(
                    'Efecto aventura',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
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
                  Text(
                    'Suerte',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Image.asset('assets/icon_gigamax.png', height: 40, width: 40),
                  const SizedBox(width: 4),
                  Text(
                    'Gigamax',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  const CircleAvatar(
                    backgroundColor: Color.fromRGBO(52, 177, 198, 1),
                    child: Icon(
                      Icons.safety_divider_sharp,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Espejo',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.catching_pokemon, color: Colors.red),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Disponibles',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      const SizedBox(height: 12),
    ],
  );
}
