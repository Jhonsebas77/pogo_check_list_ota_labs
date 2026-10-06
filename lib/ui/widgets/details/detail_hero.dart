part of com.pogo_check_list_ota_labs.app.widgets;

/// Encabezado del detalle: arte oficial (normal o shiny), número, nombre,
/// categoría y tipos.
class DetailHero extends StatefulWidget {
  const DetailHero({required this.pokemon, this.genus, super.key});

  final PokemonDetail pokemon;
  final String? genus;

  @override
  State<DetailHero> createState() => _DetailHeroState();
}

class _DetailHeroState extends State<DetailHero> {
  bool _showShiny = false;

  @override
  Widget build(BuildContext context) {
    PokemonDetail pokemon = widget.pokemon;
    String imageUrl =
        _showShiny && pokemon.shinyImageUrl != null
            ? pokemon.shinyImageUrl!
            : pokemon.imageUrl;
    return Column(
      children: <Widget>[
        Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Image.asset(
              'assets/bg_holder_pokemon.png',
              height: 180,
              width: 180,
              fit: BoxFit.fill,
            ),
            Hero(
              tag: pokemon.id,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: Image.network(
                  imageUrl,
                  key: ValueKey<String>(imageUrl),
                  height: 180,
                  width: 180,
                  fit: BoxFit.fill,
                  semanticLabel:
                      _showShiny ? '${pokemon.name} shiny' : pokemon.name,
                ),
              ),
            ),
          ],
        ),
        if (pokemon.shinyImageUrl != null) ...<Widget>[
          const SizedBox(height: 12),
          _ShinyToggle(
            showShiny: _showShiny,
            onChanged: (bool value) => setState(() => _showShiny = value),
          ),
        ],
        const SizedBox(height: 12),
        Text(
          paddingDexNumber(dexNumber: pokemon.id),
          style: Paragraphs.smallSemiBold.copyWith(color: onPrimaryMuted),
        ),
        if (widget.genus != null)
          Text(
            widget.genus!,
            style: Paragraphs.small.copyWith(color: onPrimaryMuted),
          ),
        const SizedBox(height: 12),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 12,
          runSpacing: 12,
          children:
              pokemon.types
                  .map((String type) => TypeImageBadge(type: type))
                  .toList(),
        ),
      ],
    );
  }
}

class _ShinyToggle extends StatelessWidget {
  const _ShinyToggle({required this.showShiny, required this.onChanged});

  final bool showShiny;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(4),
    decoration: BoxDecoration(
      color: Colors.black12,
      borderRadius: BorderRadius.circular(30),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _option('Normal', selected: !showShiny, value: false),
        _option('Shiny ✨', selected: showShiny, value: true),
      ],
    ),
  );

  Widget _option(String label, {required bool selected, required bool value}) =>
      Semantics(
        button: true,
        selected: selected,
        child: GestureDetector(
          onTap: () => onChanged(value),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: selected ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              label,
              style: Paragraphs.smallSemiBold.copyWith(
                color: selected ? primaryColor : Colors.white,
              ),
            ),
          ),
        ),
      );
}
