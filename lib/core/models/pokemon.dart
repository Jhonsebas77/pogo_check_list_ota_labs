part of com.pogo_check_list_ota_labs.app.models;

class PokemonModel {
  const PokemonModel({
    required this.alreadyCatch,
    required this.alreadyCatchShinyVersion,
    required this.available,
    required this.id,
    required this.name,
    required this.shinyAvailable,
    required this.tradable,
  });

  factory PokemonModel.fromJSON(Map<String, dynamic> json) => PokemonModel(
    alreadyCatch:
        json['already_catch'] != null && json['already_catch'] as bool,
    alreadyCatchShinyVersion:
        json['already_catch_shiny_version'] != null &&
        json['already_catch_shiny_version'] as bool,
    available: json['available'] != null && json['available'] as bool,
    id: json['id'] != null ? json['id'] as int : 0,
    name: json['name'] != null ? json['name'] as String : '',
    shinyAvailable:
        json['shiny_available'] != null && json['shiny_available'] as bool,
    tradable: json['tradable'] != null && json['tradable'] as bool,
  );

  Map<String, dynamic> toJSON() => <String, dynamic>{
    'already_catch_shiny_version': alreadyCatchShinyVersion,
    'already_catch': alreadyCatch,
    'available': available,
    'id': id,
    'name': name,
    'shiny_available': shinyAvailable,
    'tradable': tradable,
  };

  final bool alreadyCatch;
  final bool alreadyCatchShinyVersion;
  final bool available;
  final bool shinyAvailable;
  final bool tradable;
  final int id;
  final String name;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PokemonModel &&
          runtimeType == other.runtimeType &&
          hashCode == other.hashCode;

  @override
  int get hashCode => Object.hash(
    alreadyCatch,
    alreadyCatchShinyVersion,
    available,
    id,
    name,
    shinyAvailable,
    tradable,
  );

  @override
  String toString() => '''PokemonModel(
    'already_catch_shiny_version': $alreadyCatchShinyVersion,
    'already_catch':  $alreadyCatch,
    'available':  $available,
    'id': $id,
    'name': $name,
    'shiny_available':  $shinyAvailable,
    'tradable':  $tradable,
  )''';
}
