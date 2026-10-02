part of com.pogo_check_list_ota_labs.app.models;

class ZygardeCells {
  const ZygardeCells({
    required this.actualForm,
    required this.alternativeForms,
    required this.limit,
    required this.quantity,
  });

  factory ZygardeCells.fromJson(Map<String, dynamic> json) {
    // Se unifica con el resto de formas alternativas bajo 'alternative_forms'.
    // Se mantiene el fallback a 'forms' por compatibilidad con datos previos.
    List<dynamic> rawList =
        (json['alternative_forms'] as List<dynamic>?) ??
        (json['forms'] as List<dynamic>?) ??
        <dynamic>[];
    return ZygardeCells(
      actualForm:
          json['actual_form'] != null ? json['actual_form'] as String : '',
      alternativeForms:
          rawList
              .whereType<Map<dynamic, dynamic>>()
              .map(
                (Map<dynamic, dynamic> item) =>
                    PokemonModel.fromJson(Map<String, dynamic>.from(item)),
              )
              .toList(),
      limit: json['limit'] != null ? json['limit'] as int : 0,
      quantity: json['quantity'] != null ? json['quantity'] as int : 0,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'actual_form': actualForm,
    'alternative_forms':
        alternativeForms
            ?.map((PokemonModel pokemonForm) => pokemonForm.toJson())
            .toList(),
    'limit': limit,
    'quantity': quantity,
  };

  final int quantity;
  final int limit;
  final List<PokemonModel>? alternativeForms;
  final String actualForm;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ZygardeCells &&
          runtimeType == other.runtimeType &&
          hashCode == other.hashCode;

  @override
  int get hashCode =>
      Object.hash(quantity, actualForm, alternativeForms, limit);

  @override
  String toString() => '''ZygardeCells(
   ${toJson()}
  )''';
}
