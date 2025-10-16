part of com.pogo_check_list_ota_labs.app.models;

class PokemonTradeItem {
  PokemonTradeItem({
    this.id,
    this.name,
    this.quantity = 1,
    this.haveSpecialBackground = false,
    this.haveAdventureEffect = false,
    this.isLucky = false,
    this.isShiny = false,
    this.isMirrorChange = false,
    this.isDynamax = false,
    this.isGigantamax = false,
    this.alreadyCaught = false,
  });

  factory PokemonTradeItem.fromJson(Map<String, dynamic> json) =>
      PokemonTradeItem(
        alreadyCaught:
            json['already_caught'] != null && json['already_caught'] as bool,
        haveAdventureEffect:
            json['want_adventure_effect'] != null &&
            json['want_adventure_effect'] as bool,
        haveSpecialBackground:
            json['want_special_background'] != null &&
            json['want_special_background'] as bool,
        id: json['id'] != null ? json['id'] as int : 0,
        quantity: json['quantity'] != null ? json['quantity'] as int : 0,
        isDynamax: json['want_dynamax'] != null && json['want_dynamax'] as bool,
        isGigantamax:
            json['want_gigantamax'] != null && json['want_gigantamax'] as bool,
        isMirrorChange:
            json['want_mirror_change'] != null &&
            json['want_mirror_change'] as bool,
        isLucky: json['want_lucky'] != null && json['want_lucky'] as bool,
        isShiny: json['want_shiny'] != null && json['want_shiny'] as bool,
        name: json['name'] != null ? json['name'] as String : '',
      );
  final bool? alreadyCaught;
  final bool? haveAdventureEffect;
  final bool? haveSpecialBackground;
  final bool? isDynamax;
  final bool? isGigantamax;
  final bool? isLucky;
  final bool? isMirrorChange;
  final bool? isShiny;
  final int? id;
  final int? quantity;
  final String? name;

  @override
  String toString() => '''PokemonTradeItem(
    'name': $name,
    'id':  $id,
    'quantity':  $quantity,
    'isShiny':  $isShiny
  )''';
}
