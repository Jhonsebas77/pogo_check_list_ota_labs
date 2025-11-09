part of com.pogo_check_list_ota_labs.app.widgets;

class PokemonTradeItemFormData {
  PokemonTradeItemFormData({
    int? id,
    String? name,
    int? quantity,
    bool? alreadyCaught,
    bool? haveAdventureEffect,
    bool? haveSpecialBackground,
    bool? isDynamax,
    bool? isGigantamax,
    bool? isLucky,
    bool? isMirrorChange,
    bool? isShiny,
  }) : idController = TextEditingController(
         text: id != null && id > 0 ? id.toString() : '',
       ),
       nameController = TextEditingController(text: name ?? ''),
       quantityController = TextEditingController(
         text: (quantity != null && quantity > 0 ? quantity : 1).toString(),
       ),
       alreadyCaught = alreadyCaught ?? false,
       haveAdventureEffect = haveAdventureEffect ?? false,
       haveSpecialBackground = haveSpecialBackground ?? false,
       isDynamax = isDynamax ?? false,
       isGigantamax = isGigantamax ?? false,
       isLucky = isLucky ?? false,
       isMirrorChange = isMirrorChange ?? false,
       isShiny = isShiny ?? false;

  factory PokemonTradeItemFormData.fromTradeItem(PokemonTradeItem item) =>
      PokemonTradeItemFormData(
        id: item.id,
        name: item.name,
        quantity: item.quantity,
        alreadyCaught: item.alreadyCaught,
        haveAdventureEffect: item.haveAdventureEffect,
        haveSpecialBackground: item.haveSpecialBackground,
        isDynamax: item.isDynamax,
        isGigantamax: item.isGigantamax,
        isLucky: item.isLucky,
        isMirrorChange: item.isMirrorChange,
        isShiny: item.isShiny,
      );

  final TextEditingController idController;
  final TextEditingController nameController;
  final TextEditingController quantityController;
  bool alreadyCaught;
  bool haveAdventureEffect;
  bool haveSpecialBackground;
  bool isDynamax;
  bool isGigantamax;
  bool isLucky;
  bool isMirrorChange;
  bool isShiny;

  PokemonTradeItem? buildPokemonTradeItem() {
    String idText = idController.text.trim();
    String nameText = nameController.text.trim();
    int? id = int.tryParse(idText);
    if ((id == null || id <= 0) && nameText.isEmpty) {
      return null;
    }
    int quantity = int.tryParse(quantityController.text.trim()) ?? 1;
    if (quantity <= 0) {
      quantity = 1;
    }
    return PokemonTradeItem(
      id: id ?? 0,
      name: nameText.isNotEmpty ? nameText : null,
      quantity: quantity,
      alreadyCaught: alreadyCaught,
      haveAdventureEffect: haveAdventureEffect,
      haveSpecialBackground: haveSpecialBackground,
      isDynamax: isDynamax,
      isGigantamax: isGigantamax,
      isLucky: isLucky,
      isMirrorChange: isMirrorChange,
      isShiny: isShiny,
    );
  }

  void dispose() {
    idController.dispose();
    nameController.dispose();
    quantityController.dispose();
  }
}

class PokemonTradeItemEditor extends StatefulWidget {
  const PokemonTradeItemEditor({
    required this.data,
    required this.title,
    this.onRemove,
    this.showRemoveButton = false,
    super.key,
  });

  final PokemonTradeItemFormData data;
  final String title;
  final VoidCallback? onRemove;
  final bool showRemoveButton;

  @override
  State<PokemonTradeItemEditor> createState() => _PokemonTradeItemEditorState();
}

class _PokemonTradeItemEditorState extends State<PokemonTradeItemEditor> {
  @override
  Widget build(BuildContext context) => Card(
    color: Colors.black26,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    margin: const EdgeInsets.symmetric(vertical: 8),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  widget.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (widget.showRemoveButton)
                IconButton(
                  tooltip: 'Eliminar',
                  onPressed: widget.onRemove,
                  icon: const Icon(Icons.delete_forever, color: Colors.red),
                ),
            ],
          ),
          TextFormField(
            controller: widget.data.idController,
            keyboardType: TextInputType.number,
            decoration: inputDecoration(
              context,
              label: 'ID del Pokémon',
              icon: Icons.tag,
            ),
            validator: (String? value) {
              if (value == null || value.trim().isEmpty) {
                return null;
              }
              return int.tryParse(value.trim()) == null
                  ? 'Ingresa un ID válido'
                  : null;
            },
          ),
          TextFormField(
            controller: widget.data.nameController,
            decoration: inputDecoration(
              context,
              label: 'Nombre (opcional)',
              icon: Icons.badge_outlined,
            ),
          ),
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
                onChanged:
                    (bool value) => setState(() => widget.data.isShiny = value),
              ),
              _buildToggleChip(
                context,
                label: 'Lucky',
                value: widget.data.isLucky,
                onChanged:
                    (bool value) => setState(() => widget.data.isLucky = value),
              ),
              _buildToggleChip(
                context,
                label: 'Fondo especial',
                value: widget.data.haveSpecialBackground,
                onChanged:
                    (bool value) => setState(
                      () => widget.data.haveSpecialBackground = value,
                    ),
              ),
              _buildToggleChip(
                context,
                label: 'Adventure effect',
                value: widget.data.haveAdventureEffect,
                onChanged:
                    (bool value) =>
                        setState(() => widget.data.haveAdventureEffect = value),
              ),
              _buildToggleChip(
                context,
                label: 'Ya atrapado',
                value: widget.data.alreadyCaught,
                onChanged:
                    (bool value) =>
                        setState(() => widget.data.alreadyCaught = value),
              ),
              _buildToggleChip(
                context,
                label: 'Dinamax',
                value: widget.data.isDynamax,
                onChanged:
                    (bool value) =>
                        setState(() => widget.data.isDynamax = value),
              ),
              _buildToggleChip(
                context,
                label: 'Gigamax',
                value: widget.data.isGigantamax,
                onChanged:
                    (bool value) =>
                        setState(() => widget.data.isGigantamax = value),
              ),
              _buildToggleChip(
                context,
                label: 'Cambio sorpresa',
                value: widget.data.isMirrorChange,
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

  Widget _buildToggleChip(
    BuildContext context, {
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) => FilterChip(
    selected: value,
    backgroundColor: Colors.white12,
    selectedColor: Theme.of(context).colorScheme.secondary,
    label: Text(label, style: const TextStyle(color: Colors.white)),
    onSelected: onChanged,
  );
}
