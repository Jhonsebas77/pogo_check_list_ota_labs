part of com.pogo_check_list_ota_labs.app.widgets;

class PokemonTradeItemEditor extends ConsumerStatefulWidget {
  const PokemonTradeItemEditor({
    required this.data,
    required this.title,
    this.onRemove,
    super.key,
  });

  final PokemonTradeItemFormData data;
  final String title;
  final VoidCallback? onRemove;

  @override
  ConsumerState<PokemonTradeItemEditor> createState() =>
      _PokemonTradeItemEditorState();
}

class _PokemonTradeItemEditorState
    extends ConsumerState<PokemonTradeItemEditor> {
  @override
  Widget build(BuildContext context) {
    int _pokemonId = int.tryParse(widget.data.idController.text) ?? 0;
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).colorScheme.primary,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              widget.title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: <Widget>[
                Stack(
                  alignment: AlignmentGeometry.center,
                  children: <Widget>[
                    Image.asset(
                      'assets/bg_holder_pokemon.png',
                      height: 80,
                      width: 80,
                      fit: BoxFit.fill,
                    ),
                    if (widget.data.isShiny)
                      Image.asset(
                        'assets/pokedex_sprites_shiny/$_pokemonId.png',
                        height: 80,
                        width: 80,
                        errorBuilder:
                            (
                              BuildContext context,
                              Object error,
                              StackTrace? stackTrace,
                            ) => const SizedBox(height: 80, width: 80),
                      )
                    else
                      Image.asset(
                        'assets/pokedex_sprites/$_pokemonId.png',
                        height: 80,
                        width: 80,
                        errorBuilder:
                            (
                              BuildContext context,
                              Object error,
                              StackTrace? stackTrace,
                            ) => const SizedBox(height: 80, width: 80),
                      ),
                  ],
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: PokemonSelector(
                    selectedPokemonId: _pokemonId == 0 ? null : _pokemonId,
                    label: 'Seleccionar Pokémon',
                    onChanged: (int? newId) {
                      if (newId != null) {
                        setState(() {
                          widget.data.idController.text = newId.toString();
                          // Find name
                          List<PokemonModel> allPokemon =
                              ref
                                  .read(firebasePokemonProvider)
                                  .valueOrNull
                                  ?.allPokemon ??
                              <PokemonModel>[];
                          try {
                            PokemonModel pokemon = allPokemon.firstWhere(
                              (PokemonModel p) => p.id == newId,
                            );
                            widget.data.nameController.text = pokemon.name;
                          } catch (_) {}
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (widget.title == 'Pokémon ofrecido')
              TextFormField(
                controller: widget.data.quantityController,
                keyboardType: TextInputType.number,
                decoration: inputDecoration(
                  context,
                  label: 'Cantidad',
                  icon: Icons.numbers,
                ),
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Ingresa la cantidad';
                  }
                  int? parsed = int.tryParse(value.trim());
                  if (parsed == null || parsed <= 0) {
                    return 'Cantidad no válida';
                  }
                  return null;
                },
              ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: <Widget>[
                _buildToggleChip(
                  context,
                  label: 'Shiny',
                  value: widget.data.isShiny,
                  pokemonCriteria: BadgePokemonCriteria.shiny,
                  onChanged:
                      (bool value) =>
                          setState(() => widget.data.isShiny = value),
                ),
                _buildToggleChip(
                  context,
                  label: 'Lucky',
                  value: widget.data.isLucky,
                  pokemonCriteria: BadgePokemonCriteria.lucky,
                  onChanged:
                      (bool value) =>
                          setState(() => widget.data.isLucky = value),
                ),
                _buildToggleChip(
                  context,
                  label: 'Fondo especial',
                  value: widget.data.haveSpecialBackground,
                  pokemonCriteria: BadgePokemonCriteria.specialBackground,
                  onChanged:
                      (bool value) => setState(
                        () => widget.data.haveSpecialBackground = value,
                      ),
                ),
                _buildToggleChip(
                  context,
                  label: 'Adventure effect',
                  value: widget.data.haveAdventureEffect,
                  pokemonCriteria: BadgePokemonCriteria.adventureEffect,
                  onChanged:
                      (bool value) => setState(
                        () => widget.data.haveAdventureEffect = value,
                      ),
                ),
                _buildToggleChip(
                  context,
                  label: 'Ya atrapado',
                  value: widget.data.alreadyCaught,
                  pokemonCriteria: BadgePokemonCriteria.alreadyCaught,
                  onChanged:
                      (bool value) =>
                          setState(() => widget.data.alreadyCaught = value),
                ),
                _buildToggleChip(
                  context,
                  label: 'Dinamax',
                  value: widget.data.isDynamax,
                  pokemonCriteria: BadgePokemonCriteria.dynamax,
                  onChanged:
                      (bool value) =>
                          setState(() => widget.data.isDynamax = value),
                ),
                _buildToggleChip(
                  context,
                  label: 'Gigamax',
                  value: widget.data.isGigantamax,
                  pokemonCriteria: BadgePokemonCriteria.gigantamax,
                  onChanged:
                      (bool value) =>
                          setState(() => widget.data.isGigantamax = value),
                ),
                _buildToggleChip(
                  context,
                  label: 'Cambio espejo',
                  value: widget.data.isMirrorChange,
                  pokemonCriteria: BadgePokemonCriteria.mirrorChange,
                  onChanged:
                      (bool value) =>
                          setState(() => widget.data.isMirrorChange = value),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget getAvatarIcon(BadgePokemonCriteria pokemonCriteria) {
    switch (pokemonCriteria) {
      case BadgePokemonCriteria.adventureEffect:
        return Image.asset(
          'assets/icon_adventure_effect.png',
          height: 40,
          width: 40,
        );
      case BadgePokemonCriteria.shiny:
        return Image.asset('assets/icon_shiny.png', height: 40, width: 40);
      case BadgePokemonCriteria.dynamax:
        return Image.asset('assets/icon_dinamax.png', height: 40, width: 40);
      case BadgePokemonCriteria.gigantamax:
        return Image.asset('assets/icon_gigamax.png', height: 40, width: 40);
      case BadgePokemonCriteria.lucky:
        return Image.asset('assets/icon_lucky.png', height: 40, width: 40);
      case BadgePokemonCriteria.alreadyCaught:
        return const Icon(
          Icons.catching_pokemon,
          color: Colors.white,
          size: 18,
        );
      case BadgePokemonCriteria.mirrorChange:
        return const CircleAvatar(
          backgroundColor: Color.fromRGBO(52, 177, 198, 1),
          child: Icon(Icons.safety_divider_sharp, color: Colors.white),
        );
      case BadgePokemonCriteria.specialBackground:
        return Image.asset(
          'assets/icon_special_background.png',
          height: 40,
          width: 40,
        );
    }
  }

  Widget _buildToggleChip(
    BuildContext context, {
    required String label,
    required bool value,
    required BadgePokemonCriteria pokemonCriteria,
    required ValueChanged<bool> onChanged,
  }) => FilterChip(
    selected: value,
    backgroundColor: Colors.white12,
    selectedColor: Theme.of(context).colorScheme.secondary,
    label: Text(label, style: const TextStyle(color: Colors.white)),
    onSelected: onChanged,
    avatar: getAvatarIcon(pokemonCriteria),
  );
}
