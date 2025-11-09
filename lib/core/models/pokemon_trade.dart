part of com.pogo_check_list_ota_labs.app.models;

class PokemonTrade {
  PokemonTrade({required this.wantedPokemon, required this.offerPokemon});

  factory PokemonTrade.fromJson(Map<String, dynamic> json) {
    dynamic offerList = json['offer_pokemon'];
    dynamic wantedList = json['wanted_pokemon'];

    List<PokemonTradeItem> wanted =
        wantedList
            .map((item) {
              if (item is Map) {
                return PokemonTradeItem.fromJson(
                  Map<String, dynamic>.from(item),
                );
              }
            })
            .toList()
            .cast<PokemonTradeItem>();

    List<PokemonTradeItem> offer =
        offerList
            .map((item) {
              if (item is Map) {
                return PokemonTradeItem.fromJson(
                  Map<String, dynamic>.from(item),
                );
              }
            })
            .toList()
            .cast<PokemonTradeItem>();

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
