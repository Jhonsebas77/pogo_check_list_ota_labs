part of com.pogo_check_list_ota_labs.app.models;

class LuckyFriend {
  const LuckyFriend({
    required this.name,
    this.pokemonWanted,
    this.pokemonOffer,
    this.contacted,
  });

  factory LuckyFriend.fromJson(Map<String, dynamic> json) {
    dynamic rawPokemonOffer = json['pokemon_offer'];
    dynamic rawPokemonWanted = json['pokemon_want'];
    return LuckyFriend(
      name: json['name'] != null ? json['name'] as String : '',
      pokemonWanted:
          rawPokemonWanted is Map
              ? PokemonTradeItem.fromJson(Map.from(rawPokemonWanted))
              : null,
      pokemonOffer:
          rawPokemonOffer is Map
              ? PokemonTradeItem.fromJson(Map.from(rawPokemonOffer))
              : null,
      contacted: json['contacted'] != null && json['contacted'] as bool,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'name': name,
    'contacted': contacted,
  };

  final String name;
  final bool? contacted;
  final PokemonTradeItem? pokemonWanted;
  final PokemonTradeItem? pokemonOffer;

  bool get isContacted => contacted == true;

  @override
  String toString() => '''LuckyFriend(
    'name': $name,
    'contacted':  $contacted,
    'pokemonWanted':  $pokemonWanted,
    'pokemonOffer': $pokemonOffer
  )''';
}
