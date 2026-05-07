part of com.pogo_check_list_ota_labs.app.models;

class ZygardeCells {
  const ZygardeCells({
    required this.actualForm,
    required this.forms,
    required this.limit,
    required this.quantity,
  });

  factory ZygardeCells.fromJson(Map<String, dynamic> json) {
    List<dynamic> rawList = (json['forms'] as List<dynamic>?) ?? <dynamic>[];
    return ZygardeCells(
      actualForm:
          json['actual_form'] != null ? json['actual_form'] as String : '',
      forms:
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
    'forms':
        forms?.map((PokemonModel pokemonForm) => pokemonForm.toJson()).toList(),
    'limit': limit,
    'quantity': quantity,
  };

  final int quantity;
  final int limit;
  final List<PokemonModel>? forms;
  final String actualForm;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ZygardeCells &&
          runtimeType == other.runtimeType &&
          hashCode == other.hashCode;

  @override
  int get hashCode => Object.hash(quantity, actualForm, forms, limit);

  @override
  String toString() => '''ZygardeCells(
   ${toJson()}
  )''';
}
