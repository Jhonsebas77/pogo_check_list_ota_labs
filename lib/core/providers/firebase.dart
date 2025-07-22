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
    this.allPokemon = const <PokemonModel>[],
    this.allGigantamaxPokemon = const <PokemonModel>[],
    this.allMegaEvolutionPokemon = const <PokemonModel>[],
    this.trainerInformation,
  });
  final List<PokemonModel> allPokemon;
  final List<PokemonModel> allGigantamaxPokemon;
  final List<PokemonModel> allMegaEvolutionPokemon;
  final TrainerModel? trainerInformation;

  PokemonFirebaseState copyWith({
    List<PokemonModel>? allPokemon,
    List<PokemonModel>? allGigantamaxPokemon,
    List<PokemonModel>? allMegaEvolutionPokemon,
    TrainerModel? trainerInformation,
  }) => PokemonFirebaseState(
    allPokemon: allPokemon ?? this.allPokemon,
    allGigantamaxPokemon: allGigantamaxPokemon ?? this.allGigantamaxPokemon,
    allMegaEvolutionPokemon:
        allMegaEvolutionPokemon ?? this.allMegaEvolutionPokemon,
    trainerInformation: trainerInformation ?? this.trainerInformation,
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
            // ignore: cast_nullable_to_non_nullable, always_specify_types
            snapshot.value as Map,
          ).forEach((String id, dynamic pokemonGigantamax) {
            if (pokemonGigantamax is Map) {
              Map<String, dynamic> _pokemonGigantamax =
                  Map<String, dynamic>.from(pokemonGigantamax);
              PokemonModel _pokemonModel = PokemonModel.fromJSON(
                _pokemonGigantamax,
              );
              allGigantamaxPokemon.add(_pokemonModel);
            }
          });
          return allGigantamaxPokemon;
        } catch (e) {
          throw Exception('Could not fetch Pokémon data.');
        }
      } else {
        throw Exception('Could not fetch Pokémon data.');
      }
    } else {
      throw Exception('Could not fetch Pokémon data.');
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
            // ignore: cast_nullable_to_non_nullable, always_specify_types
            snapshot.value as Map,
          ).forEach((String id, dynamic pokemonGigantamax) {
            if (pokemonGigantamax is Map) {
              Map<String, dynamic> _pokemonGigantamax =
                  Map<String, dynamic>.from(pokemonGigantamax);
              PokemonModel _pokemonModel = PokemonModel.fromJSON(
                _pokemonGigantamax,
              );
              allMegaEvolutionPokemon.add(_pokemonModel);
            }
          });
          return allMegaEvolutionPokemon;
        } catch (e) {
          throw Exception('Could not fetch Pokémon data.');
        }
      } else {
        throw Exception('Could not fetch Pokémon data.');
      }
    } else {
      throw Exception('Could not fetch Pokémon data.');
    }
  }

  Future<List<PokemonModel>> _fetchPokemonList() async {
    DataSnapshot snapshot = await _firebaseRef.child(firebasePokemonPath).get();
    List<PokemonModel> allPokemon = <PokemonModel>[];

    if (snapshot.exists && snapshot.value != null && snapshot.value is List) {
      List pokemonList = List<dynamic>.from(snapshot.value! as List<dynamic>);
      for (final pokemon in pokemonList) {
        Map<String, dynamic> mapPokemon = Map<String, dynamic>.from(
          pokemon as Map,
        );
        allPokemon.add(PokemonModel.fromJSON(mapPokemon));
      }
      allPokemon.removeAt(0);
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
      return TrainerModel.fromJSON(dataMap);
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
    ]);
    List<PokemonModel> pokemonList = results[0]! as List<PokemonModel>;
    List<PokemonModel> gigantamaxPokemonList =
        results[1]! as List<PokemonModel>;
    List<PokemonModel> megaEvolutionPokemonList =
        results[2]! as List<PokemonModel>;
    TrainerModel? trainerInfo = results[3] as TrainerModel?;
    return PokemonFirebaseState(
      allGigantamaxPokemon: gigantamaxPokemonList,
      allPokemon: pokemonList,
      trainerInformation: trainerInfo,
      allMegaEvolutionPokemon: megaEvolutionPokemonList,
    );
  }

  /// A public method the UI can call to refresh the data.
  Future<void> refreshData() async {
    // This automatically sets the provider's state to loading.
    state = const AsyncValue.loading();
    try {
      // Re-run the logic from the build method to get fresh data.
      PokemonFirebaseState newState = await build();
      // If successful, update the state with the new data.
      state = AsyncValue.data(newState);
    } catch (e, s) {
      // If an error occurs, update the state with the error.
      state = AsyncValue.error(e, s);
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
      await ref.update(updatedPokemon.toJSON());
      PokemonFirebaseState? currentState = state.valueOrNull;
      if (currentState != null) {
        List<PokemonModel> newPokemonList = List<PokemonModel>.from(
          currentState.allPokemon,
        );
        newPokemonList[pokemonIndex] = updatedPokemon;
        PokemonFirebaseState newState = currentState.copyWith(
          allPokemon: newPokemonList,
        );
        state = AsyncValue.data(newState);
      }
    } catch (e, s) {
      state = previousState;
      state = AsyncValue.error(e, s);
      if (context.mounted) {
        showErrorSnackBar(
          context,
          'Error during updatePokemon: $pokemonIndex | $e',
        );
      }
      rethrow;
    }
  }
}
