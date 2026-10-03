part of com.pogo_check_list_ota_labs.app.views;

extension PokemonTradeCategoryX on PokemonTradeCategory {
  String get singularLabel =>
      this == PokemonTradeCategory.wanted
          ? 'Pokémon buscado'
          : 'Pokémon ofrecido';

  String get editTitle =>
      this == PokemonTradeCategory.wanted
          ? 'Editar Pokémon buscado'
          : 'Editar Pokémon ofrecido';

  String get createTitle =>
      this == PokemonTradeCategory.wanted
          ? 'Agregar Pokémon buscado'
          : 'Agregar Pokémon ofrecido';
}

class PokemonTradeItemEditorView extends ConsumerStatefulWidget {
  const PokemonTradeItemEditorView({
    required this.category,
    this.initialItem,
    this.initialIndex,
    super.key,
  });

  final PokemonTradeCategory category;
  final PokemonTradeItem? initialItem;
  final int? initialIndex;

  bool get isEditing => initialIndex != null && initialItem != null;

  @override
  ConsumerState<PokemonTradeItemEditorView> createState() =>
      _PokemonTradeItemEditorViewState();
}

class _PokemonTradeItemEditorViewState
    extends ConsumerState<PokemonTradeItemEditorView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final PokemonTradeItemFormData _formData;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _formData =
        widget.initialItem != null
            ? PokemonTradeItemFormData.fromTradeItem(widget.initialItem!)
            : PokemonTradeItemFormData();
  }

  @override
  void dispose() {
    _formData.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      showErrorSnackBar(context, 'Revisa la información capturada.');
      return;
    }
    PokemonTradeItem? item = _formData.buildPokemonTradeItem();
    if (item == null) {
      showErrorSnackBar(
        context,
        'Completa al menos el ID o nombre del Pokémon.',
      );
      return;
    }
    setState(() {
      _isSaving = true;
    });
    try {
      AsyncValue<PokemonFirebaseState> state = ref.read(
        firebasePokemonProvider,
      );
      PokemonTrade? currentTrade = state.value?.pokemonForTrade;
      List<PokemonTradeItem> wanted = List<PokemonTradeItem>.from(
        currentTrade?.wantedPokemon ?? <PokemonTradeItem>[],
      );
      List<PokemonTradeItem> offer = List<PokemonTradeItem>.from(
        currentTrade?.offerPokemon ?? <PokemonTradeItem>[],
      );

      if (widget.category == PokemonTradeCategory.wanted) {
        if (widget.initialIndex != null &&
            widget.initialIndex! < wanted.length) {
          wanted[widget.initialIndex!] = item;
        } else {
          wanted.add(item);
        }
      } else {
        if (widget.initialIndex != null &&
            widget.initialIndex! < offer.length) {
          offer[widget.initialIndex!] = item;
        } else {
          offer.add(item);
        }
      }

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

  Future<void> _delete() async {
    if (!widget.isEditing) {
      return;
    }
    setState(() {
      _isSaving = true;
    });
    try {
      AsyncValue<PokemonFirebaseState> state = ref.read(
        firebasePokemonProvider,
      );
      PokemonTrade? currentTrade = state.value?.pokemonForTrade;
      List<PokemonTradeItem> wanted = List<PokemonTradeItem>.from(
        currentTrade?.wantedPokemon ?? <PokemonTradeItem>[],
      );
      List<PokemonTradeItem> offer = List<PokemonTradeItem>.from(
        currentTrade?.offerPokemon ?? <PokemonTradeItem>[],
      );

      bool removed = false;
      if (widget.category == PokemonTradeCategory.wanted) {
        if (widget.initialIndex != null &&
            widget.initialIndex! < wanted.length) {
          wanted.removeAt(widget.initialIndex!);
          removed = true;
        }
      } else if (widget.initialIndex != null &&
          widget.initialIndex! < offer.length) {
        offer.removeAt(widget.initialIndex!);
        removed = true;
      }

      if (!removed) {
        showErrorSnackBar(
          context,
          'No fue posible eliminar el Pokémon seleccionado.',
        );
      } else {
        await ref
            .read(firebasePokemonProvider.notifier)
            .updatePokemonTrade(
              PokemonTrade(wantedPokemon: wanted, offerPokemon: offer),
              context,
            );
        if (mounted) {
          CustomNavigator().pop(context);
        }
        return;
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
    String title =
        widget.isEditing
            ? widget.category.editTitle
            : widget.category.createTitle;
    return Scaffold(
      appBar: CustomAppBar(title: title, isTransparent: true),
      body: WebContent(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: PokemonTradeItemEditor(
                    title: widget.category.singularLabel,
                    data: _formData,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: MaxWidthInput(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              if (widget.isEditing)
                OutlinedButton.icon(
                  onPressed: _isSaving ? null : _delete,
                  icon: const Icon(Icons.delete_forever),
                  label: Text(
                    _isSaving
                        ? 'Eliminando...'
                        : '''Eliminar ${widget.category.singularLabel.toLowerCase()}''',
                  ),
                ),
              if (widget.isEditing) const SizedBox(height: 8),
              ElevatedButton.icon(
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
            ],
          ),
        ),
      ),
    );
  }
}
