part of com.pogo_check_list_ota_labs.app.providers;

final Provider<PokemonAPIService> pokemonServiceProvider =
    Provider<PokemonAPIService>(
      (ProviderRef<PokemonAPIService> ref) => PokemonAPIService(),
    );

final FutureProviderFamily<PokemonDetail, String> pokemonProvider =
    FutureProvider.family<PokemonDetail, String>((
      FutureProviderRef ref,
      String pokemonId,
    ) {
      PokemonAPIService apiService = ref.watch(pokemonServiceProvider);
      return apiService.getPokemon(pokemonId);
    });
