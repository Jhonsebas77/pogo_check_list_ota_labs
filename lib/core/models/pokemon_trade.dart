part of com.pogo_check_list_ota_labs.app.models;

class PokemonTrade {
  PokemonTrade({required this.wantedPokemon, required this.offerPokemon});

  factory PokemonTrade.fromJson(Map<String, dynamic> json) {
    List<dynamic> offerList =
        (json['offer_pokemon'] as List<dynamic>?) ?? <dynamic>[];
    List<dynamic> wantedList =
        (json['wanted_pokemon'] as List<dynamic>?) ?? <dynamic>[];

    List<PokemonTradeItem> wanted = wantedList
        .whereType<Map<dynamic, dynamic>>()
        .map<PokemonTradeItem>(
          (Map<dynamic, dynamic> item) =>
              PokemonTradeItem.fromJson(Map<String, dynamic>.from(item)),
        )
        .toList();

    List<PokemonTradeItem> offer = offerList
        .whereType<Map<dynamic, dynamic>>()
        .map<PokemonTradeItem>(
          (Map<dynamic, dynamic> item) =>
              PokemonTradeItem.fromJson(Map<String, dynamic>.from(item)),
        )
        .toList();

    return PokemonTrade(wantedPokemon: wanted, offerPokemon: offer);
  }

  final List<PokemonTradeItem> wantedPokemon;
  final List<PokemonTradeItem> offerPokemon;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'wanted_pokemon':
        wantedPokemon
            .map((PokemonTradeItem pokemon) => pokemon.toJson())
            .toList(),
    'offer_pokemon':
        offerPokemon
            .map((PokemonTradeItem pokemon) => pokemon.toJson())
            .toList(),
  };
  @override
  String toString() => '''PokemonTrade(
    'wantedPokemon': $wantedPokemon,
    'offerPokemon':  $offerPokemon,
  )''';
}
