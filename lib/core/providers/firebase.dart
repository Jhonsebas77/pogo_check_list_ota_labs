// ignore_for_file: always_specify_types

part of com.pogo_check_list_ota_labs.app.providers;

class FirebaseProvider extends ChangeNotifier {
  void initializeFirebase() {
    FirebaseApp firebaseApp = Firebase.app();
    FirebaseDatabase.instanceFor(app: firebaseApp, databaseURL: databaseURL);
  }
}

final Provider<FirebaseProvider> firebaseServiceProvider =
    Provider<FirebaseProvider>(
      (ProviderRef<FirebaseProvider> ref) => FirebaseProvider(),
    );

class PokemonFirebaseState {
  const PokemonFirebaseState({
    this.allGigantamaxPokemon = const <PokemonModel>[],
    this.allMegaEvolutionPokemon = const <PokemonModel>[],
    this.allPokemon = const <PokemonModel>[],
    this.trainerInformation,
    this.zygardeCells,
  });
  final List<PokemonModel> allGigantamaxPokemon;
  final List<PokemonModel> allMegaEvolutionPokemon;
  final List<PokemonModel> allPokemon;
  final TrainerModel? trainerInformation;
  final ZygardeCells? zygardeCells;

  PokemonFirebaseState copyWith({
    List<PokemonModel>? allPokemon,
    List<PokemonModel>? allGigantamaxPokemon,
    List<PokemonModel>? allMegaEvolutionPokemon,
    TrainerModel? trainerInformation,
    ZygardeCells? zygardeCells,
  }) => PokemonFirebaseState(
    allPokemon: allPokemon ?? this.allPokemon,
    allGigantamaxPokemon: allGigantamaxPokemon ?? this.allGigantamaxPokemon,
    allMegaEvolutionPokemon:
        allMegaEvolutionPokemon ?? this.allMegaEvolutionPokemon,
    trainerInformation: trainerInformation ?? this.trainerInformation,
    zygardeCells: zygardeCells ?? this.zygardeCells,
  );

  int getTotalPokemonLength() =>
      allPokemon
          .where((PokemonModel pokemon) => pokemon.available)
          .toList()
          .length;

  int getShinyAvailablePokemonLength() =>
      allPokemon
          .where((PokemonModel pokemon) => pokemon.shinyAvailable)
          .toList()
          .length;

  int getAlreadyCatchPokemonShinyLength() =>
      allPokemon
          .where((PokemonModel pokemon) => pokemon.alreadyCatchShinyVersion)
          .toList()
          .length;

  int getAlreadyCatchPokemonLength() =>
      allPokemon
          .where((PokemonModel pokemon) => pokemon.alreadyCatch)
          .toList()
          .length;

  int getAllGigantamaxPokemonLength() => allGigantamaxPokemon.length;

  int getAlreadyCatchGigantamaxPokemonLength() =>
      allGigantamaxPokemon
          .where((PokemonModel pokemon) => pokemon.alreadyCatch)
          .toList()
          .length;

  int getAllMegaEvolutionsPokemonLength() =>
      allMegaEvolutionPokemon
          .where((PokemonModel pokemon) => pokemon.available)
          .toList()
          .length;

  int getAlreadyCatchMegaEvolutionsPokemonLength() =>
      allMegaEvolutionPokemon
          .where((PokemonModel pokemon) => pokemon.alreadyCatch)
          .toList()
          .length;
}

final AsyncNotifierProvider<FirebasePokemon, PokemonFirebaseState>
firebasePokemonProvider =
    AsyncNotifierProvider<FirebasePokemon, PokemonFirebaseState>(
      FirebasePokemon.new,
    );

class FirebasePokemon extends AsyncNotifier<PokemonFirebaseState> {
  final DatabaseReference _firebaseRef = FirebaseDatabase.instance.ref();

  Future<List<PokemonModel>> _fetchGigamaxPokemonList() async {
    DataSnapshot snapshot =
        await _firebaseRef.child(firebasePokemonGigantamaxPath).get();
    List<PokemonModel> allGigantamaxPokemon = <PokemonModel>[];

    if (snapshot.exists && snapshot.value != null) {
      if (snapshot.value is Map) {
        try {
          Map<String, dynamic>.from(
            // ignore: cast_nullable_to_non_nullable
            snapshot.value as Map,
          ).forEach((String id, dynamic pokemonGigantamax) {
            if (pokemonGigantamax is Map) {
              Map<String, dynamic> _pokemonGigantamax =
                  Map<String, dynamic>.from(pokemonGigantamax);
              PokemonModel _pokemonModel = PokemonModel.fromJson(
                _pokemonGigantamax,
              );
              allGigantamaxPokemon.add(_pokemonModel);
            }
          });
          return allGigantamaxPokemon;
        } catch (e) {
          throw Exception(
            '[A] Could not fetch Gigamax Pokémon data. | ${e.toString()}',
          );
        }
      } else {
        throw Exception('[B] Could not fetch Gigamax Pokémon data.');
      }
    } else {
      throw Exception('[C] Could not fetch Gigamax Pokémon data.');
    }
  }

