part of com.pogo_check_list_ota_labs.app.views;

class DetailsScreen extends ConsumerWidget {
  const DetailsScreen({required this.pokemonId, super.key});
  static const String route = '/pokemon/details';
  final int pokemonId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<PokemonDetail> pokemonAsyncValue = ref.watch(
      pokemonProvider('$pokemonId'),
    );
    return SafeArea(
      child: Scaffold(
        appBar: pokemonAsyncValue.when(
          loading: () => const CustomAppBar(isLoading: true),
          error:
              (Object error, StackTrace stackTrace) =>
                  CustomAppBar(title: '$pokemonId'),

          data: (PokemonDetail pokemon) => CustomAppBar(title: pokemon.name),
        ),
        body: WebContent(
          child: pokemonAsyncValue.when(
            loading: () => const PokemonDetailShimmer(),
            error:
                (Object error, StackTrace stackTrace) => SimpleErrorChip(
                  iconData: Icons.catching_pokemon,
                  error: error.toString(),
                  stackTrace: stackTrace,
                  text: 'Con el detalle del Pokémon $pokemonId',
                ),
            data: (PokemonDetail pokemon) => _DetailsContent(pokemon: pokemon),
          ),
        ),
      ),
    );
  }
}

class _DetailsContent extends ConsumerWidget {
  const _DetailsContent({required this.pokemon});

  final PokemonDetail pokemon;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // La especie solo aporta categoría y descripción: si falla o aún carga,
    // el resto del detalle se muestra igual.
    PokemonSpecies? species =
        ref.watch(pokemonSpeciesProvider('${pokemon.id}')).valueOrNull;
    EvolutionNode? evolutionChain =
        ref.watch(evolutionChainProvider('${pokemon.id}')).valueOrNull;
    PokemonFirebaseState? firebaseState =
        ref.watch(firebasePokemonProvider).valueOrNull;
    PokemonModel? collectionEntry = firebaseState?.allPokemon.firstWhereOrNull(
      (PokemonModel p) => p.id == pokemon.id,
    );
    List<PokemonFormEntry> forms =
        firebaseState == null
            ? const <PokemonFormEntry>[]
            : PokemonFormEntry.fromState(firebaseState, pokemon.id);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          DetailHero(pokemon: pokemon, genus: species?.genus),
          const SizedBox(height: 24),
          if (collectionEntry != null) ...<Widget>[
            const DetailSectionTitle('Mi colección'),
            CollectionStatusRow(pokemon: collectionEntry),
            const SizedBox(height: 16),
          ],
          PokemonInfoCard(pokemon: pokemon),
          const SizedBox(height: 16),
          if (pokemon.stats.isNotEmpty) ...<Widget>[
            BaseStatsCard(stats: pokemon.stats, total: pokemon.totalStats),
            const SizedBox(height: 16),
          ],
          TypeMatchupCard(types: pokemon.types),
          const SizedBox(height: 16),
          if (evolutionChain != null &&
              evolutionChain.evolvesTo.isNotEmpty) ...<Widget>[
            EvolutionChainCard(
              chain: evolutionChain,
              currentId: pokemon.id,
              collection: firebaseState?.allPokemon ?? const <PokemonModel>[],
            ),
            const SizedBox(height: 16),
          ],
          if (forms.isNotEmpty) ...<Widget>[
            const DetailSectionTitle('Formas'),
            FormsCarousel(forms: forms),
            const SizedBox(height: 16),
          ],
          if (species?.flavorText != null)
            DetailCard(
              title: 'Descripción',
              icon: Icons.menu_book_outlined,
              child: Text(
                species!.flavorText!,
                style: Paragraphs.small.copyWith(
                  color: onPrimaryMuted,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
