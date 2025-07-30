part of com.pogo_check_list_ota_labs.app.models;

class ZygardeCells {
  const ZygardeCells({
    required this.actualForm,
    required this.forms,
    required this.quantity,
  });

  factory ZygardeCells.fromJSON(Map<String, dynamic> json) => ZygardeCells(
    actualForm:
        json['actual_form'] != null ? json['actual_form'] as String : '',
    forms: <PokemonModel>[],
    quantity: json['quantity'] != null ? json['quantity'] as int : 0,
  );

  Map<String, dynamic> toJSON() => <String, dynamic>{
    'actualForm': actualForm,
    'forms': forms,
    'quantity': quantity,
  };

  final int quantity;
  final List<PokemonModel> forms;
  final String actualForm;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ZygardeCells &&
          runtimeType == other.runtimeType &&
          hashCode == other.hashCode;

  @override
  int get hashCode => Object.hash(quantity, actualForm);

  @override
  String toString() => '''ZygardeCells(
    'quantity': $quantity,
    'actual_form':  $actualForm
  )''';
}