  Future<List<PokemonModel>> _fetchMegaEvolutionPokemonList() async {
    DataSnapshot snapshot =
        await _firebaseRef.child(firebasePokemonMegaEvolutionPath).get();
    List<PokemonModel> allMegaEvolutionPokemon = <PokemonModel>[];

    if (snapshot.exists && snapshot.value != null) {
      if (snapshot.value is Map) {
        try {
          Map<String, dynamic>.from(
            // ignore: cast_nullable_to_non_nullable
            snapshot.value as Map,
          ).forEach((String id, dynamic pokemonGigantamax) {
            if (pokemonGigantamax is Map) {
              Map<String, dynamic> _pokemonGigantamax =
                  Map<String, dynamic>.from(pokemonGigantamax);
              PokemonModel _pokemonModel = PokemonModel.fromJson(
                _pokemonGigantamax,
              );
              allMegaEvolutionPokemon.add(_pokemonModel);
            }
          });
          return allMegaEvolutionPokemon;
        } catch (e) {
          throw Exception(
            '[A] Could not fetch Megaevolution Pokémon data. | ${e.toString()}',
          );
        }
      } else {
        throw Exception('[B] Could not fetch Megaevolution Pokémon data.');
      }
    } else {
      throw Exception('[C] Could not fetch Megaevolution Pokémon data.');
    }
  }

  Future<List<PokemonModel>> _fetchPokemonList() async {
    DataSnapshot snapshot = await _firebaseRef.child(firebasePokemonPath).get();
    List<PokemonModel> allPokemon = <PokemonModel>[];

    if (snapshot.exists && snapshot.value != null && snapshot.value is List) {
      List pokemonList = List<dynamic>.from(snapshot.value! as List<dynamic>);
      for (var pokemon in pokemonList) {
        Map<String, dynamic> mapPokemon = Map<String, dynamic>.from(
          pokemon as Map,
        );
        allPokemon.add(PokemonModel.fromJson(mapPokemon));
      }
      return allPokemon;
    } else {
      throw Exception('Could not fetch Pokémon data.');
    }
  }

  Future<TrainerModel?> _fetchTrainerData() async {
    DataSnapshot snapshot = await _firebaseRef.child(firebaseTrainerPath).get();
    if (snapshot.exists && snapshot.value != null && snapshot.value is Map) {
      Map<String, dynamic> dataMap = Map<String, dynamic>.from(
        snapshot.value! as Map,
      );
      return TrainerModel.fromJson(dataMap);
    }
    return null;
  }

  Future<ZygardeCells?> _fetchZygardeData() async {
    DataSnapshot snapshot = await _firebaseRef.child(firebaseZygardePath).get();
    if (snapshot.exists && snapshot.value != null && snapshot.value is Map) {
      Map<String, dynamic> dataMap = Map<String, dynamic>.from(
        snapshot.value! as Map,
      );
      return ZygardeCells.fromJson(dataMap);
    }
    return null;
  }

  @override
  Future<PokemonFirebaseState> build() async {
    List<Object?> results = await Future.wait(<Future<Object?>>[
      _fetchPokemonList(),
      _fetchGigamaxPokemonList(),
      _fetchMegaEvolutionPokemonList(),
      _fetchTrainerData(),
      _fetchZygardeData(),
    ]);
    List<PokemonModel> pokemonList = results[0]! as List<PokemonModel>;
    List<PokemonModel> gigantamaxPokemonList =
        results[1]! as List<PokemonModel>;
    List<PokemonModel> megaEvolutionPokemonList =
        results[2]! as List<PokemonModel>;
    TrainerModel? trainerInfo = results[3] as TrainerModel?;
    ZygardeCells? zygardeInfo = results[4] as ZygardeCells?;
    return PokemonFirebaseState(
      allGigantamaxPokemon: gigantamaxPokemonList,
      allMegaEvolutionPokemon: megaEvolutionPokemonList,
      allPokemon: pokemonList,
      trainerInformation: trainerInfo,
      zygardeCells: zygardeInfo,
    );
  }

  Future<void> refreshData() async {
    state = const AsyncValue<PokemonFirebaseState>.loading();
    try {
      PokemonFirebaseState newState = await build();
      state = AsyncValue<PokemonFirebaseState>.data(newState);
    } catch (e, s) {
      state = AsyncValue<PokemonFirebaseState>.error(e, s);
    }
  }

  Future<void> updatePokemon(
    int pokemonIndex,
    PokemonModel updatedPokemon,
    BuildContext context,
  ) async {
    AsyncValue<PokemonFirebaseState> previousState = state;
    try {
      DatabaseReference ref = _firebaseRef.child(
        '$firebasePokemonPath/$pokemonIndex',
      );
      await ref.update(updatedPokemon.toJson());
      PokemonFirebaseState? currentState = state.valueOrNull;
      if (currentState != null) {
        List<PokemonModel> newPokemonList = List<PokemonModel>.from(
          currentState.allPokemon,
        );
        newPokemonList[pokemonIndex] = updatedPokemon;
        PokemonFirebaseState newState = currentState.copyWith(
          allPokemon: newPokemonList,
        );
        state = AsyncValue<PokemonFirebaseState>.data(newState);
      }
    } catch (e, s) {
      state = previousState;
      state = AsyncValue<PokemonFirebaseState>.error(e, s);
      if (context.mounted) {
        showErrorSnackBar(
          context,
          'Error during updatePokemon: $pokemonIndex | $e',
        );
      }
      rethrow;
    }
  }

