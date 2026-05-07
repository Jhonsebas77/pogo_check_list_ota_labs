part of com.pogo_check_list_ota_labs.app.providers;

final Provider<PokemonAPIService> pokemonServiceProvider =
    Provider<PokemonAPIService>(
      (Ref<PokemonAPIService> ref) => PokemonAPIService(),
    );

final FutureProviderFamily<PokemonDetail, String> pokemonProvider =
    FutureProvider.family<PokemonDetail, String>((
      // ignore: deprecated_member_use
      FutureProviderRef<PokemonDetail> ref,
      String pokemonId,
    ) {
      PokemonAPIService apiService = ref.watch(pokemonServiceProvider);
      return apiService.getPokemon(pokemonId);
    });
