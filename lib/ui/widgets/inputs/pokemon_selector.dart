part of com.pogo_check_list_ota_labs.app.widgets;

class PokemonSelector extends ConsumerStatefulWidget {
  const PokemonSelector({
    required this.onChanged,
    this.selectedPokemonId,
    this.label,
    super.key,
  });

  final int? selectedPokemonId;
  final ValueChanged<int?> onChanged;
  final String? label;

  @override
  ConsumerState<PokemonSelector> createState() => _PokemonSelectorState();
}

class _PokemonSelectorState extends ConsumerState<PokemonSelector> {
  late TextEditingController _controller;
  PokemonModel? _selectedPokemon;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void didUpdateWidget(covariant PokemonSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedPokemonId != oldWidget.selectedPokemonId) {
      _updateSelectionFromId();
    }
  }

  void _updateSelectionFromId() {
    final List<PokemonModel> allPokemon =
        ref.read(firebasePokemonProvider).valueOrNull?.allPokemon ??
        <PokemonModel>[];
    if (widget.selectedPokemonId != null && allPokemon.isNotEmpty) {
      try {
        final PokemonModel pokemon = allPokemon.firstWhere(
          (PokemonModel p) => p.id == widget.selectedPokemonId,
        );
        setState(() {
          _selectedPokemon = pokemon;
          _controller.text = '${pokemon.id} - ${pokemon.name}';
        });
      } catch (_) {
        // Pokemon not found
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<PokemonFirebaseState> pokemonState = ref.watch(
      firebasePokemonProvider,
    );

    return pokemonState.when(
      data: (PokemonFirebaseState state) {
        final List<PokemonModel> allPokemon = state.allPokemon;

        // Initial update if needed
        if (_selectedPokemon == null && widget.selectedPokemonId != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _updateSelectionFromId();
          });
        }

        return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Autocomplete<PokemonModel>(
              initialValue: TextEditingValue(text: _controller.text),
              displayStringForOption:
                  (PokemonModel option) => '${option.id} - ${option.name}',
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text == '') {
                  return const Iterable<PokemonModel>.empty();
                }
                return allPokemon.where((PokemonModel option) {
                  final String query = textEditingValue.text.toLowerCase();
                  return option.name.toLowerCase().contains(query) ||
                      option.id.toString().contains(query);
                });
              },
              onSelected: (PokemonModel selection) {
                setState(() {
                  _selectedPokemon = selection;
                  _controller.text = '${selection.id} - ${selection.name}';
                });
                widget.onChanged(selection.id);
              },
              fieldViewBuilder: (
                BuildContext context,
                TextEditingController fieldTextEditingController,
                FocusNode fieldFocusNode,
                VoidCallback onFieldSubmitted,
              ) {
                // Sync internal controller with the one provided by Autocomplete if needed
                // But here we want to control the text when selection changes from outside
                // So we might need a different approach or just let Autocomplete handle it
                // and update the controller text when external ID changes.
                
                // Actually, Autocomplete manages its own controller if we don't pass one,
                // but fieldViewBuilder gives us one.
                // We need to keep our _controller in sync or just use the one from builder.
                
                if (_controller.text != fieldTextEditingController.text) {
                    fieldTextEditingController.text = _controller.text;
                }

                return TextField(
                  controller: fieldTextEditingController,
                  focusNode: fieldFocusNode,
                  style: const TextStyle(color: Colors.white),
                  decoration: inputDecoration(
                    context,
                    label: widget.label ?? 'Seleccionar Pokémon',
                    icon: Icons.search,
                  ).copyWith(
                    suffixIcon:
                        _selectedPokemon != null
                            ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                'assets/pokedex_sprites/${_selectedPokemon!.id}.png',
                                width: 24,
                                height: 24,
                                errorBuilder:
                                    (
                                      BuildContext context,
                                      Object error,
                                      StackTrace? stackTrace,
                                    ) => const Icon(
                                      Icons.catching_pokemon,
                                      color: Colors.white70,
                                    ),
                              ),
                            )
                            : null,
                  ),
                );
              },
              optionsViewBuilder: (
                BuildContext context,
                AutocompleteOnSelected<PokemonModel> onSelected,
                Iterable<PokemonModel> options,
              ) {
                return Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    elevation: 4.0,
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                     borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
                    child: SizedBox(
                      width: constraints.maxWidth,
                      height: 200.0,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(8.0),
                        itemCount: options.length,
                        itemBuilder: (BuildContext context, int index) {
                          final PokemonModel option = options.elementAt(index);
                          return ListTile(
                            leading: Image.asset(
                              'assets/pokedex_sprites/${option.id}.png',
                              width: 30,
                              height: 30,
                               errorBuilder:
                                    (
                                      BuildContext context,
                                      Object error,
                                      StackTrace? stackTrace,
                                    ) => const Icon(
                                      Icons.catching_pokemon,
                                      color: Colors.white70,
                                    ),
                            ),
                            title: Text(
                              option.name,
                              style: TextStyle(
                                color:
                                    Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                              ),
                            ),
                            subtitle: Text(
                              '#${option.id}',
                              style: TextStyle(
                                color:
                                    Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant
                                        .withOpacity(0.7),
                              ),
                            ),
                            onTap: () {
                              onSelected(option);
                            },
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
      loading:
          () => const Center(
            child: CircularProgressIndicator(),
          ), // Or a shimmer
      error:
          (Object error, StackTrace stack) =>
              Text('Error: $error', style: const TextStyle(color: Colors.red)),
    );
  }
}
