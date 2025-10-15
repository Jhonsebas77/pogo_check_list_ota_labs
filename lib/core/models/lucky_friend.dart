part of com.pogo_check_list_ota_labs.app.models;

class LuckyFriend {
  const LuckyFriend({
    required this.name,
    this.pokemonWanted,
    this.pokemonOffer,
    this.contacted,
  });

  factory LuckyFriend.fromJson(Map<String, dynamic> json) => LuckyFriend(
    name: json['name'] != null ? json['name'] as String : '',
    pokemonWanted:
        json['pokemon_want'] != null
            ? PokemonTradeItem.fromJson(
              json['pokemon_want'] as Map<String, dynamic>,
            )
            : null,
    pokemonOffer:
        json['pokemon_offer'] != null
            ? PokemonTradeItem.fromJson(
              json['pokemon_offer'] as Map<String, dynamic>,
            )
            : null,
    contacted: json['contacted'] != null && json['contacted'] as bool,
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'name': name,
    'contacted': contacted,
  };

  final String name;
  final bool? contacted;
  final PokemonTradeItem? pokemonWanted;
  final PokemonTradeItem? pokemonOffer;

  bool get isContacted => contacted == true;
}
