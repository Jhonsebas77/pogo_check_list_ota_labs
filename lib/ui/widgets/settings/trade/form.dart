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

  @override
  String toString() => '''PokemonTradeItemFormData -> 
  $alreadyCaught;
  $haveAdventureEffect;
  $haveSpecialBackground;
  $isDynamax;
  $isGigantamax;
  $isLucky;
  $isMirrorChange;
  $isShiny;
''';

  void dispose() {
    idController.dispose();
    nameController.dispose();
    quantityController.dispose();
  }
}
