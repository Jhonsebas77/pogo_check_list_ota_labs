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
    this.formTag,
    this.alternativeForms,
  });

  factory PokemonModel.fromJson(Map<String, dynamic> json) {
    dynamic rawFormTag = json['alternative_form'];
    dynamic rawAlternativeForms = json['alternative_forms'];
    return PokemonModel(
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
      formTag:
          rawFormTag is Map
              ? PokemonAlternativeForm.fromJson(
                  Map<String, dynamic>.from(rawFormTag),
                )
              : const PokemonAlternativeForm(),
      alternativeForms:
          rawAlternativeForms is List
              ? rawAlternativeForms
                  .whereType<Map<dynamic, dynamic>>()
                  .map(
                    (Map<dynamic, dynamic> form) => PokemonModel.fromJson(
                      Map<String, dynamic>.from(form),
                    ),
                  )
                  .toList()
              : null,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'already_catch_shiny_version': alreadyCatchShinyVersion,
    'already_catch': alreadyCatch,
    'available': available,
    'id': id,
    'name': name,
    'shiny_available': shinyAvailable,
    'tradable': tradable,
    if (formTag != null) 'alternative_form': formTag!.toJson(),
    if (alternativeForms != null && alternativeForms!.isNotEmpty)
      'alternative_forms':
          alternativeForms!
              .map((PokemonModel form) => form.toJson())
              .toList(),
  };

  final bool alreadyCatch;
  final bool alreadyCatchShinyVersion;
  final bool available;
  final bool shinyAvailable;
  final bool tradable;
  final int id;
  final String name;
  /// Descriptor que identifica *qué* forma es esta entrada (p. ej. Alola):
  /// `{ id, name, order }`. Vacío en la entrada base de la especie.
  final PokemonAlternativeForm? formTag;

  /// Formas alternativas anidadas de esta especie (p. ej. Raichu-Alola).
  /// Solo la entrada base la usa; cada forma es un [PokemonModel] con el mismo
  /// [id] de especie y su propio [formTag] descriptor.
  final List<PokemonModel>? alternativeForms;

  /// `true` si esta entrada representa una forma alternativa concreta
  /// (su descriptor [formTag] tiene un `id` no vacío).
  bool get isAlternativeForm => formTag?.id?.isNotEmpty ?? false;

  /// Sufijo de archivo para el sprite de la forma (p. ej. `-alola`), o vacío
  /// para la forma base.
  String get formSuffix => isAlternativeForm ? '-${formTag!.id}' : '';

  /// Orden de la forma dentro de la especie (0 = base).
  int get formOrder => formTag?.order ?? 0;

  /// La especie base seguida de sus formas alternativas, aplanada para mostrar.
  List<PokemonModel> get withForms => <PokemonModel>[
    this,
    ...?alternativeForms,
  ];

  PokemonModel copyWith({
    bool? alreadyCatch,
    bool? alreadyCatchShinyVersion,
    bool? available,
    bool? shinyAvailable,
    bool? tradable,
    int? id,
    String? name,
    PokemonAlternativeForm? formTag,
    List<PokemonModel>? alternativeForms,
  }) => PokemonModel(
    alreadyCatch: alreadyCatch ?? this.alreadyCatch,
    alreadyCatchShinyVersion:
        alreadyCatchShinyVersion ?? this.alreadyCatchShinyVersion,
    available: available ?? this.available,
    shinyAvailable: shinyAvailable ?? this.shinyAvailable,
    tradable: tradable ?? this.tradable,
    id: id ?? this.id,
    name: name ?? this.name,
    formTag: formTag ?? this.formTag,
    alternativeForms: alternativeForms ?? this.alternativeForms,
  );

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
    formTag,
    Object.hashAll(alternativeForms ?? const <PokemonModel>[]),
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
