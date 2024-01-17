import 'dart:convert'; // Per realitzar conversions entre tipus de dades
import 'package:http/http.dart' as http;

import '../model/comarca.dart'; // Per realitzar peticions HTTP

class ComarquesRepository {
  /*
  
  Classe ComarquesRepository:
  
  Implementa l'accés a les dades relatives a les comarques a través
  de peticions HTTP.

  */

  // URL base de l'API
  static const String baseUrl =
      'https://node-comarques-rest-server-production.up.railway.app/api/comarques';

  Future<List<dynamic>> obtenirProvincies() async {
    // Retorna un Future amb la llista de províncies (provincia i imatge)

    var data = await http.get(Uri.parse(baseUrl));
    if (data.statusCode == 200) {
      String body = utf8.decode(data.bodyBytes);
      final bodyJSON = jsonDecode(body) as List;
      return bodyJSON;
    } else {
      return [];
    }
  }

  Future<List<dynamic>> obtenirComarquesAmbImatge(String provincia) async {
    // Retorna un Future amb la llista de comarques (nom i img) de la província
    // proporcionada com a argument

    String url = '$baseUrl/comarquesAmbImatge/$provincia';

    var data = await http.get(Uri.parse(url));

    if (data.statusCode == 200) {
      String body = utf8.decode(data.bodyBytes);
      final bodyJSON = jsonDecode(body) as List;
      return bodyJSON;
    } else {
      return [];
    }
  }

  Future<Comarca?> obtenirInfoComarca(String comarca) async {
    // Retorna un Future que conté un objecte de tipus Comarca
    // amb tota la informació sobre una comarca proporcionada com argument.

    String url = '$baseUrl/infoComarca/$comarca';

    var data = await http.get(Uri.parse(url));

    if (data.statusCode == 200) {
      String body = utf8.decode(data.bodyBytes);
      final bodyJSON = jsonDecode(body);
      print(body);

      Comarca comarca = Comarca(
        comarca: bodyJSON["comarca"],
        capital: bodyJSON["capital"],
        poblacio: int.parse(bodyJSON["poblacio"].replaceAll(".", "")),
        img: bodyJSON["img"],
        desc: bodyJSON["desc"],
        latitud: bodyJSON["latitud"],
        longitud: bodyJSON["longitud"],
      );
      return comarca;
    } else {
      return null;
    }
  }
}
