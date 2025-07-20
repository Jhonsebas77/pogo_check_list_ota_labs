part of com.pogo_check_list_ota_labs.app.services;

class PokemonAPIService {
  Future<PokemonDetail> getPokemon(String pokemonId) async {
    http.Response response = await http.get(
      Uri.parse('$pokemonDetailPath$pokemonId'),
    );
    if (response.statusCode == 200) {
      return PokemonDetail.fromJSON(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    } else {
      throw Exception('Failed to load Pokémon');
    }
  }
}
