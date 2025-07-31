part of com.pogo_check_list_ota_labs.app.models;

class PokemonAlternativeForm {
  const PokemonAlternativeForm({this.id, this.name, this.order});

  factory PokemonAlternativeForm.fromJson(Map<String, dynamic> json) =>
      PokemonAlternativeForm(
        order: json['order'] != null ? json['order'] as int : 0,
        id: json['id'] != null ? json['id'] as String : '',
        name: json['name'] != null ? json['name'] as String : '',
      );

  Map<String, dynamic> toJSON() => <String, dynamic>{
    'id': id,
    'name': name,
    'order': order,
  };

  final int? order;
  final String? id;
  final String? name;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PokemonAlternativeForm &&
          runtimeType == other.runtimeType &&
          hashCode == other.hashCode;

  @override
  int get hashCode => Object.hash(id, name, order);

  @override
  String toString() => '''PokemonAlternativeForm(
    'id': $id,
    'name': $name,
    'order':  $order,
  )''';
}
