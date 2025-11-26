part of com.pogo_check_list_ota_labs.app.views;

class LuckyFriendEditorView extends ConsumerStatefulWidget {
  const LuckyFriendEditorView({
    this.initialFriend,
    this.initialIndex,
    super.key,
  });

  final LuckyFriend? initialFriend;
  final int? initialIndex;

  bool get isEditing => initialFriend != null && initialIndex != null;

  @override
  ConsumerState<LuckyFriendEditorView> createState() =>
      _LuckyFriendEditorViewState();
}

class _LuckyFriendEditorViewState extends ConsumerState<LuckyFriendEditorView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final LuckyFriendFormData _formData;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _formData =
        widget.initialFriend != null
            ? LuckyFriendFormData.fromLuckyFriend(widget.initialFriend!)
            : LuckyFriendFormData();
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
    LuckyFriend? friend = _formData.buildLuckyFriend();
    if (friend == null) {
      showErrorSnackBar(context, 'Ingresa al menos el nombre de tu amigo.');
      return;
    }

    AsyncValue<PokemonFirebaseState> state = ref.read(firebasePokemonProvider);
    List<LuckyFriend> updatedFriends = List<LuckyFriend>.from(
      state.value?.allLuckyFriends ?? <LuckyFriend>[],
    );

    if (widget.isEditing) {
      int? index = widget.initialIndex;
      if (index == null || index < 0 || index >= updatedFriends.length) {
        showErrorSnackBar(
          context,
          'No fue posible actualizar la amistad seleccionada.',
        );
        return;
      }
      updatedFriends[index] = friend;
    } else {
      updatedFriends.add(friend);
    }

    setState(() {
      _isSaving = true;
    });
    try {
      await ref
          .read(firebasePokemonProvider.notifier)
          .updateLuckyFriends(updatedFriends, context);
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

    AsyncValue<PokemonFirebaseState> state = ref.read(firebasePokemonProvider);
    List<LuckyFriend> updatedFriends = List<LuckyFriend>.from(
      state.value?.allLuckyFriends ?? <LuckyFriend>[],
    );
    int? index = widget.initialIndex;
    if (index == null || index < 0 || index >= updatedFriends.length) {
      showErrorSnackBar(
        context,
        'No fue posible eliminar la amistad seleccionada.',
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });
    try {
      updatedFriends.removeAt(index);
      await ref
          .read(firebasePokemonProvider.notifier)
          .updateLuckyFriends(updatedFriends, context);
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
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    String title =
        widget.isEditing
            ? 'Editar amigo con suerte'
            : 'Agregar amigo con suerte';
    return Scaffold(
      appBar: CustomAppBar(title: title, isTransparent: true),
      backgroundColor:
          isDarkMode
              ? Theme.of(context).scaffoldBackgroundColor
              : Theme.of(context).colorScheme.primary,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
            children: <Widget>[
              Card(
                color: Colors.black26,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        'Información del amigo',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _formData.nameController,
                        decoration: inputDecoration(
                          context,
                          label: 'Nombre del amigo',
                          icon: Icons.person,
                        ),
                        validator: (String? value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Ingresa el nombre del amigo';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: PokemonTradeItemEditor(
                  title: 'Pokémon que ofrece',
                  data: _formData.offerData,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: PokemonTradeItemEditor(
                  title: 'Pokémon que busca',
                  data: _formData.wantedData,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (widget.isEditing)
              OutlinedButton.icon(
                onPressed: _isSaving ? null : _delete,
                icon: const Icon(Icons.delete_forever),
                label: Text(_isSaving ? 'Eliminando...' : 'Eliminar amistad'),
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
    );
  }
}

class LuckyFriendFormData {
  LuckyFriendFormData({
    String? name,
    this.contacted = false,
    PokemonTradeItem? pokemonOffer,
    PokemonTradeItem? pokemonWanted,
  }) : nameController = TextEditingController(text: name ?? ''),
       offerData =
           pokemonOffer != null
               ? PokemonTradeItemFormData.fromTradeItem(pokemonOffer)
               : PokemonTradeItemFormData(),
       wantedData =
           pokemonWanted != null
               ? PokemonTradeItemFormData.fromTradeItem(pokemonWanted)
               : PokemonTradeItemFormData();

  factory LuckyFriendFormData.fromLuckyFriend(LuckyFriend friend) =>
      LuckyFriendFormData(
        name: friend.name,
        contacted: friend.isContacted,
        pokemonOffer: friend.pokemonOffer,
        pokemonWanted: friend.pokemonWanted,
      );

  final TextEditingController nameController;
  bool contacted;
  final PokemonTradeItemFormData offerData;
  final PokemonTradeItemFormData wantedData;

  LuckyFriend? buildLuckyFriend() {
    String name = nameController.text.trim();
    if (name.isEmpty) {
      return null;
    }
    return LuckyFriend(
      name: name,
      contacted: contacted,
      pokemonOffer: offerData.buildPokemonTradeItem(),
      pokemonWanted: wantedData.buildPokemonTradeItem(),
    );
  }

  void dispose() {
    nameController.dispose();
    offerData.dispose();
    wantedData.dispose();
  }
}
