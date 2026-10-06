part of com.pogo_check_list_ota_labs.app.views;

class TrainerEditorView extends ConsumerStatefulWidget {
  const TrainerEditorView({super.key});
  static const String route = '/settings/trainer-editor';

  @override
  ConsumerState<TrainerEditorView> createState() => _TrainerEditorViewState();
}

class _TrainerEditorViewState extends ConsumerState<TrainerEditorView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _trainerIdController;
  late final TextEditingController _nickNameController;
  late final TextEditingController _levelController;

  String? _selectedTeam;
  bool _isSaving = false;
  TrainerModel? _lastSyncedTrainer;

  @override
  void initState() {
    super.initState();
    _trainerIdController =
        TextEditingController()..addListener(_onFormFieldChanged);
    _nickNameController =
        TextEditingController()..addListener(_onFormFieldChanged);
    _levelController =
        TextEditingController()..addListener(_onFormFieldChanged);
  }

  @override
  void dispose() {
    _trainerIdController
      ..removeListener(_onFormFieldChanged)
      ..dispose();
    _nickNameController
      ..removeListener(_onFormFieldChanged)
      ..dispose();
    _levelController
      ..removeListener(_onFormFieldChanged)
      ..dispose();
    super.dispose();
  }

  void _onFormFieldChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _syncFormWithTrainer(TrainerModel? trainer) {
    if (_shouldSkipTrainerSync(trainer)) {
      return;
    }

    String trainerId = trainer?.trainerId ?? '';
    if (_trainerIdController.text != trainerId) {
      _trainerIdController.text = trainerId;
    }

    String nickName = trainer?.nickName ?? '';
    if (_nickNameController.text != nickName) {
      _nickNameController.text = nickName;
    }

    String level = trainer?.level ?? '';
    if (_levelController.text != level) {
      _levelController.text = level;
    }

    String? normalizedTeam = _normalizeTeam(trainer?.team);
    if (_selectedTeam != normalizedTeam) {
      _selectedTeam = normalizedTeam;
    }

    _lastSyncedTrainer = trainer;
  }

  bool _shouldSkipTrainerSync(TrainerModel? trainer) {
    if (_lastSyncedTrainer == null && trainer == null) {
      return true;
    }

    if (_lastSyncedTrainer == null || trainer == null) {
      return false;
    }

    return _areTrainerValuesEqual(trainer, _lastSyncedTrainer!);
  }

  bool _areTrainerValuesEqual(TrainerModel a, TrainerModel b) =>
      (a.trainerId ?? '').trim() == (b.trainerId ?? '').trim() &&
      (a.nickName ?? '').trim() == (b.nickName ?? '').trim() &&
      (a.level ?? '').trim() == (b.level ?? '').trim() &&
      _normalizeTeam(a.team) == _normalizeTeam(b.team);

  String? _normalizeTeam(String? team) {
    if (team == null) {
      return null;
    }
    String normalized = team.trim().toLowerCase();
    if (teamsOptions.contains(normalized)) {
      return normalized;
    }
    return null;
  }

  bool _hasChanges(TrainerModel? trainer) {
    String originalTrainerId = trainer?.trainerId ?? '';
    String originalNickName = trainer?.nickName ?? '';
    String originalLevel = trainer?.level ?? '';
    String? originalTeam = _normalizeTeam(trainer?.team);

    return _trainerIdController.text.trim() != originalTrainerId.trim() ||
        _nickNameController.text.trim() != originalNickName.trim() ||
        _levelController.text.trim() != originalLevel.trim() ||
        _normalizeTeam(_selectedTeam) != originalTeam;
  }

  Future<void> _submit(TrainerModel? trainer) async {
    if (!_formKey.currentState!.validate() || _isSaving) {
      return;
    }
    FocusScope.of(context).unfocus();
    setState(() {
      _isSaving = true;
    });

    TrainerModel updatedTrainer = TrainerModel(
      trainerId: _trainerIdController.text.trim(),
      nickName: _nickNameController.text.trim(),
      level: _levelController.text.trim(),
      team: _normalizeTeam(_selectedTeam),
    );

    try {
      await ref
          .read(firebasePokemonProvider.notifier)
          .updateTrainerInformation(updatedTrainer, context);
      if (!mounted) {
        return;
      }
      showSuccessSnackBar(
        context,
        '''[Entrenador actualizado]\n${updatedTrainer.nickName}''',
      );
    } catch (_) {
      if (context.mounted) {
        showErrorSnackBar(context, 'Error during updateTrainerInformation');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Widget _buildDropdown() => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: DropdownButtonFormField<String>(
      initialValue: (_selectedTeam?.isNotEmpty ?? false) ? _selectedTeam : null,
      onChanged:
          _isSaving
              ? null
              : (String? value) {
                setState(() {
                  _selectedTeam = value;
                });
              },
      items:
          teamsOptions
              .map<DropdownMenuItem<String>>(
                (String value) => DropdownMenuItem<String>(
                  value: value,
                  child: Text(getSelectedTeamFromString(value)),
                ),
              )
              .toList(),
      decoration: inputDecoration(context, icon: Icons.flag),
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Selecciona un equipo';
        }
        return null;
      },
    ),
  );

  @override
  Widget build(BuildContext context) {
    AsyncValue<PokemonFirebaseState> firebaseState = ref.watch(
      firebasePokemonProvider,
    );
    return SafeArea(
      child: Scaffold(
        appBar: const CustomAppBar(title: 'Editar entrenador'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: WebContent(
          child: firebaseState.when(
            data: (PokemonFirebaseState data) {
              TrainerModel? trainer = data.trainerInformation;
              _syncFormWithTrainer(trainer);
              return GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: MaxWidthInput(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          const SettingsTitleSection(title: 'Entrenador'),
                          CustomTextField(
                            label: 'Apodo',
                            icon: Icons.person,
                            controller: _nickNameController,
                            validator: (String? value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Ingresa el apodo del entrenador';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: CustomTextField(
                                  label: 'Trainer ID',
                                  icon: Icons.badge,
                                  controller: _trainerIdController,
                                  validator: (String? value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Ingresa el Trainer ID';
                                    }
                                    if (value.trim().length < 12) {
                                      return '''El Trainer ID debe contener al menos 12 dígitos''';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: CustomTextField(
                                  label: 'Nivel',
                                  icon: Icons.leaderboard,
                                  controller: _levelController,
                                  inputType: TextInputType.number,
                                  validator: (String? value) {
                                    int maxLevel = 80;
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Ingresa el nivel actual';
                                    }
                                    int? parsed = int.tryParse(value.trim());
                                    if (parsed == null ||
                                        parsed <= 0 ||
                                        parsed > maxLevel) {
                                      return 'Ingresa un nivel válido (1 - 80)';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SettingsTitleSection(title: 'Equipo'),
                          Row(
                            children: <Widget>[
                              Expanded(child: _buildDropdown()),
                              const SizedBox(width: 16),
                              Padding(
                                padding: const EdgeInsets.only(right: 14),
                                child: _buildTrainerPreview(context),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
            error:
                (Object error, StackTrace stackTrace) => const Center(
                  child: SimpleErrorChip(
                    iconData: Icons.person,
                    text: 'Con la información del entrenador',
                  ),
                ),
            loading: () => const Center(child: CircularProgressIndicator()),
          ),
        ),
        bottomNavigationBar: firebaseState.when(
          data: (PokemonFirebaseState data) {
            TrainerModel? trainer = data.trainerInformation;
            return SafeArea(
              minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 8,
                  right: 8,
                  bottom: 16,
                  top: 8,
                ),
                child: MaxWidthInput(
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed:
                          !_isSaving && _hasChanges(trainer)
                              ? () => _submit(trainer)
                              : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                        foregroundColor:
                            Theme.of(context).colorScheme.onSecondary,
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        _isSaving ? 'Guardando...' : 'Guardar cambios',
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
          error:
              (Object error, StackTrace stackTrace) => const SizedBox.shrink(),
          loading:
              () => SafeArea(
                minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: FilledButton.icon(
                  onPressed: null,
                  icon: const SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  label: const Text('Cargando...'),
                ),
              ),
        ),
      ),
    );
  }

  Widget _buildTrainerPreview(BuildContext context) {
    String? team = _normalizeTeam(_selectedTeam);
    if (team == null) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.circular(24),
        ),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.groups, color: Colors.white70, size: 48),
            SizedBox(height: 8),
            Text(
              'Selecciona un equipo para previsualizar',
              textAlign: TextAlign.center,
              style: TextStyle(color: onPrimaryMuted),
            ),
          ],
        ),
      );
    }
    return Stack(
      alignment: AlignmentDirectional.center,
      children: <Widget>[
        Image.asset(
          'assets/bg_holder_pokemon.png',
          height: 64,
          width: 64,
          fit: BoxFit.fill,
        ),
        Image.asset(
          'assets/team_$team.png',
          height: 50,
          width: 50,
          fit: BoxFit.fill,
        ),
      ],
    );
  }
}
