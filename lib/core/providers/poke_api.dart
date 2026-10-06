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

final FutureProviderFamily<PokemonSpecies, String> pokemonSpeciesProvider =
    FutureProvider.family<PokemonSpecies, String>((
      // ignore: deprecated_member_use
      FutureProviderRef<PokemonSpecies> ref,
      String pokemonId,
    ) {
      PokemonAPIService apiService = ref.watch(pokemonServiceProvider);
      return apiService.getPokemonSpecies(pokemonId);
    });

/// Cadena evolutiva de la especie `pokemonId`. `null` si la especie no tiene
/// cadena registrada en la API.
final FutureProviderFamily<EvolutionNode?, String> evolutionChainProvider =
    FutureProvider.family<EvolutionNode?, String>((
      // ignore: deprecated_member_use
      FutureProviderRef<EvolutionNode?> ref,
      String pokemonId,
    ) async {
      PokemonSpecies species = await ref.watch(
        pokemonSpeciesProvider(pokemonId).future,
      );
      String? url = species.evolutionChainUrl;
      if (url == null) return null;
      return ref.watch(pokemonServiceProvider).getEvolutionChain(url);
    });
