part of com.pogo_check_list_ota_labs.app.widgets;

class InformationTradeCard extends StatelessWidget {
  const InformationTradeCard({super.key});

  @override
  Widget build(BuildContext context) => Column(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      const Text(
        'Información',
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
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
                  const Text('Shiny', style: TextStyle(color: Colors.white)),
                ],
              ),
              Row(
                children: <Widget>[
                  Image.asset('assets/icon_dinamax.png', height: 40, width: 40),
                  const SizedBox(width: 4),
                  const Text('Dynamax', style: TextStyle(color: Colors.white)),
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
                  Image.asset('assets/icon_gigamax.png', height: 40, width: 40),
                  const SizedBox(width: 4),
                  const Text('Gigamax', style: TextStyle(color: Colors.white)),
                ],
              ),
              const Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Color.fromRGBO(52, 177, 198, 1),
                    child: Icon(
                      Icons.safety_divider_sharp,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 4),
                  Text('Espejo', style: TextStyle(color: Colors.white)),
                ],
              ),
              const Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.catching_pokemon, color: Colors.red),
                  ),
                  SizedBox(width: 4),
                  Text('Disponibles', style: TextStyle(color: Colors.white)),
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

class InformationListTradeCard extends StatelessWidget {
  const InformationListTradeCard({super.key});
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.only(
        left: screenWidth * 0.1,
        right: screenWidth * 0.1,
      ),
      child: GridView.count(
        physics: const BouncingScrollPhysics(),
        crossAxisCount: 4,
        shrinkWrap: true,
        crossAxisSpacing: 2,
        mainAxisSpacing: 8,
        childAspectRatio: ((MediaQuery.of(context).size.width - 64) / 2) / 64,
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
              Image.asset('assets/icon_dinamax.png', height: 40, width: 40),
              const SizedBox(width: 4),
              const Text('Dynamax', style: TextStyle(color: Colors.white)),
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
          Row(
            children: <Widget>[
              Image.asset('assets/icon_lucky.png', height: 40, width: 40),
              const SizedBox(width: 4),
              const Text('Suerte', style: TextStyle(color: Colors.white)),
            ],
          ),
          Row(
            children: <Widget>[
              Image.asset('assets/icon_gigamax.png', height: 40, width: 40),
              const SizedBox(width: 4),
              const Text('Gigamax', style: TextStyle(color: Colors.white)),
            ],
          ),
          const Row(
            children: <Widget>[
              CircleAvatar(
                backgroundColor: Color.fromRGBO(52, 177, 198, 1),
                child: Icon(Icons.safety_divider_sharp, color: Colors.white),
              ),
              SizedBox(width: 4),
              Text('Espejo', style: TextStyle(color: Colors.white)),
            ],
          ),
          const Row(
            children: <Widget>[
              CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.catching_pokemon, color: Colors.red),
              ),
              SizedBox(width: 4),
              Text('Disponibles', style: TextStyle(color: Colors.white)),
            ],
          ),
        ],
      ),
    );
  }
}
