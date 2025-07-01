part of com.pogo_check_list_ota_labs.app.providers;

class FirebaseProvider extends ChangeNotifier {
  final DatabaseReference _firebaseRef = FirebaseDatabase.instance.ref();
  bool isLoading = false;
  List<PokemonModel> allPokemon = <PokemonModel>[];
  List<PokemonModel> allGigantamaxPokemon = <PokemonModel>[];

  void initializeFirebase() {
    FirebaseApp firebaseApp = Firebase.app();
    FirebaseDatabase.instanceFor(app: firebaseApp, databaseURL: databaseURL);
  }

  Future<void> getPokemonData(BuildContext context) async {
    isLoading = true;
    notifyListeners();
    DataSnapshot snapshot = await _firebaseRef.child(firebasePokemonPath).get();
    allPokemon = <PokemonModel>[];
    if (snapshot.exists && snapshot.value != null) {
      if (snapshot.value is List) {
        try {
          List<dynamic>.from(
            // ignore: cast_nullable_to_non_nullable
            snapshot.value as List<dynamic>,
          ).forEach((dynamic pokemon) {
            Map<String, dynamic> _mapPokemon = Map<String, dynamic>.from(
              // ignore: cast_nullable_to_non_nullable, always_specify_types
              pokemon as Map,
            );
            PokemonModel _pokemonModel = PokemonModel.fromJSON(_mapPokemon);
            allPokemon.add(_pokemonModel);
          });
        } catch (e) {
          if (context.mounted) {
            showErrorSnackBar(
              context,
              'Error during data conversion to Map<String, dynamic>: $e',
            );
          }
        }
      } else {
        if (context.mounted) {
          showErrorSnackBar(
            context,
            '''Snapshot value is not a Map. Actual type: ${snapshot.value.runtimeType}''',
          );
        }
      }
    } else {
      if (context.mounted) {
        showErrorSnackBar(
          context,
          'No data available at this path, or snapshot.value is null.',
        );
      }
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> getPokemonGigantamaxData(BuildContext context) async {
    isLoading = true;
    notifyListeners();
    DataSnapshot snapshot =
        await _firebaseRef.child(firebasePokemonGigantamaxPath).get();
    allGigantamaxPokemon = <PokemonModel>[];
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
        } catch (e) {
          if (context.mounted) {
            showErrorSnackBar(
              context,
              'Error during data conversion to Map<String, dynamic>: $e',
            );
          }
        }
      } else {
        if (context.mounted) {
          showErrorSnackBar(
            context,
            '''Snapshot value is not a Map. Actual type: ${snapshot.value.runtimeType}''',
          );
        }
      }
    } else {
      if (context.mounted) {
        showErrorSnackBar(
          context,
          'No data available at this path, or snapshot.value is null.',
        );
      }
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> updatePokemon(
    BuildContext context,
    int customId,
    PokemonModel _pokemonModel,
  ) async {
    try {
      DatabaseReference ref = FirebaseDatabase.instance.ref(
        '$firebasePokemonPath/$customId',
      );
      await ref.update(_pokemonModel.toJSON());
    } catch (e) {
      if (context.mounted) {
        showErrorSnackBar(
          context,
          'Error during updatePokemon: $customId | $e',
        );
      }
    }
    notifyListeners();
  }
}
