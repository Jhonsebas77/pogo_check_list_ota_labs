part of com.pogo_check_list_ota_labs.app.models;

class PokemonDetail {
  PokemonDetail({
    required this.name,
    required this.id,
    required this.imageUrl,
    required this.types,
  });

  factory PokemonDetail.fromJSON(Map<String, dynamic> json) {
    String name = json['name'] as String;
    String capitalizedName = name[0].toUpperCase() + name.substring(1);

    String imageUrl =
        json['sprites']['other']['official-artwork']['front_default'] as String;

    List<String> typesList =
        (json['types'] as List)
            .map((typeInfo) => typeInfo['type']['name'] as String)
            .toList();

    return PokemonDetail(
      name: capitalizedName,
      id: json['id'] as int,
      imageUrl: imageUrl,
      types: typesList,
    );
  }
  final String name;
  final int id;
  final String imageUrl;
  final List<String> types;
}
