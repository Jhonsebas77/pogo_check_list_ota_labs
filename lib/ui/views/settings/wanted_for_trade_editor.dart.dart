part of com.pogo_check_list_ota_labs.app.views;

class PokemonTradeEditorView extends ConsumerStatefulWidget {
  const PokemonTradeEditorView({super.key});

  @override
  ConsumerState<PokemonTradeEditorView> createState() =>
      _PokemonTradeEditorViewState();
}

class _PokemonTradeEditorViewState
    extends ConsumerState<PokemonTradeEditorView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final List<PokemonTradeItemFormData> _wantedPokemon =
      <PokemonTradeItemFormData>[];
  final List<PokemonTradeItemFormData> _offerPokemon =
      <PokemonTradeItemFormData>[];
  bool _initialized = false;
  bool _isSaving = false;

  @override
  void dispose() {
    for (PokemonTradeItemFormData item in _wantedPokemon) {
      item.dispose();
    }
    for (PokemonTradeItemFormData item in _offerPokemon) {
      item.dispose();
    }
    super.dispose();
  }

  void _initialize(PokemonTrade? trade) {
    if (_initialized) {
      return;
    }
    if (trade != null) {
      for (PokemonTradeItem item in trade.wantedPokemon) {
        _wantedPokemon.add(PokemonTradeItemFormData.fromTradeItem(item));
      }
      for (PokemonTradeItem item in trade.offerPokemon) {
        _offerPokemon.add(PokemonTradeItemFormData.fromTradeItem(item));
      }
    }
    if (_wantedPokemon.isEmpty) {
      _wantedPokemon.add(PokemonTradeItemFormData());
    }
    if (_offerPokemon.isEmpty) {
      _offerPokemon.add(PokemonTradeItemFormData());
    }
    _initialized = true;
  }

  void _addWantedPokemon() {
    setState(() {
      _wantedPokemon.add(PokemonTradeItemFormData());
    });
  }

  void _addOfferPokemon() {
    setState(() {
      _offerPokemon.add(PokemonTradeItemFormData());
    });
  }

  void _removeWantedPokemon(int index) {
    if (index < 0 || index >= _wantedPokemon.length) {
      return;
    }
    setState(() {
      _wantedPokemon.removeAt(index).dispose();
    });
  }

  void _removeOfferPokemon(int index) {
    if (index < 0 || index >= _offerPokemon.length) {
      return;
    }
    setState(() {
      _offerPokemon.removeAt(index).dispose();
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      showErrorSnackBar(context, 'Revisa la información capturada.');
      return;
    }
    List<PokemonTradeItem> wanted = <PokemonTradeItem>[];
    for (PokemonTradeItemFormData item in _wantedPokemon) {
      PokemonTradeItem? parsed = item.buildPokemonTradeItem();
      wanted.add(parsed!);
        }
    List<PokemonTradeItem> offer = <PokemonTradeItem>[];
    for (PokemonTradeItemFormData item in _offerPokemon) {
      PokemonTradeItem? parsed = item.buildPokemonTradeItem();
      offer.add(parsed!);
        }
    setState(() {
      _isSaving = true;
    });
    try {
      await ref
          .read(firebasePokemonProvider.notifier)
          .updatePokemonTrade(
            PokemonTrade(wantedPokemon: wanted, offerPokemon: offer),
            context,
          );
      if (mounted) {
        CustomNavigator().pop(context);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    AsyncValue<PokemonFirebaseState> firebaseState = ref.watch(
      firebasePokemonProvider,
    );
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: const CustomAppBar(title: 'Editar intercambios'),
      backgroundColor:
          isDarkMode
              ? Theme.of(context).scaffoldBackgroundColor
              : Theme.of(context).colorScheme.primary,
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton.extended(
            heroTag: 'add-wanted',
            onPressed: _addWantedPokemon,
            icon: const Icon(Icons.add_circle_outline),
            label: const Text('Agregar buscado'),
          ),
          const SizedBox(height: 12),
          FloatingActionButton.extended(
            heroTag: 'add-offer',
            onPressed: _addOfferPokemon,
            icon: const Icon(Icons.add_circle),
            label: const Text('Agregar ofrecido'),
          ),
        ],
      ),
      body: firebaseState.when(
        data: (PokemonFirebaseState data) {
          _initialize(data.pokemonForTrade);
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 140),
                children: <Widget>[
                  const Text(
                    'Pokémon que estás buscando',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (_wantedPokemon.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: EmptyState(),
                    ),
                  ..._wantedPokemon.asMap().entries.map(
                    (MapEntry<int, PokemonTradeItemFormData> entry) =>
                        PokemonTradeItemEditor(
                          title: 'Pokémon buscado #${entry.key + 1}',
                          data: entry.value,
                          showRemoveButton: true,
                          onRemove: () => _removeWantedPokemon(entry.key),
                        ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Pokémon que estás ofreciendo',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (_offerPokemon.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: EmptyState(),
                    ),
                  ..._offerPokemon.asMap().entries.map(
                    (MapEntry<int, PokemonTradeItemFormData> entry) =>
                        PokemonTradeItemEditor(
                          title: 'Pokémon ofrecido #${entry.key + 1}',
                          data: entry.value,
                          showRemoveButton: true,
                          onRemove: () => _removeOfferPokemon(entry.key),
                        ),
                  ),
                ],
              ),
            ),
          );
        },
        error:
            (Object error, StackTrace stackTrace) => const Center(
              child: SimpleErrorChip(
                iconData: Icons.catching_pokemon,
                text: 'Con la información de los Pokemon a intercambiar',
              ),
            ),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: ElevatedButton.icon(
          onPressed: _isSaving ? null : _submit,
          icon:
              _isSaving
                  ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                  : const Icon(Icons.save),
          label: Text(_isSaving ? 'Guardando...' : 'Guardar cambios'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            backgroundColor: Theme.of(context).colorScheme.secondary,
            foregroundColor: Theme.of(context).colorScheme.onSecondary,
          ),
        ),
      ),
    );
  }
}
