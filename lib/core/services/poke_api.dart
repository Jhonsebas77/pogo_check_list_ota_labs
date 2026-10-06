part of com.pogo_check_list_ota_labs.app.services;

class PokemonAPIService {
  static const Logger _log = Logger('PokemonApiService');

  Future<PokemonDetail> getPokemon(String pokemonId) async =>
      PokemonDetail.fromJson(await _get('$pokemonDetailPath$pokemonId'));

  Future<PokemonSpecies> getPokemonSpecies(String pokemonId) async =>
      PokemonSpecies.fromJson(await _get('$pokemonSpeciesPath$pokemonId'));

  Future<EvolutionNode> getEvolutionChain(String url) async =>
      EvolutionNode.fromJson(
        (await _get(url))['chain'] as Map<String, dynamic>,
      );

  Future<Map<String, dynamic>> _get(String url) async {
    Uri uri = Uri.parse(url);
    Stopwatch stopwatch = Stopwatch()..start();
    _log.debug('GET $uri');
    http.Response response;
    try {
      response = await http.get(uri);
    } catch (e) {
      _log.debug('GET $uri falló (${stopwatch.elapsedMilliseconds} ms): $e');
      rethrow;
    }
    _log.debug(
      'GET $uri → ${response.statusCode} '
      '(${stopwatch.elapsedMilliseconds} ms | ${response.bodyBytes.length} B)',
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to load Pokémon');
    }
  }
}
