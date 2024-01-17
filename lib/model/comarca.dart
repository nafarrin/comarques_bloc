/*
Classe Comarca. 
 */

class Comarca {
  // Afegim late per dir que s'inicialitzarà posteriorment.
  // També podríem afegir un valor per defecte

  late String comarca;
  String? capital;
  int? poblacio;
  String? img;
  String? desc;
  double? latitud;
  double? longitud;

  // Constructor amb arguments amb nom,
  // obligatoris i opcionals

  Comarca(
      {required this.comarca,
      this.capital,
      this.poblacio,
      this.img,
      this.desc,
      this.latitud,
      this.longitud});

  // Inicialització amb diccionari
  Comarca.fromJSON(Map<String, dynamic> objecteJSON) {
    comarca = objecteJSON["comarca"] ?? "";
    capital = objecteJSON["capital"] ?? "";
    poblacio = int.parse(objecteJSON["poblacio"]);
    img = objecteJSON["img"] ?? "";
    desc = objecteJSON["desc"] ?? "";
    latitud = objecteJSON["coordenades"][0] ?? 0.0;
    longitud = objecteJSON["coordenades"][1] ?? 0.0;
  }

  @override
  String toString() {
    return '''\x1B[34mnom:\t\t\x1B[36m$comarca\n\x1B[0m
\x1B[34mcapital:\t\x1B[36m$capital\n\x1B[0m
\x1B[34mpoblacio:\t\x1B[36m${poblacio.toString()}\n\x1B[0m
\x1B[34mImatge:\t\t\x1B[36m$img\n\x1B[0m
\x1B[34mdescripció:\t\x1B[36m$desc\n\x1B[0m
\x1B[34mCoordenades:\t\x1B[36m($latitud, $longitud)\x1B[0m''';
  }
}
