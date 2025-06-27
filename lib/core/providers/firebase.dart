// ignore_for_file: avoid_print
part of com.pogo_check_list_ota_labs.app.providers;

class FirebaseProvider extends ChangeNotifier {
  final DatabaseReference _firebaseRef = FirebaseDatabase.instance.ref();
  bool isLoading = false;
  List<PokemonModel> allPokemon = <PokemonModel>[];

  void initializeFirebase() {
    FirebaseApp firebaseApp = Firebase.app();
    FirebaseDatabase.instanceFor(app: firebaseApp, databaseURL: databaseURL);
  }

  Future<void> getPokemonData() async {
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
          print('Error during data conversion to Map<String, dynamic>: $e');
        }
      } else {
        print(
          '''Snapshot value is not a Map. Actual type: ${snapshot.value.runtimeType}''',
        );
        print('Snapshot value: ${snapshot.value}');
      }
    } else {
      print('No data available at this path, or snapshot.value is null.');
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> updatePokemon(int customId, PokemonModel _pokemonModel) async {
    try {
      DatabaseReference ref = FirebaseDatabase.instance.ref(
        '$firebasePokemonPath/$customId',
      );
      await ref.update(_pokemonModel.toJSON());
      print('Update Pokémon in: ${'$firebasePokemonPath/$customId'}');
    } catch (e) {
      print('Error during updatePokemon: $customId | $e');
    }
    notifyListeners();
  }
}
