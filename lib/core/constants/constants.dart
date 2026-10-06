library com.pogo_check_list_ota_labs.app.constants;

import 'package:flutter/material.dart';

part 'groups.dart';
part 'pokemon_types.dart';

const String supabaseUrl = String.fromEnvironment('SUPABASE_URL');
const String supabasePublishableKey = String.fromEnvironment(
  'SUPABASE_PUBLISHABLE_KEY',
);
const String hardcodedEmail = String.fromEnvironment('AUTH_EMAIL');

const String databaseURL = String.fromEnvironment('FIREBASE_DATABASE_URL');
const String pokemonDetailPath = 'https://pokeapi.co/api/v2/pokemon/';
const String placeHolderImage = 'https://i.ibb.co/KcX8h982/download-16.png';

// [Firebase Path]
const String firebaseLuckyFriendsPath = '/po_go_check_list/lucky_friends';
const String firebaseOriginPath = '/po_go_check_list';
const String firebasePokemonGigantamaxPath = '/po_go_check_list/gigantamax';
const String firebasePokemonMegaEvolutionPath =
    '/po_go_check_list/megaevolution';
const String firebasePokemonPath = '/po_go_check_list/pokemon';
const String firebasePokemonForTradePath = '/po_go_check_list/traded_pokemon';
const String firebaseTrainerPath = '/po_go_check_list/trainer';
const String firebaseZygardePath = '/po_go_check_list/zygarde_cells';

final List<String> teamsOptions = <String>['mystic', 'valor', 'instinct'];

String getSelectedTeamFromString(String team) {
  switch (team) {
    case 'valor':
      return 'Equipo Valor';
    case 'mystic':
      return 'Equipo Mystic';
    case 'instinct':
      return 'Equipo Instinct';
    default:
      return team;
  }
}
