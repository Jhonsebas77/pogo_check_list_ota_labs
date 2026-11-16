part of '../../widgets.dart';

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
                    backgroundColor: secondaryColor,
                    child: Icon(
                      Icons.safety_divider_sharp,
                      color: onLightAccent,
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
          _LegendItem(
            icon: Image.asset('assets/icon_shiny.png', height: 24, width: 24),
            label: 'Shiny',
          ),
          _LegendItem(
            icon: Image.asset('assets/icon_dinamax.png', height: 24, width: 24),
            label: 'Dynamax',
          ),
          _LegendItem(
            icon: Image.asset(
              'assets/icon_special_background.png',
              height: 24,
              width: 24,
            ),
            label: 'Fondo especial',
          ),
          _LegendItem(
            icon: Image.asset(
              'assets/icon_adventure_effect.png',
              height: 24,
              width: 24,
            ),
            label: 'Efecto aventura',
          ),
          _LegendItem(
            icon: Image.asset('assets/icon_lucky.png', height: 24, width: 24),
            label: 'Suerte',
          ),
          _LegendItem(
            icon: Image.asset('assets/icon_gigamax.png', height: 24, width: 24),
            label: 'Gigamax',
          ),
          const _LegendItem(
            icon: CircleAvatar(
              radius: 12,
              backgroundColor: secondaryColor,
              child: Icon(
                Icons.safety_divider_sharp,
                color: onLightAccent,
                size: 16,
              ),
            ),
            label: 'Espejo',
          ),
          const _LegendItem(
            icon: CircleAvatar(
              radius: 12,
              backgroundColor: Colors.white,
              child: Icon(Icons.catching_pokemon, color: Colors.red, size: 16),
            ),
            label: 'Disponibles',
          ),
        ],
      ),
    );
  }
}

/// Celda de la leyenda: ícono + etiqueta que se recorta con elipsis si la
/// celda del grid es más angosta que el texto.
class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.icon, required this.label});

  final Widget icon;
  final String label;

  @override
  Widget build(BuildContext context) => Row(
    children: <Widget>[
      icon,
      const SizedBox(width: 4),
      Flexible(
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    ],
  );
}
