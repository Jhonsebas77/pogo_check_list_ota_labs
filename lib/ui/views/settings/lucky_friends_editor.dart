part of com.pogo_check_list_ota_labs.app.views;

class LuckyFriendsEditorView extends ConsumerStatefulWidget {
  const LuckyFriendsEditorView({super.key});

  @override
  ConsumerState<LuckyFriendsEditorView> createState() =>
      _LuckyFriendsEditorViewState();
}

class _LuckyFriendsEditorViewState
    extends ConsumerState<LuckyFriendsEditorView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final List<_LuckyFriendFormData> _friends = <_LuckyFriendFormData>[];
  bool _initialized = false;
  bool _isSaving = false;

  @override
  void dispose() {
    for (_LuckyFriendFormData friend in _friends) {
      friend.dispose();
    }
    super.dispose();
  }

  void _initialize(List<LuckyFriend> friends) {
    if (_initialized) {
      return;
    }
    if (friends.isEmpty) {
      _friends.add(_LuckyFriendFormData());
    } else {
      for (LuckyFriend friend in friends) {
        _friends.add(_LuckyFriendFormData.fromLuckyFriend(friend));
      }
    }
    _initialized = true;
  }

  void _addFriend() {
    setState(() {
      _friends.add(_LuckyFriendFormData());
    });
  }

  void _removeFriend(int index) {
    if (index < 0 || index >= _friends.length) {
      return;
    }
    setState(() {
      _friends.removeAt(index).dispose();
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      showErrorSnackBar(context, 'Revisa la información capturada.');
      return;
    }
    List<LuckyFriend> updatedFriends = <LuckyFriend>[];
    for (_LuckyFriendFormData friend in _friends) {
      LuckyFriend? parsed = friend.buildLuckyFriend();
      if (parsed != null) {
        updatedFriends.add(parsed);
      }
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

  @override
  Widget build(BuildContext context) {
    AsyncValue<PokemonFirebaseState> firebaseState = ref.watch(
      firebasePokemonProvider,
    );
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: const CustomAppBar(title: 'Editar amistades con suerte'),
      backgroundColor:
          isDarkMode
              ? Theme.of(context).scaffoldBackgroundColor
              : Theme.of(context).colorScheme.primary,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addFriend,
        icon: const Icon(Icons.person_add_alt_1),
        label: const Text('Agregar amistad'),
      ),
      body: firebaseState.when(
        data: (PokemonFirebaseState data) {
          _initialize(data.allLuckyFriends);
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Form(
              key: _formKey,
              child:
                  _friends.isEmpty
                      ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: EmptyState(),
                        ),
                      )
                      : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
                        itemCount: _friends.length,
                        itemBuilder:
                            (BuildContext context, int index) =>
                                _LuckyFriendEditorCard(
                                  index: index,
                                  data: _friends[index],
                                  onRemove: () => _removeFriend(index),
                                ),
                      ),
            ),
          );
        },
        error:
            (Object error, StackTrace stackTrace) => const Center(
              child: SimpleErrorChip(
                iconData: Icons.people,
                text: 'Con la información de tus amigos con suerte',
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

class _LuckyFriendFormData {
  _LuckyFriendFormData({
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

  factory _LuckyFriendFormData.fromLuckyFriend(LuckyFriend friend) =>
      _LuckyFriendFormData(
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

class _LuckyFriendEditorCard extends StatefulWidget {
  const _LuckyFriendEditorCard({
    required this.data,
    required this.onRemove,
    required this.index,
  });

  final _LuckyFriendFormData data;
  final VoidCallback onRemove;
  final int index;

  @override
  State<_LuckyFriendEditorCard> createState() => _LuckyFriendEditorCardState();
}

class _LuckyFriendEditorCardState extends State<_LuckyFriendEditorCard> {
  @override
  Widget build(BuildContext context) => Card(
    color: Colors.black26,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    margin: const EdgeInsets.symmetric(vertical: 8),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'Amigo con suerte #${widget.index + 1}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Eliminar amistad',
                onPressed: widget.onRemove,
                icon: const Icon(Icons.delete_forever, color: Colors.red),
              ),
            ],
          ),
          TextFormField(
            controller: widget.data.nameController,
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
          SwitchListTile.adaptive(
            title: const Text(
              '¿Ya fue contactado?',
              style: TextStyle(color: Colors.white),
            ),
            value: widget.data.contacted,
            onChanged:
                (bool value) => setState(() => widget.data.contacted = value),
          ),
          PokemonTradeItemEditor(
            title: 'Pokémon que ofrece',
            data: widget.data.offerData,
          ),
          PokemonTradeItemEditor(
            title: 'Pokémon que busca',
            data: widget.data.wantedData,
          ),
        ],
      ),
    ),
  );
}
