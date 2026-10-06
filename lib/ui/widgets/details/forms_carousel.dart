part of com.pogo_check_list_ota_labs.app.widgets;

/// Una forma del Pokémon registrada en Firebase (regional, Mega o Gigamax).
class PokemonFormEntry {
  const PokemonFormEntry({
    required this.kind,
    required this.pokemon,
    required this.spriteFolder,
  });

  final String kind;
  final PokemonModel pokemon;

  /// Carpeta de assets con el sprite (`pokedex_sprites`,
  /// `pokedex_gigantamax`…).
  final String spriteFolder;

  String get label =>
      pokemon.isAlternativeForm
          ? '${pokemon.name} (${pokemon.formTag!.name})'
          : pokemon.name;

  String get sprite =>
      'assets/$spriteFolder/${pokemon.id}${pokemon.formSuffix}.png';

  String get fallbackSprite => 'assets/$spriteFolder/${pokemon.id}.png';

  /// Formas de la especie [id] en el estado de Firebase: las alternativas de
  /// la especie base, sus Megas y su Gigamax.
  static List<PokemonFormEntry> fromState(PokemonFirebaseState state, int id) {
    bool sameSpecies(PokemonModel p) => p.id == id;
    return <PokemonFormEntry>[
      for (PokemonModel form
          in state.allPokemon.firstWhereOrNull(sameSpecies)?.alternativeForms ??
              const <PokemonModel>[])
        PokemonFormEntry(
          kind: form.formTag?.name ?? 'Forma',
          pokemon: form,
          spriteFolder: 'pokedex_sprites',
        ),
      for (PokemonModel mega in state.allMegaEvolutionPokemon.where(
        sameSpecies,
      ))
        for (PokemonModel form in mega.withForms)
          PokemonFormEntry(
            kind: 'Mega',
            pokemon: form,
            spriteFolder: 'pokedex_mega_evolutions',
          ),
      for (PokemonModel giga in state.allGigantamaxPokemon.where(sameSpecies))
        for (PokemonModel form in giga.withForms)
          PokemonFormEntry(
            kind: 'Gigamax',
            pokemon: form,
            spriteFolder: 'pokedex_gigantamax',
          ),
    ];
  }
}

/// Carrusel horizontal de formas de la especie (solo lectura).
class FormsCarousel extends StatelessWidget {
  const FormsCarousel({required this.forms, super.key});

  final List<PokemonFormEntry> forms;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 72,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: forms.length,
      separatorBuilder:
          (BuildContext context, int index) => const SizedBox(width: 12),
      itemBuilder: (BuildContext context, int index) {
        PokemonFormEntry form = forms[index];
        return Semantics(
          label: '${form.kind} ${form.label}',
          excludeSemantics: true,
          child: Container(
            padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Row(
              children: <Widget>[
                Image.asset(
                  form.sprite,
                  height: 56,
                  width: 56,
                  cacheHeight: 112,
                  cacheWidth: 112,
                  fit: BoxFit.contain,
                  errorBuilder:
                      (
                        BuildContext context,
                        Object error,
                        StackTrace? stackTrace,
                      ) => Image.asset(
                        form.fallbackSprite,
                        height: 56,
                        width: 56,
                        cacheHeight: 112,
                        cacheWidth: 112,
                        fit: BoxFit.contain,
                      ),
                ),
                const SizedBox(width: 8),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      form.kind,
                      style: Paragraphs.smallSemiBold.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      form.label,
                      style: Paragraphs.disclaimer.copyWith(
                        color: onPrimaryMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}
