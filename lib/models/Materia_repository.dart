import 'dart:convert';

import 'package:projeto_radio/http/http_client.dart';

import 'Materia.dart';

class MateriaRepository {
  static String routeUrl = '/api/materia/getmaterias';

  Future<List<Materia>> getMaterias() async {
    final String completeRouteUrl = '$routeUrl';

    final response = await HttpClient.get(route: completeRouteUrl);
    final List<dynamic> decodedJson = jsonDecode(response.body);

    return decodedJson
        .map((dynamic json) => Materia.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