  Future<void> updateMegaEvolutionPokemon(
    int pokemonIndex,
    PokemonModel updatedPokemon,
    BuildContext context,
  ) async {
    AsyncValue<PokemonFirebaseState> previousState = state;
    try {
      DatabaseReference ref = _firebaseRef.child(
        '$firebasePokemonMegaEvolutionPath/${updatedPokemon.id}',
      );
      await ref.update(updatedPokemon.toJson());
      PokemonFirebaseState? currentState = state.valueOrNull;
      if (currentState != null) {
        List<PokemonModel> newPokemonList = List<PokemonModel>.from(
          currentState.allMegaEvolutionPokemon,
        )..sort((PokemonModel a, PokemonModel b) => a.id.compareTo(b.id));
        newPokemonList[pokemonIndex] = updatedPokemon;
        PokemonFirebaseState newState = currentState.copyWith(
          allMegaEvolutionPokemon: newPokemonList,
        );
        state = AsyncValue<PokemonFirebaseState>.data(newState);
      }
    } catch (e, s) {
      state = previousState;
      state = AsyncValue<PokemonFirebaseState>.error(e, s);
      if (context.mounted) {
        showErrorSnackBar(
          context,
          'Error during updateMegaPokemon: $pokemonIndex | $e',
        );
      }
      rethrow;
    }
  }

  Future<void> updateGigantamaxPokemon(
    int pokemonIndex,
    PokemonModel updatedPokemon,
    BuildContext context,
  ) async {
    AsyncValue<PokemonFirebaseState> previousState = state;
    try {
      DatabaseReference ref = _firebaseRef.child(
        '$firebasePokemonGigantamaxPath/${updatedPokemon.id}',
      );
      await ref.update(updatedPokemon.toJson());
      PokemonFirebaseState? currentState = state.valueOrNull;
      if (currentState != null) {
        List<PokemonModel> newPokemonList = List<PokemonModel>.from(
          currentState.allGigantamaxPokemon,
        )..sort((PokemonModel a, PokemonModel b) => a.id.compareTo(b.id));
        newPokemonList[pokemonIndex] = updatedPokemon;
        PokemonFirebaseState newState = currentState.copyWith(
          allGigantamaxPokemon: newPokemonList,
        );
        state = AsyncValue<PokemonFirebaseState>.data(newState);
      }
    } catch (e, s) {
      state = previousState;
      state = AsyncValue<PokemonFirebaseState>.error(e, s);
      if (context.mounted) {
        showErrorSnackBar(
          context,
          'Error during updateGigantamaxPokemon: $pokemonIndex | $e',
        );
      }
      rethrow;
    }
  }

  Future<void> updateZygardeInformation(
    ZygardeCells zygardeCells,
    BuildContext context,
  ) async {
    AsyncValue<PokemonFirebaseState> previousState = state;
    try {
      DatabaseReference ref = _firebaseRef.child(firebaseZygardePath);
      await ref.update(zygardeCells.toJson());
      PokemonFirebaseState? currentState = state.valueOrNull;
      if (currentState != null) {
        PokemonFirebaseState newState = currentState.copyWith(
          zygardeCells: zygardeCells,
        );
        state = AsyncValue<PokemonFirebaseState>.data(newState);
        if (context.mounted) {
          showSuccessSnackBar(context, '[Zygarde actualizado]');
        }
      }
    } catch (e, s) {
      state = previousState;
      state = AsyncValue<PokemonFirebaseState>.error(e, s);
      if (context.mounted) {
        showErrorSnackBar(
          context,
          'Error during updateZygardeInformation: $zygardeCells | $e',
        );
      }
      rethrow;
    }
  }

  Future<void> updateTrainerInformation(
    TrainerModel updatedTrainer,
    BuildContext context,
  ) async {
    AsyncValue<PokemonFirebaseState> previousState = state;
    PokemonFirebaseState? cachedState = state.valueOrNull;
    try {
      DatabaseReference ref = _firebaseRef.child(firebaseTrainerPath);
      await ref.update(updatedTrainer.toJson());
      PokemonFirebaseState baseState =
          cachedState ??
          previousState.valueOrNull ??
          const PokemonFirebaseState();
      PokemonFirebaseState newState = baseState.copyWith(
        trainerInformation: updatedTrainer,
      );
      state = AsyncValue<PokemonFirebaseState>.data(newState);
      if (context.mounted) {
        showSuccessSnackBar(context, '[Información de entrenador actualiza]');
      }
    } catch (e, s) {
      state = previousState;
      state = AsyncValue<PokemonFirebaseState>.error(e, s);
      if (context.mounted) {
        showErrorSnackBar(context, 'Error during updateTrainerInformation: $e');
      }
      rethrow;
    }
  }
}
